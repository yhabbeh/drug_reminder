import 'dart:io';

import 'package:drug_dose/features/home/contact_picker_screen.dart';
import 'package:drug_dose/services/schedule_type.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/reminder_bloc.dart';
import 'bloc/reminder_event.dart';
import 'bloc/reminder_state.dart';

import 'package:permission_handler/permission_handler.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController medController = TextEditingController();
  final TextEditingController doseController = TextEditingController();

  DateTime? selectedDateTime;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReminderBloc, ReminderState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(title: const Text("Medicine Reminder")),
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  TextField(
                    controller: medController,
                    decoration: const InputDecoration(labelText: "Medicine"),
                    onChanged: (val) =>
                        context.read<ReminderBloc>().add(MedicineChanged(val)),
                  ),
                  TextField(
                    controller: doseController,
                    decoration: const InputDecoration(labelText: "Dose"),
                    onChanged: (val) =>
                        context.read<ReminderBloc>().add(DoseChanged(val)),
                  ),
                  const SizedBox(height: 12),
                  DropdownButton<ScheduleType>(
                    value: state.type,
                    onChanged: (val) {
                      if (val != null) {
                        context.read<ReminderBloc>().add(
                          ScheduleTypeChanged(val),
                        );
                      }
                    },
                    items: ScheduleType.values.map((type) {
                      return DropdownMenuItem(
                        value: type,
                        child: Text(
                          type.toString().split('.').last.toUpperCase(),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () async {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (ctx) => BlocProvider.value(
                            value: context.read<ReminderBloc>(),
                            child: const MultiContactPickerScreen(),
                          ),
                        ),
                      );
                    },
                    child: const Text("Select Contacts"),
                  ),
                  Text(
                    "Selected: ${state.contacts.map((e) => e.displayName).join(", ")}",
                  ),
                  const SizedBox(height: 20),

                  // Time/Date picker button
                  ElevatedButton(
                    onPressed: () async {
                      // Pick time first
                      final pickedTime = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                      );
                      if (pickedTime == null) return;

                      // If once, pick a date too
                      DateTime pickedDate = DateTime.now();
                      if (state.type == ScheduleType.once) {
                        final date = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate: DateTime.now().add(
                            const Duration(days: 365),
                          ),
                        );
                        if (date == null) return;
                        pickedDate = date;
                      }

                      // Combine date + time
                      final dateTime = DateTime(
                        pickedDate.year,
                        pickedDate.month,
                        pickedDate.day,
                        pickedTime.hour,
                        pickedTime.minute,
                      );

                      setState(() => selectedDateTime = dateTime);
                    },
                    child: Text(
                      selectedDateTime == null
                          ? "Pick Reminder Time"
                          : "Time: ${selectedDateTime!.hour.toString().padLeft(2, '0')}:${selectedDateTime!.minute.toString().padLeft(2, '0')}",
                    ),
                  ),

                  const SizedBox(height: 20),

                  ElevatedButton(
                    onPressed: () async {
                      if (Platform.isAndroid &&
                          (await Permission.scheduleExactAlarm.isDenied)) {
                        await openAppSettings(); // or use permission_handler’s openAppSettings
                      } else if (await Permission.sms.request().isGranted &&
                          selectedDateTime != null) {
                        context.read<ReminderBloc>().add(
                          ScheduleReminder(selectedDateTime!),
                        );
                      }
                    },
                    child: const Text("Set Reminder"),
                  ),

                  if (state.scheduled)
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        "Reminder Scheduled ✅",
                        style: TextStyle(color: Colors.green),
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

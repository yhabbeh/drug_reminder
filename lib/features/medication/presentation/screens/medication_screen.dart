import 'package:drug_dose/features/medication/presentation/bloc/medication_event.dart';
import 'package:drug_dose/features/medication/presentation/bloc/medication_state.dart';
import 'package:drug_dose/features/medication/presentation/screens/medication_form_screen.dart';
import 'package:drug_dose/features/medication/presentation/widgets/medication_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/medication_bloc.dart';

class MedicationListScreen extends StatelessWidget {
  const MedicationListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF3B82F6),
        toolbarHeight: 70,
        centerTitle: true,
        title: const Text(
          'Med Reminder',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.white,
            letterSpacing: 0.4,
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFEFF6FF), Colors.white],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: BlocBuilder<MedicationBloc, MedicationState>(
                  builder: (context, state) {
                    // In future, use state.medications (List<Medication>) from Bloc
                    final medications = context
                        .read<MedicationBloc>()
                        .medications;
                    return RefreshIndicator(
                      onRefresh: () async {
                        // Trigger a reload event in Bloc if needed
                        // context.read<MedicationBloc>().add(LoadMedications());
                        await Future.delayed(const Duration(seconds: 1));
                      },
                      child: medications.isEmpty
                          ? Center(
                              child: Text(
                                'No medications added yet.',
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                            )
                          : ListView.separated(
                              itemCount: medications.length,
                              separatorBuilder: (context, index) =>
                                  const Divider(),
                              padding: const EdgeInsets.all(24),
                              itemBuilder: (context, index) {
                                final med = medications[index];
                                return MedicationCard(
                                  medicationName: med.name,
                                  scheduleText: _getScheduleText(med),
                                  smsMessage: med.smsMessage,
                                  recipients: med.recipients
                                      .map((c) => c.name)
                                      .toList(),
                                  isActive: med.active,
                                  onPause: () {
                                    if (med.active) {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            '${med.name} paused successfully!',
                                          ),
                                          backgroundColor: Colors.orange,
                                        ),
                                      );
                                    }
                                    context.read<MedicationBloc>().add(
                                      PauseMedication(med),
                                    );
                                  },
                                  onDelete: () {
                                    _showDeleteDialog(context, med);
                                  },
                                );
                              },
                            ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // context.read<MedicationBloc>().add(
          //   AddMedication(
          //     Medication(
          //       name: '',
          //       smsMessage: '',
          //       recipients: [],
          //       repeatHours: 1,
          //       active: true,
          //       scheduleType: ScheduleType.everyXHours,
          //     ),
          //   ),
          // );

          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const MedicationFormView()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  String _getScheduleText(dynamic med) {
    // Replace with actual logic based on Medication model
    if (med.scheduleType != null && med.repeatHours != null) {
      return 'Every ${med.repeatHours} hours';
    }
    return 'Custom schedule';
  }

  void _showDeleteDialog(BuildContext context, med) {
    // Accepts medication to delete
    // void _showDeleteDialog(BuildContext context, Medication med)
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete Medication'),
        content: const Text(
          'Are you sure you want to delete this medication? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              context.read<MedicationBloc>().add(DeleteMedication(med));
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Medication deleted'),
                  backgroundColor: Colors.red,
                ),
              );
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}

import 'package:drug_dose/features/medication/domain/models/contact.dart';
import 'package:drug_dose/features/medication/presentation/widgets/contact_chip.dart';
import 'package:drug_dose/features/medication/presentation/widgets/custom_text_field.dart';
import 'package:drug_dose/features/medication/presentation/widgets/schedule_toggle.dart';
import 'package:flutter/material.dart';
import 'package:drug_dose/features/medication/domain/models/schedule_type.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/medication_bloc.dart';
import '../bloc/medication_event.dart';
import '../bloc/medication_state.dart';

class MedicationFormView extends StatelessWidget {
  const MedicationFormView({super.key});

  @override
  Widget build(BuildContext context) {
    return MedicationFormScreen();
  }
}

class MedicationFormScreen extends StatefulWidget {
  const MedicationFormScreen({super.key});

  @override
  State<MedicationFormScreen> createState() => _MedicationFormScreenState();
}

class _MedicationFormScreenState extends State<MedicationFormScreen> {
  late final TextEditingController _nameController;
  late final TextEditingController _hoursController;
  late final TextEditingController _messageController;

  @override
  void initState() {
    super.initState();
    final bloc = context.read<MedicationBloc>();
    _nameController = TextEditingController(text: bloc.medicationName);
    _hoursController = TextEditingController(text: bloc.repeatHours.toString());
    _messageController = TextEditingController(text: bloc.smsMessage);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _hoursController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MedicationBloc, MedicationState>(
      listener: (context, state) {
        if (state is MedicationSuccessState) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Medication saved successfully!'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.of(context).pop();
        } else if (state is MedicationErrorState) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Failed to save medication.'),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      builder: (context, state) {
        final bloc = context.read<MedicationBloc>();
        // Keep controllers in sync with Bloc fields
        if (_nameController.text != bloc.medicationName) {
          _nameController.text = bloc.medicationName;
        }
        if (_hoursController.text != bloc.repeatHours.toString()) {
          _hoursController.text = bloc.repeatHours.toString();
        }
        if (_messageController.text != bloc.smsMessage) {
          _messageController.text = bloc.smsMessage;
        }

        return Scaffold(
          appBar: AppBar(
            title: const Text('Add New Medication'),
            foregroundColor: Colors.white,
            backgroundColor: const Color(0xFF3B82F6),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView(
              children: [
                CustomTextField(
                  label: 'Medication Name',
                  hint: 'e.g., Aspirin 100mg',
                  controller: _nameController,
                  isRequired: true,
                  onChanged: (value) {
                    if (value != bloc.medicationName) {
                      context.read<MedicationBloc>().add(
                        UpdateMedicationName(value),
                      );
                    }
                  },
                ),
                const SizedBox(height: 24),
                Text(
                  'Reminder Schedule *',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 12),
                ScheduleToggle(
                  selectedType: bloc.scheduleType,
                  onChanged: (type) {
                    if (type != bloc.scheduleType) {
                      context.read<MedicationBloc>().add(
                        UpdateScheduleType(type),
                      );
                    }
                  },
                ),
                const SizedBox(height: 12),
                if (bloc.scheduleType == ScheduleType.everyXHours)
                  _buildHoursInput(context, bloc)
                else
                  _buildSpecificTimesInput(context, bloc),
                const SizedBox(height: 24),
                CustomTextField(
                  label: 'SMS Reminder Message',
                  hint:
                      'e.g., Time to take your Aspirin. Remember to take it with food.',
                  controller: _messageController,
                  isRequired: true,
                  maxLines: 4,
                  maxLength: 160,
                  onChanged: (value) {
                    if (value != bloc.smsMessage && value.length <= 160) {
                      context.read<MedicationBloc>().add(
                        UpdateSmsMessage(value),
                      );
                    }
                  },
                ),
                Text(
                  'Characters: ${bloc.smsMessage.length}/160',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(height: 24),
                Text(
                  'SMS Recipients * (${bloc.recipients.length} selected)',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: List<Widget>.generate(
                    bloc.recipients.length,
                    (i) => ContactChip(
                      contact: bloc.recipients[i],
                      onRemove: () {
                        context.read<MedicationBloc>().add(
                          RemoveRecipient(bloc.recipients[i]),
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                OutlinedButton.icon(
                  onPressed: () => _showAddContactDialog(context),
                  icon: const Icon(Icons.add),
                  label: const Text('Add Contact'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    textStyle: const TextStyle(fontSize: 18),
                  ),
                ),
                const SizedBox(height: 32),
                _buildActionButtons(context, bloc),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildHoursInput(BuildContext context, MedicationBloc bloc) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(
                Icons.access_time,
                color: Theme.of(context).primaryColor,
                size: 28,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Repeat every:',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        SizedBox(
                          width: 96,
                          child: TextField(
                            controller: _hoursController,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14),
                                borderSide: BorderSide(
                                  color: Theme.of(
                                    context,
                                  ).primaryColor.withOpacity(0.5),
                                  width: 1.5,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14),
                                borderSide: BorderSide(
                                  color: Theme.of(
                                    context,
                                  ).primaryColor.withOpacity(0.5),
                                  width: 1.5,
                                ),
                              ),
                            ),
                            onChanged: (value) {
                              final hours =
                                  int.tryParse(value) ?? bloc.repeatHours;
                              if (hours != bloc.repeatHours &&
                                  hours > 0 &&
                                  hours <= 24) {
                                bloc.add(UpdateRepeatHours(hours));
                              }
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'hours',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Common intervals: 4, 6, 8, 12, or 24 hours',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }

  Widget _buildSpecificTimesInput(BuildContext context, MedicationBloc bloc) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(
                Icons.access_time,
                color: Theme.of(context).primaryColor,
                size: 28,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Select specific times:',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    // SamplingClock(),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: () async {
                        final _ = (await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.now(),
                        ));
                      },
                      child: const Text('Add Time'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context, MedicationBloc bloc) {
    final isFormValid =
        bloc.medicationName.isNotEmpty &&
        bloc.smsMessage.isNotEmpty &&
        bloc.smsMessage.length <= 160 &&
        bloc.recipients.isNotEmpty;
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: () {
              context.read<MedicationBloc>().add(ResetForm());
            },
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: const Text('Cancel'),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton.icon(
            onPressed: isFormValid
                ? () {
                    context.read<MedicationBloc>().add(SaveMedication());
                  }
                : null,
            icon: const Icon(Icons.save),
            label: const Text('Save'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
          ),
        ),
      ],
    );
  }

  void _showAddContactDialog(BuildContext context) {
    final nameController = TextEditingController();
    final phoneController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Add Contact'),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value == null || value.isEmpty
                    ? 'Please enter a name'
                    : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: phoneController,
                decoration: const InputDecoration(
                  labelText: 'Phone Number',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.phone,
                validator: (value) => value == null || value.isEmpty
                    ? 'Please enter a phone number'
                    : null,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (formKey.currentState?.validate() ?? false) {
                final newContact = Contact(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  name: nameController.text,
                  phoneNumber: phoneController.text,
                );
                context.read<MedicationBloc>().add(AddRecipient(newContact));
                Navigator.pop(dialogContext);
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }
}

import 'dart:developer';

import 'package:drug_dose/features/medication/domain/models/schedule_type.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:drug_dose/features/medication/domain/models/contact.dart';
import 'package:drug_dose/features/medication/domain/models/medication.dart';
import 'package:drug_dose/features/medication/presentation/bloc/medication_event.dart';
import 'package:drug_dose/features/medication/presentation/bloc/medication_state.dart';

class MedicationBloc extends Bloc<MedicationEvent, MedicationState> {
  MedicationBloc() : super(MedicationInitial()) {
    on<UpdateMedicationName>(_onUpdateMedicationName);
    on<UpdateScheduleType>(_onUpdateScheduleType);
    on<UpdateRepeatHours>(_onUpdateRepeatHours);
    on<UpdateSmsMessage>(_onUpdateSmsMessage);
    on<AddRecipient>(_onAddRecipient);
    on<RemoveRecipient>(_onRemoveRecipient);
    on<SaveMedication>(_onSaveMedication);
    on<ResetForm>(_onResetForm);
    on<DeleteMedication>(_onDeleteMedication);
    on<PauseMedication>(_onPauseMedication);
  }

  // All medication data is stored here
  List<Medication> medications = [];

  Medication medication = Medication(
    name: 'Aspirin',
    scheduleType: ScheduleType.everyXHours,
    repeatHours: 6,
    smsMessage: 'Time to take your Aspirin.',
    active: true,
    recipients: [
      Contact(id: '1', name: 'John Doe', phoneNumber: '+1234567890'),
    ],
  );
  // Form fields
  String medicationName = '';
  ScheduleType scheduleType = ScheduleType.everyXHours;
  int repeatHours = 8;
  String smsMessage = '';
  List<Contact> recipients = [];

  void _onUpdateMedicationName(
    UpdateMedicationName event,
    Emitter<MedicationState> emit,
  ) {
    medicationName = event.name;
    emit(MedicationInitial());
  }

  void _onUpdateScheduleType(
    UpdateScheduleType event,
    Emitter<MedicationState> emit,
  ) {
    scheduleType = event.scheduleType;
    emit(MedicationInitial());
  }

  void _onUpdateRepeatHours(
    UpdateRepeatHours event,
    Emitter<MedicationState> emit,
  ) {
    if (event.hours > 0 && event.hours <= 24) {
      repeatHours = event.hours;
      emit(MedicationInitial());
    }
  }

  void _onUpdateSmsMessage(
    UpdateSmsMessage event,
    Emitter<MedicationState> emit,
  ) {
    if (event.message.length <= 160) {
      smsMessage = event.message;
      emit(MedicationInitial());
    }
  }

  void _onAddRecipient(AddRecipient event, Emitter<MedicationState> emit) {
    recipients.add(event.contact);
    emit(MedicationInitial());
  }

  void _onRemoveRecipient(
    RemoveRecipient event,
    Emitter<MedicationState> emit,
  ) {
    recipients.removeWhere((contact) => contact.id == event.contact.id);
    emit(MedicationInitial());
  }

  Future<void> _onSaveMedication(
    SaveMedication event,
    Emitter<MedicationState> emit,
  ) async {
    // Validate form fields directly from bloc variables
    if (medicationName.isEmpty ||
        smsMessage.isEmpty ||
        smsMessage.length > 160 ||
        recipients.isEmpty) {
      emit(MedicationErrorState());
      log(
        'Validation failed: '
        'Name: $medicationName, '
        'SMS: $smsMessage, '
        'Recipients: ${recipients.length}',
      );
      return;
    }

    emit(MedicationLoadingState());

    try {
      await Future.delayed(const Duration(seconds: 1));

      final medication = Medication(
        name: medicationName,
        scheduleType: scheduleType,
        repeatHours: repeatHours,
        smsMessage: smsMessage,
        recipients: List<Contact>.from(recipients),
        active: true,
      );

      medications.add(medication);

      print('Medication saved: ${medication.name}');

      emit(MedicationSuccessState());

      add(ResetForm());
    } catch (e) {
      emit(MedicationErrorState());
    }
  }

  void _onResetForm(ResetForm event, Emitter<MedicationState> emit) {
    medicationName = '';
    scheduleType = ScheduleType.everyXHours;
    repeatHours = 8;
    smsMessage = '';
    recipients = [];
    emit(MedicationInitial());
  }

  void _onDeleteMedication(
    DeleteMedication event,
    Emitter<MedicationState> emit,
  ) {
    emit(MedicationDeletingState());
    medications.remove(event.med);
    emit(MedicationDeletedState());
  }

  void _onPauseMedication(
    PauseMedication event,
    Emitter<MedicationState> emit,
  ) {
    emit(PauseMedicationState());
    event.med.active = event.med.active ? false : true;
    emit(PausedMedicationState());
  }
}

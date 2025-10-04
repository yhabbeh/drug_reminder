import 'package:drug_dose/features/medication/domain/models/contact.dart';
import 'package:drug_dose/features/medication/domain/models/medication.dart';
import 'package:drug_dose/features/medication/domain/models/schedule_type.dart';

abstract class MedicationEvent {}

class UpdateMedicationName extends MedicationEvent {
  final String name;
  UpdateMedicationName(this.name);
}

class UpdateScheduleType extends MedicationEvent {
  final ScheduleType scheduleType;
  UpdateScheduleType(this.scheduleType);
}

class UpdateRepeatHours extends MedicationEvent {
  final int hours;
  UpdateRepeatHours(this.hours);
}

class UpdateSmsMessage extends MedicationEvent {
  final String message;
  UpdateSmsMessage(this.message);
}

class AddRecipient extends MedicationEvent {
  final Contact contact;
  AddRecipient(this.contact);
}

class RemoveRecipient extends MedicationEvent {
  final Contact contact;
  RemoveRecipient(this.contact);
}

class SaveMedication extends MedicationEvent {}

class ResetForm extends MedicationEvent {}

class DeleteMedication extends MedicationEvent {
  final Medication med;
  DeleteMedication(this.med);
}

class PauseMedication extends MedicationEvent {
  final Medication med;
  PauseMedication(this.med);
}

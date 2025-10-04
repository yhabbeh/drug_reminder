import 'package:equatable/equatable.dart';
import 'package:flutter_contacts/contact.dart';
import '../../../services/schedule_type.dart';

abstract class ReminderEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class MedicineChanged extends ReminderEvent {
  final String medicine;
  MedicineChanged(this.medicine);
}

class DoseChanged extends ReminderEvent {
  final String dose;
  DoseChanged(this.dose);
}

class ContactsSelected extends ReminderEvent {
  final Set<Contact> contacts;
  ContactsSelected(this.contacts);
}

class ScheduleTypeChanged extends ReminderEvent {
  final ScheduleType type;
  ScheduleTypeChanged(this.type);
}

class ScheduleReminder extends ReminderEvent {
  final DateTime time;
  ScheduleReminder(this.time);
}

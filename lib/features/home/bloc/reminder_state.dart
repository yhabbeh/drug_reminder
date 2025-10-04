import 'package:drug_dose/services/schedule_type.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_contacts/contact.dart';

class ReminderState extends Equatable {
  final String medicine;
  final String dose;
  final Set<Contact> contacts;
  final bool scheduled;
  final ScheduleType type;

  const ReminderState({
    this.medicine = '',
    this.dose = '',
    this.contacts = const {},
    this.scheduled = false,
    this.type = ScheduleType.once,
  });

  ReminderState copyWith({
    String? medicine,
    String? dose,
    Set<Contact>? contacts,
    bool? scheduled,
    ScheduleType? type,
  }) {
    return ReminderState(
      medicine: medicine ?? this.medicine,
      dose: dose ?? this.dose,
      contacts: contacts ?? this.contacts,
      scheduled: scheduled ?? this.scheduled,
      type: type ?? this.type,
    );
  }

  @override
  List<Object?> get props => [medicine, dose, contacts, scheduled, type];
}

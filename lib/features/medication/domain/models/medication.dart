import 'package:drug_dose/features/medication/domain/models/contact.dart';
import 'package:drug_dose/features/medication/domain/models/schedule_type.dart';

class Medication {
  final String name;
  final ScheduleType scheduleType;
  final int repeatHours;
  bool active;
  final String smsMessage;
  final List<Contact> recipients;

  Medication({
    required this.name,
    required this.scheduleType,
    required this.repeatHours,
    required this.smsMessage,
    required this.active,
    required this.recipients,
  });

  Medication copyWith({
    String? name,
    ScheduleType? scheduleType,
    int? repeatHours,
    String? smsMessage,
    bool? active,
    List<Contact>? recipients,
  }) {
    return Medication(
      name: name ?? this.name,
      scheduleType: scheduleType ?? this.scheduleType,
      repeatHours: repeatHours ?? this.repeatHours,
      smsMessage: smsMessage ?? this.smsMessage,
      recipients: recipients ?? this.recipients,
      active: this.active,
    );
  }
}

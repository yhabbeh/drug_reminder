// // lib/domain/models/medication.dart
// import 'package:drug_dose/services/schedule_type.dart';

// class Medication {
//   final String name;
//   final ScheduleType scheduleType;
//   final int repeatHours;
//   final String smsMessage;
//   final List<Contact> recipients;

//   const Medication({
//     required this.name,
//     required this.scheduleType,
//     required this.repeatHours,
//     required this.smsMessage,
//     required this.recipients,
//   });

//   Medication copyWith({
//     String? name,
//     ScheduleType? scheduleType,
//     int? repeatHours,
//     String? smsMessage,
//     List<Contact>? recipients,
//   }) {
//     return Medication(
//       name: name ?? this.name,
//       scheduleType: scheduleType ?? this.scheduleType,
//       repeatHours: repeatHours ?? this.repeatHours,
//       smsMessage: smsMessage ?? this.smsMessage,
//       recipients: recipients ?? this.recipients,
//     );
//   }
// }

// // lib/domain/models/contact.dart
// class Contact {
//   final String id;
//   final String name;
//   final String phoneNumber;

//   const Contact({
//     required this.id,
//     required this.name,
//     required this.phoneNumber,
//   });

//   @override
//   bool operator ==(Object other) =>
//       identical(this, other) ||
//       other is Contact && runtimeType == other.runtimeType && id == other.id;

//   @override
//   int get hashCode => id.hashCode;
// }

// // lib/domain/models/schedule_type.dart
// // enum ScheduleType { everyXHours, specificTimes }

import 'dart:developer';

import 'package:drug_dose/services/schedule_type.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'reminder_event.dart';
import 'reminder_state.dart';
import '../../../services/sms_service.dart';
import '../../../services/notification_service.dart';

class ReminderBloc extends Bloc<ReminderEvent, ReminderState> {
  final SmsService smsService = SmsService();
  final NotificationService notifService = NotificationService();

  // Example instance variable
  String? test;

  ReminderBloc() : super(const ReminderState()) {
    on<MedicineChanged>(_onMedicineChanged);
    on<DoseChanged>(_onDoseChanged);
    on<ContactsSelected>(_onContactsSelected);
    on<ScheduleTypeChanged>(_onScheduleTypeChanged);
    on<ScheduleReminder>(_onScheduleReminder);
  }

  void _onMedicineChanged(MedicineChanged event, Emitter<ReminderState> emit) {
    emit(state.copyWith(medicine: event.medicine));
    test = "Medicine updated: ${event.medicine}";
    emit(state.copyWith()); // optionally re-emit after updating test
  }

  void _onDoseChanged(DoseChanged event, Emitter<ReminderState> emit) {
    emit(state.copyWith(dose: event.dose));
    test = "Dose updated: ${event.dose}";
    emit(state.copyWith());
  }

  void _onContactsSelected(
    ContactsSelected event,
    Emitter<ReminderState> emit,
  ) {
    emit(state.copyWith(contacts: event.contacts));
    test = "Contacts updated: ${event.contacts.length}";
    emit(state.copyWith());
  }

  void _onScheduleTypeChanged(
    ScheduleTypeChanged event,
    Emitter<ReminderState> emit,
  ) {
    emit(state.copyWith(type: event.type));
    test = "Schedule type updated: ${event.type}";
    emit(state.copyWith());
  }

  Future<void> _onScheduleReminder(
    ScheduleReminder event,
    Emitter<ReminderState> emit,
  ) async {
    final message = "Time to take ${state.dose} of ${state.medicine} 💊";

    // Send SMS immediately
    await smsService.sendSms(
      state.contacts.map((e) => e.phones.toString()).toList(),
      message,
    );
    log('entt mesg');

    // Push immediate notification
    await notifService.show("Medicine Reminder", message);

    // Schedule based on type
    switch (state.type) {
      case ScheduleType.once:
        await notifService.schedule(
          1,
          "Medicine Reminder",
          message,
          event.time,
        );
        break;
      case ScheduleType.daily:
        await notifService.scheduleDaily(
          2,
          "Medicine Reminder",
          message,
          event.time,
        );
        break;
      case ScheduleType.weekly:
        await notifService.scheduleWeekly(
          3,
          "Medicine Reminder",
          message,
          event.time,
        );
        break;
      case ScheduleType.everyXHours:
        // TODO: Handle this case.
        throw UnimplementedError();
      case ScheduleType.specificTimes:
        // TODO: Handle this case.
        throw UnimplementedError();
    }

    test = "Reminder scheduled at ${event.time}";
    emit(state.copyWith(scheduled: true));
    emit(state.copyWith()); // optionally re-emit after updating test
  }
}

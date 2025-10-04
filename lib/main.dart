import 'package:drug_dose/features/medication/presentation/screens/medication_screen.dart';
import 'package:drug_dose/services/bindings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'services/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  tz.initializeTimeZones();

  final notifService = NotificationService();
  await notifService.init();

  runApp(MyApp(notifService: notifService));
}

class MyApp extends StatelessWidget {
  final NotificationService notifService;
  const MyApp({super.key, required this.notifService});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: blocs,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Medicine Reminder',
        home: MedicationListScreen(),
      ),
    );
  }
}

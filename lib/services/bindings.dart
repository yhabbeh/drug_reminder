import 'package:drug_dose/features/medication/presentation/bloc/medication_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/single_child_widget.dart';

List<SingleChildWidget> blocs = [
  BlocProvider(create: (context) => MedicationBloc()),
];

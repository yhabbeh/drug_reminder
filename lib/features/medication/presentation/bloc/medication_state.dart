enum FormStatus { initial, loading, success, error }

abstract class MedicationState {}

class MedicationInitial extends MedicationState {}

class MedicationLoadingState extends MedicationState {}

class MedicationSuccessState extends MedicationState {}

class MedicationErrorState extends MedicationState {}

class MedicationDeletingState extends MedicationState {}

class MedicationDeletedState extends MedicationState {}

class PauseMedicationState extends MedicationState {}

class PausedMedicationState extends MedicationState {}

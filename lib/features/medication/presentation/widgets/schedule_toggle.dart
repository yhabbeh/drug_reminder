import 'package:drug_dose/features/medication/domain/models/schedule_type.dart';
import 'package:flutter/material.dart';

class ScheduleToggle extends StatelessWidget {
  final ScheduleType selectedType;
  final Function(ScheduleType) onChanged;

  const ScheduleToggle({
    super.key,
    required this.selectedType,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _ToggleButton(
            label: 'Every X Hours',
            isSelected: selectedType == ScheduleType.everyXHours,
            onTap: () => onChanged(ScheduleType.everyXHours),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _ToggleButton(
            label: 'Specific Times',
            isSelected: selectedType == ScheduleType.specificTimes,
            onTap: () => onChanged(ScheduleType.specificTimes),
          ),
        ),
      ],
    );
  }
}

class _ToggleButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _ToggleButton({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 60,
        decoration: BoxDecoration(
          color: isSelected ? Theme.of(context).primaryColor : const Color(0xFFF3F4F6),
          borderRadius: BorderRadius.circular(16),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            fontSize: 20,
            color: isSelected ? Colors.white : const Color(0xFF364153),
            letterSpacing: -0.45,
          ),
        ),
      ),
    );
  }
}

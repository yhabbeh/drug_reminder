// lib/presentation/widgets/medication_card.dart
import 'package:flutter/material.dart';

class MedicationCard extends StatelessWidget {
  final String medicationName;
  final String scheduleText;
  final String smsMessage;
  final List<String> recipients;
  final VoidCallback onPause;
  final VoidCallback onDelete;
  final bool isActive;

  const MedicationCard({
    super.key,
    required this.medicationName,
    required this.scheduleText,
    required this.smsMessage,
    required this.recipients,
    required this.onPause,
    required this.isActive,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(26),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFF10B981), width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Medication Name & Schedule
          Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFD1FAE5),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.medication,
                  color: Color(0xFF10B981),
                  size: 32,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      medicationName,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF111827),
                        letterSpacing: -0.43,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(
                          Icons.access_time,
                          size: 20,
                          color: Color(0xFF6B7280),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          scheduleText,
                          style: const TextStyle(
                            fontSize: 18,
                            color: Color(0xFF6B7280),
                            letterSpacing: -0.44,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // SMS Message Section
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFEFF6FF),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.message,
                      size: 24,
                      color: Color(0xFF155DFC),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      'SMS Message:',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF155DFC),
                        letterSpacing: 0.57,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.only(left: 36),
                  child: Text(
                    smsMessage,
                    style: const TextStyle(
                      fontSize: 18,
                      color: Color(0xFF364153),
                      letterSpacing: -0.44,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Recipients Section
          Row(
            children: [
              const Icon(Icons.people, size: 24, color: Color(0xFF6B7280)),
              const SizedBox(width: 12),
              Text(
                'Recipients (${recipients.length}):',
                style: const TextStyle(
                  fontSize: 18,
                  color: Color(0xFF364153),
                  letterSpacing: -0.44,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: recipients
                .map(
                  (name) => Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF3E8FF),
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: Text(
                      name,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Color(0xFF6E11B0),
                        letterSpacing: 0,
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 24),

          // Action Buttons
          Row(
            children: [
              Expanded(
                flex: 3,
                child: GestureDetector(
                  onTap: onPause,
                  child: Container(
                    height: 60,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF3F4F6),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          !isActive ? Icons.play_arrow : Icons.pause,
                          color: const Color(0xFF364153),
                          size: 24,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          !isActive ? 'Resume' : 'Pause',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF364153),
                            letterSpacing: -0.1,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 2,
                child: GestureDetector(
                  onTap: onDelete,
                  child: Container(
                    height: 60,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFEE2E2),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.delete, color: Color(0xFFDC2626), size: 24),
                        SizedBox(width: 8),
                        Text(
                          'Delete',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFFDC2626),
                            letterSpacing: -0.1,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

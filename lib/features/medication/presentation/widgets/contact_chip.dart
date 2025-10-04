import 'package:drug_dose/features/medication/domain/models/contact.dart';
import 'package:flutter/material.dart';

class ContactChip extends StatelessWidget {
  final Contact contact;
  final VoidCallback onRemove;

  const ContactChip({super.key, required this.contact, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 16, right: 8, top: 8, bottom: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFF3E8FF),
        borderRadius: BorderRadius.circular(100),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            contact.name,
            style: const TextStyle(
              fontSize: 18,
              color: Color(0xFF6E11B0),
              letterSpacing: -0.44,
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: onRemove,
            child: const Icon(Icons.close, size: 20, color: Color(0xFF6E11B0)),
          ),
        ],
      ),
    );
  }
}

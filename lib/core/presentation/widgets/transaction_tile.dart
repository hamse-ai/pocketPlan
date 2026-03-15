import 'package:flutter/material.dart';

/// A reusable transaction list tile used by both Income and Expense screens.
class TransactionTile extends StatelessWidget {
  final String title;
  final String date;
  final double amount;
  final bool isActive;
  final ValueChanged<bool> onToggle;

  const TransactionTile({
    super.key,
    required this.title,
    required this.date,
    required this.amount,
    required this.isActive,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          // Left: title + date
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  date,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),

          // Right: amount + toggle
          Row(
            children: [
              Text(
                'RWF ${amount.toStringAsFixed(0)}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.black,
                ),
              ),
              const SizedBox(width: 8),
              Switch(
                value: isActive,
                onChanged: onToggle,
                activeThumbColor: const Color(0xFF006B5F),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

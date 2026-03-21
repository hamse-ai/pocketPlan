import 'package:flutter/material.dart';
import '../../../../../theme/colors.dart';
import '../../../../../theme/textStyles.dart';

class TipCard extends StatelessWidget {
  final String title;
  final String body;

  const TipCard({super.key, required this.title, required this.body});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 1, right: 10),
            child: Icon(Icons.lightbulb_outline,
                size: 20, color: AppColors.onSurface),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: AppTextStyles.body
                        .copyWith(fontWeight: FontWeight.w700)),
                const SizedBox(height: 5),
                Text(body,
                    style: AppTextStyles.bodySecondary
                        .copyWith(fontSize: 13)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
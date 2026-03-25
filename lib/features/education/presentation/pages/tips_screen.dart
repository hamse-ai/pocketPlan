import 'package:flutter/material.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/textStyles.dart';
import '../widgets/tip_card.dart';

class TipsScreen extends StatelessWidget {
  const TipsScreen({super.key});

  static const List<Map<String, String>> _tips = [
    {
      'title': 'When You Receive Money',
      'body':
          'Before spending, log your income first. '
          'Seeing the number helps you slow down.',
    },
    {
      'title': 'During Lean Periods',
      'body':
          'Reduce variable expenses like eating '
          'out or transport extras.',
    },
    {
      'title': 'Emergency Planning',
      'body':
          'Unexpected expenses are normal. '
          'Start an emergency buffer for peace of mind.',
    },
    {
      'title': 'Spending Awareness',
      'body':
          'Track daily spending, not monthly budgets. '
          'Small daily expenses add up faster than you think.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Tips'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),

            // ── Page title ───────────────────────────────────
            Center(
              child: Text('Financial Tips', style: AppTextStyles.heading1),
            ),

            const SizedBox(height: 28),

            // ── Tip cards ────────────────────────────────────
            ...List.generate(_tips.length, (i) {
               final tip = _tips[i];
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: TipCard(
                  title: tip['title']!,
                  body: tip['body']!
                ),
              );
            }),


          ],
        ),
      ),
    );
  }
}



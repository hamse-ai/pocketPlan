import 'package:flutter/material.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/textStyles.dart';

class TipsScreen extends StatelessWidget {
  const TipsScreen({super.key});

  static const List<Map<String, dynamic>> _tips = [
    {
      'icon': Icons.savings_outlined,
      'title': 'Pay Yourself First',
      'body':
          'Move a fixed amount to savings the moment you receive income — before spending on anything else. Even a small consistent amount compounds significantly over time.',
    },
    {
      'icon': Icons.track_changes_outlined,
      'title': 'Track Every Expense',
      'body':
          'Log every purchase, no matter how small. Coffee, snacks, and subscriptions add up quickly. Visibility is the first step to controlling your spending.',
    },
    {
      'icon': Icons.calendar_today_outlined,
      'title': 'Plan for Lean Periods',
      'body':
          'Identify the days between paychecks where your balance will be lowest. Reduce discretionary spending during those days so you never feel caught off guard.',
    },
    {
      'icon': Icons.pie_chart_outline,
      'title': 'Use the 50/30/20 Rule',
      'body':
          'Allocate 50% of income to needs, 30% to wants, and 20% to savings and debt repayment. Adjust the ratios to fit your situation, but keep the habit.',
    },
    {
      'icon': Icons.block_outlined,
      'title': 'Avoid Impulse Purchases',
      'body':
          'Wait 24 hours before buying anything that is not on your planned budget. Most impulse urges fade within a day, saving you from buyer\'s remorse.',
    },
    {
      'icon': Icons.receipt_long_outlined,
      'title': 'Review Subscriptions Monthly',
      'body':
          'Go through all recurring charges every month and cancel any services you have not used recently. Unused subscriptions silently drain your budget.',
    },
    {
      'icon': Icons.emergency_outlined,
      'title': 'Build an Emergency Fund',
      'body':
          'Aim to keep 3–6 months of living expenses in an accessible savings account. This buffer protects you from unexpected events without derailing your budget.',
    },
    {
      'icon': Icons.trending_down_outlined,
      'title': 'Reduce High-Interest Debt First',
      'body':
          'If you carry any debt, prioritize paying off the highest-interest balances first (avalanche method). This minimises the total interest you pay over time.',
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
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),

            // ── Header card ──────────────────────────────────
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Financial Tips',
                    style: AppTextStyles.heading2.copyWith(
                      color: AppColors.onPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Simple habits that make a big difference\nto your financial wellbeing',
                    style: AppTextStyles.body.copyWith(
                      color: AppColors.onPrimarySecondary,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            Text(
              'Smart Money Habits',
              style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 2),
            Text(
              '${_tips.length} tips to help you stay on track',
              style: AppTextStyles.bodySecondary.copyWith(fontSize: 12),
            ),
            const SizedBox(height: 16),

            // ── Tip cards ────────────────────────────────────
            ...List.generate(_tips.length, (i) {
              final tip = _tips[i];
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          tip['icon'] as IconData,
                          color: AppColors.primary,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              tip['title'] as String,
                              style: AppTextStyles.body.copyWith(
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              tip['body'] as String,
                              style: AppTextStyles.bodySecondary.copyWith(
                                fontSize: 12.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

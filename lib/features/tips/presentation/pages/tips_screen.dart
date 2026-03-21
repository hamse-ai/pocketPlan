import "../../../../core/theme/colors.dart";
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
              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: _TipCard(
                  title: _tips[i]['title']!
                  body: _tips[i]['body']!
                ),
              );
            }),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class _TipCard extends StatelessWidget {
  final String title;
  final String body;

  const _TipCard({required this.title, required this.body});

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
          // Lightbulb icon
          Padding(
            padding: const EdgeInsets.only(top: 1, right: 10),
            child: Icon(
              Icons.lightbulb_outline,
              size: 20,
              color: AppColors.onSurface,
            ),
          ),
          // Text
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.body.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  body,
                  style: AppTextStyles.bodySecondary.copyWith(fontSize: 13),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
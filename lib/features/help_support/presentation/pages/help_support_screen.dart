import "../../../../core/theme/colors.dart";
import '../../../../core/theme/textStyles.dart';
import '../widgets/faq_item.dart';

class HelpSupportScreen extends StatefulWidget {
  const HelpSupportScreen({super.key});

  @override
  State<HelpSupportScreen> createState() => _HelpSupportScreenState();
}

class _HelpSupportScreenState extends State<HelpSupportScreen> {
  final _subjectCtrl = TextEditingController();
  final _messageCtrl = TextEditingController();
  int _expandedIndex = -1;

  final List<String> _faqs = [
    'What is Pocket Plan and who is it for?',
    'What does "Safe to Spend Today" mean?',
    'What is a lean period?',
    'How does auto-save work?',
    'What happens if I forget to log an expense?',
    'Is my financial information safe?',
    'Can I edit or delete income and expense entries?',
  ];

  @override
  void dispose() {
    _subjectCtrl.dispose();
    _messageCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Help & Support'),
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
                    'Help & Support',
                    style: AppTextStyles.heading2.copyWith(
                      color: AppColors.onPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Find answers to common questions\nor get in touch with our team',
                    style: AppTextStyles.body.copyWith(
                      color: AppColors.onPrimarySecondary,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // ── FAQ section ──────────────────────────────────
            Text(
              'Frequently Asked Questions',
              style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 2),
            Text(
              'Quick answers to common questions',
              style: AppTextStyles.bodySecondary.copyWith(fontSize: 12),
            ),
            const SizedBox(height: 12),

            // FAQ items
            ...List.generate(_faqs.length, (i) {
              final isExpanded = _expandedIndex == i;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InkWell(
                    onTap: () => setState(
                        () => _expandedIndex = isExpanded ? -1 : i),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 13),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              _faqs[i],
                              style:
                                  AppTextStyles.body.copyWith(fontSize: 13.5),
                            ),
                          ),
                          Icon(
                            isExpanded
                                ? Icons.keyboard_arrow_up
                                : Icons.keyboard_arrow_down,
                            color: AppColors.onSurfaceSecondary,
                            size: 20,
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (isExpanded)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Text(
                        'This is a placeholder answer for "${_faqs[i]}". '
                        'Replace this with actual FAQ content.',
                        style: AppTextStyles.bodySecondary
                            .copyWith(fontSize: 12.5),
                      ),
                    ),
                  Divider(height: 1, color: AppColors.surface),
                ],
              );
            }),

            const SizedBox(height: 28),

            // ── Still Need Help ──────────────────────────────
            Text(
              'Still Need Help?',
              style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 2),
            Text(
              'Choose what updates you want to receive',
              style: AppTextStyles.bodySecondary.copyWith(fontSize: 12),
            ),
            const SizedBox(height: 16),

            // Subject
            Text('Subject', style: AppTextStyles.body.copyWith(fontSize: 13)),
            const SizedBox(height: 6),
            TextField(
              controller: _subjectCtrl,
              style: AppTextStyles.body.copyWith(fontSize: 13),
              decoration: InputDecoration(
                hintText: 'Brief description of your issue',
                hintStyle:
                    AppTextStyles.bodySecondary.copyWith(fontSize: 13),
                filled: true,
                fillColor: AppColors.surface,
                contentPadding: const EdgeInsets.symmetric(
                    horizontal: 14, vertical: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
              ),
            ),

            const SizedBox(height: 14),

            // Message
            Text('Message', style: AppTextStyles.body.copyWith(fontSize: 13)),
            const SizedBox(height: 6),
            TextField(
              controller: _messageCtrl,
              maxLines: 5,
              style: AppTextStyles.body.copyWith(fontSize: 13),
              decoration: InputDecoration(
                hintText: 'Describe your issue in details',
                hintStyle:
                    AppTextStyles.bodySecondary.copyWith(fontSize: 13),
                filled: true,
                fillColor: AppColors.surface,
                contentPadding: const EdgeInsets.symmetric(
                    horizontal: 14, vertical: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Send button — uses ElevatedButtonTheme from AppTheme
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: () {
                  // TODO: implement send logic
                },
                child: Text('Send Message', style: AppTextStyles.button),
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
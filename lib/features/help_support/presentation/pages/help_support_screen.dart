import 'package:flutter/material.dart';
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

  final List<Map<String, String>> _faqs = [
    {
      'q': 'What is Pocket Plan and who is it for?',
      'a': 'Pocket Plan is a personal budgeting app designed for anyone who wants to take control of their day-to-day spending. Whether you are a student, a salaried professional, or a freelancer, Pocket Plan helps you stay within budget and build healthy financial habits.',
    },
    {
      'q': 'What does "Safe to Spend Today" mean?',
      'a': '"Safe to Spend Today" is a dynamic figure that tells you how much you can comfortably spend for the rest of the day based on your remaining budget, upcoming scheduled expenses, and daily targets.',
    },
    {
      'q': 'What is a lean period?',
      'a': 'A lean period is a stretch of days where your budget is tighter than usual — for example, the days just before your next paycheck. Pocket Plan flags these periods so you can plan spending accordingly.',
    },
    {
      'q': 'How does auto-save work?',
      'a': 'Auto-save automatically transfers a small, pre-set amount to your savings whenever you log income or when your daily spending stays under your target. You can configure the amount and frequency in Settings.',
    },
    {
      'q': 'What happens if I forget to log an expense?',
      'a': 'You can always add past expenses manually by selecting a backdated date when logging. Pocket Plan will recalculate your balance and spending history accordingly so your records stay accurate.',
    },
    {
      'q': 'Is my financial information safe?',
      'a': 'Yes. Your data is stored securely using Firebase with industry-standard encryption. We never sell or share your financial data with third parties. You can also enable biometric lock for an extra layer of security.',
    },
    {
      'q': 'Can I edit or delete income and expense entries?',
      'a': 'Absolutely. Tap on any transaction in your history to edit the amount, category, date, or notes. You can also swipe left on an entry to delete it. Deleted entries cannot be recovered, so proceed carefully.',
    },
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
            ...List.generate(_faqs.length, (i) => FaqItem(
              question: _faqs[i]['q']!,
              answer: _faqs[i]['a']!,
              isExpanded: _expandedIndex == i,
              onTap: () => setState(
                  () => _expandedIndex = _expandedIndex == i ? -1 : i),
            )),

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
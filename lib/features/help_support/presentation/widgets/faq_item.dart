import '../widgets/faq_item.dart';

class FaqItem extends StatelessWidget {
  final String question;
  final String answer;
  final bool isExpanded;
  final VoidCallback onTap;

  const FaqItem(
          question: _faqs[i],
          answer: 'Placeholder answer for ${_faqs[i]}.',
          isExpanded: _expandedIndex == i,
          onTap: () => setState(() =>
              _expandedIndex = _expandedIndex == i ? -1 : i),
        );

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 13),
            child: Row(
              children: [
                Expanded(
                  child: Text(question,
                      style: AppTextStyles.body.copyWith(fontSize: 13.5)),
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
              answer,
              style: AppTextStyles.bodySecondary.copyWith(fontSize: 12.5),
            ),
          ),
        Divider(height: 1, color: AppColors.surface),
      ],
    );
  }
}
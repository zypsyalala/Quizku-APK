import 'package:flutter/material.dart';

class AnswerButton extends StatelessWidget {
  final String label; // A, B, C, D
  final String answerText;
  final VoidCallback? onTap;
  final bool isSelected;
  final bool isCorrect;
  final bool showResult;

  const AnswerButton({
    super.key,
    required this.label,
    required this.answerText,
    required this.onTap,
    this.isSelected = false,
    this.isCorrect = false,
    this.showResult = false,
  });

  @override
  Widget build(BuildContext context) {
    // Determine colors based on state
    Color bgColor = Colors.white;
    Color borderColor = const Color(0xFFE5E7EB);
    Color labelBgColor = const Color(0xFFF3F4F6);
    Color labelTextColor = const Color(0xFF6B7280);
    Color textColor = const Color(0xFF374151);
    Widget? trailingIcon;

    if (showResult && isSelected && isCorrect) {
      // Selected & correct → indigo
      bgColor = const Color(0xFF4F46E5);
      borderColor = const Color(0xFF4F46E5);
      labelBgColor = Colors.white.withValues(alpha: 0.25);
      labelTextColor = Colors.white;
      textColor = Colors.white;
      trailingIcon = Container(
        padding: const EdgeInsets.all(2),
        decoration: const BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
        ),
        child: const Icon(
          Icons.check_rounded,
          size: 18,
          color: Color(0xFF4F46E5),
        ),
      );
    } else if (showResult && isSelected && !isCorrect) {
      // Selected & wrong → red
      bgColor = const Color(0xFFEF4444);
      borderColor = const Color(0xFFEF4444);
      labelBgColor = Colors.white.withValues(alpha: 0.25);
      labelTextColor = Colors.white;
      textColor = Colors.white;
      trailingIcon = Container(
        padding: const EdgeInsets.all(2),
        decoration: const BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
        ),
        child: const Icon(
          Icons.close_rounded,
          size: 18,
          color: Color(0xFFEF4444),
        ),
      );
    } else if (showResult && isCorrect) {
      // Not selected but this is the correct answer → green outline
      borderColor = const Color(0xFF22C55E);
      labelBgColor = const Color(0xFFDCFCE7);
      labelTextColor = const Color(0xFF22C55E);
    }

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        width: double.infinity,
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: borderColor, width: 1.5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Letter badge (A, B, C, D)
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: labelBgColor,
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: labelTextColor,
                ),
              ),
            ),
            const SizedBox(width: 14),
            // Answer text
            Expanded(
              child: Text(
                answerText,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  color: textColor,
                  height: 1.3,
                ),
              ),
            ),
            // Trailing icon (check/cross)
            if (trailingIcon != null) ...[
              const SizedBox(width: 8),
              trailingIcon,
            ],
          ],
        ),
      ),
    );
  }
}

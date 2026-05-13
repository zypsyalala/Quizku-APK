import 'package:flutter/material.dart';

class AnswerButton extends StatelessWidget {
  final String answerText;
  final VoidCallback? onTap;
  final Color backgroundColor;
  final Color borderColor;

  const AnswerButton({
    super.key,
    required this.answerText,
    required this.onTap,
    this.backgroundColor = const Color(0xFFEDE7F6), // deepPurple.shade50
    this.borderColor = const Color(0xFFB39DDB),      // deepPurple.shade200
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: Colors.black87,
          disabledBackgroundColor: backgroundColor,
          disabledForegroundColor: Colors.black87,
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: borderColor, width: 1.5),
          ),
          elevation: 0,
        ),
        child: Text(
          answerText,
          style: const TextStyle(fontSize: 16),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

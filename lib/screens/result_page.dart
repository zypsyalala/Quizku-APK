import 'dart:math';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/question_model.dart';
import 'home_page.dart';
import 'quiz_page.dart';

class ResultPage extends StatefulWidget {
  final int score;
  final int totalQuestions;
  final QuizCategory category;
  final int elapsedSeconds;
  final int questionCount;

  const ResultPage({
    super.key,
    required this.score,
    required this.totalQuestions,
    required this.category,
    required this.elapsedSeconds,
    required this.questionCount,
  });

  @override
  State<ResultPage> createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage>
    with SingleTickerProviderStateMixin {
  int? _highScore;
  bool _isNewHighScore = false;
  late AnimationController _animController;
  late Animation<double> _progressAnim;

  @override
  void initState() {
    super.initState();
    _loadAndSaveScore();

    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    final percentage = widget.score / widget.totalQuestions;
    _progressAnim = Tween<double>(begin: 0, end: percentage).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeOutCubic),
    );
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  Future<void> _loadAndSaveScore() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'highscore_${widget.category.name}';
    final savedHighScore = prefs.getInt(key) ?? 0;

    if (widget.score > savedHighScore) {
      await prefs.setInt(key, widget.score);
      setState(() {
        _highScore = widget.score;
        _isNewHighScore = true;
      });
    } else {
      setState(() {
        _highScore = savedHighScore;
        _isNewHighScore = false;
      });
    }
  }

  String _getMessage() {
    double pct = (widget.score / widget.totalQuestions) * 100;
    if (pct >= 80) return 'Luar Biasa! Pertahankan\nprestasimu.';
    if (pct >= 60) return 'Bagus! Pertahankan\nprestasimu.';
    if (pct >= 40) return 'Lumayan! Terus\ntingkatkan lagi.';
    return 'Jangan menyerah!\nCoba lagi ya.';
  }

  String _getCategoryName() {
    switch (widget.category) {
      case QuizCategory.programming:
        return 'Pemrograman';
      case QuizCategory.islamic:
        return 'Agama Islam';
      case QuizCategory.english:
        return 'Bahasa Inggris';
    }
  }

  String _formatTime(int totalSeconds) {
    final m = totalSeconds ~/ 60;
    final s = totalSeconds % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final int scorePercent =
        ((widget.score / widget.totalQuestions) * 100).round();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.menu_rounded, color: Color(0xFF1E2A5E)),
          onPressed: () {},
        ),
        title: const Text(
          'QuizQu',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w800,
            color: Color(0xFF1E2A5E),
          ),
        ),
        actions: const [],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  // === Main Result Card ===
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.fromLTRB(24, 32, 24, 32),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 20,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Icon(
                          _isNewHighScore
                              ? Icons.emoji_events_rounded
                              : Icons.assignment_turned_in_rounded,
                          size: 48,
                          color: const Color(0xFFD4A017),
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'Quiz Selesai!',
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF1E2A5E),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _getCategoryName(),
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey.shade500,
                          ),
                        ),
                        const SizedBox(height: 28),

                        // === Circular Progress Ring ===
                        AnimatedBuilder(
                          animation: _progressAnim,
                          builder: (context, child) {
                            return SizedBox(
                              width: 180,
                              height: 180,
                              child: CustomPaint(
                                painter: _ScoreRingPainter(
                                  progress: _progressAnim.value,
                                  bgColor: const Color(0xFFE5E7EB),
                                  fgColor: const Color(0xFF4F46E5),
                                  strokeWidth: 10,
                                ),
                                child: Center(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        'SKOR ANDA',
                                        style: TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.grey.shade500,
                                          letterSpacing: 1,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      RichText(
                                        text: TextSpan(
                                          children: [
                                            TextSpan(
                                              text: '$scorePercent',
                                              style: const TextStyle(
                                                fontSize: 48,
                                                fontWeight: FontWeight.w800,
                                                color: Color(0xFF1E2A5E),
                                              ),
                                            ),
                                            const TextSpan(
                                              text: ' /100',
                                              style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w600,
                                                color: Color(0xFF9CA3AF),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // === Message Card ===
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 18,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: const Color(0xFFE5E7EB),
                        width: 1,
                      ),
                    ),
                    child: Text(
                      _getMessage(),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF4F46E5),
                        height: 1.4,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // === Stats Row ===
                  Row(
                    children: [
                      Expanded(
                        child: _buildStatBox(
                          icon: Icons.access_time_rounded,
                          label: 'Waktu',
                          value: _formatTime(widget.elapsedSeconds),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildStatBox(
                          icon: Icons.check_circle_outline_rounded,
                          label: 'Benar',
                          value: '${widget.score}/${widget.totalQuestions}',
                        ),
                      ),
                    ],
                  ),

                  // === New High Score badge ===
                  if (_highScore != null) ...[
                    const SizedBox(height: 12),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFEF3C7),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: const Color(0xFFFCD34D),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.star_rounded,
                            color: Colors.amber.shade700,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            _isNewHighScore
                                ? 'Skor Tertinggi Baru!'
                                : 'Skor Tertinggi: $_highScore',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: Colors.amber.shade800,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                  const SizedBox(height: 24),

                  // === Ulangi Quiz Button ===
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => QuizPage(
                              category: widget.category,
                              questionCount: widget.questionCount,
                            ),
                          ),
                        );
                      },
                      icon: const Icon(Icons.refresh_rounded, size: 20),
                      label: const Text(
                        'Ulangi Quiz',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4F46E5),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // === Kembali ke Home Button ===
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: OutlinedButton.icon(
                      onPressed: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const HomePage(),
                          ),
                          (route) => false,
                        );
                      },
                      icon: const Icon(Icons.home_rounded, size: 20),
                      label: const Text(
                        'Kembali ke Home',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFF4F46E5),
                        side: const BorderSide(
                          color: Color(0xFF4F46E5),
                          width: 1.5,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),

          // === Bottom Navigation Bar ===
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 8,
                  offset: const Offset(0, -1),
                ),
              ],
            ),
            child: BottomNavigationBar(
              currentIndex: 0,
              backgroundColor: Colors.white,
              elevation: 0,
              selectedItemColor: const Color(0xFF4F46E5),
              unselectedItemColor: Colors.grey.shade400,
              selectedFontSize: 12,
              unselectedFontSize: 12,
              type: BottomNavigationBarType.fixed,
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home_rounded),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.leaderboard_rounded),
                  label: 'Skor',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatBox({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFE5E7EB),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Icon(icon, size: 24, color: const Color(0xFF4F46E5)),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey.shade500,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: Color(0xFF1E2A5E),
            ),
          ),
        ],
      ),
    );
  }
}

// === Custom Painter for Circular Score Ring ===
class _ScoreRingPainter extends CustomPainter {
  final double progress;
  final Color bgColor;
  final Color fgColor;
  final double strokeWidth;

  _ScoreRingPainter({
    required this.progress,
    required this.bgColor,
    required this.fgColor,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    final bgPaint = Paint()
      ..color = bgColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, bgPaint);

    final fgPaint = Paint()
      ..color = fgColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final sweepAngle = 2 * pi * progress;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -pi / 2,
      sweepAngle,
      false,
      fgPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _ScoreRingPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}

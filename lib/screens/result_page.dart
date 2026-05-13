import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/question_model.dart';
import 'home_page.dart';

class ResultPage extends StatefulWidget {
  final int score;
  final int totalQuestions;
  final QuizCategory category;

  const ResultPage({
    super.key,
    required this.score,
    required this.totalQuestions,
    required this.category,
  });

  @override
  State<ResultPage> createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  int? _highScore;
  bool _isNewHighScore = false;

  @override
  void initState() {
    super.initState();
    _loadAndSaveScore();
  }

  // Simpan skor ke local storage & cek apakah skor tertinggi baru
  Future<void> _loadAndSaveScore() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'highscore_${widget.category.name}';
    final savedHighScore = prefs.getInt(key) ?? 0;

    if (widget.score > savedHighScore) {
      // Skor baru lebih tinggi → simpan
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

  // Menentukan pesan dan emoji berdasarkan persentase skor
  String _getMessage() {
    double percentage = (widget.score / widget.totalQuestions) * 100;
    if (percentage >= 80) return 'Luar Biasa! 🎉';
    if (percentage >= 60) return 'Bagus! 👍';
    return 'Coba Lagi! 💪';
  }

  // Menentukan warna berdasarkan persentase skor
  Color _getColor() {
    double percentage = (widget.score / widget.totalQuestions) * 100;
    if (percentage >= 80) return Colors.green;
    if (percentage >= 60) return Colors.orange;
    return Colors.red;
  }

  // Menentukan icon berdasarkan persentase skor
  IconData _getIcon() {
    double percentage = (widget.score / widget.totalQuestions) * 100;
    if (percentage >= 80) return Icons.emoji_events;
    if (percentage >= 60) return Icons.thumb_up_alt;
    return Icons.refresh;
  }

  // Nama kategori yang ditampilkan
  String _getCategoryName() {
    switch (widget.category) {
      case QuizCategory.programming:
        return 'Pemrograman';
      case QuizCategory.islamic:
        return 'Agama Islam';
    }
  }

  @override
  Widget build(BuildContext context) {
    final Color resultColor = _getColor();

    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              resultColor.withValues(alpha: 0.78),
              resultColor.withValues(alpha: 0.47),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icon hasil
              Container(
                padding: const EdgeInsets.all(28),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  _getIcon(),
                  size: 80,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 32),

              // Pesan motivasi
              Text(
                _getMessage(),
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),

              // Nama kategori
              Text(
                'Kategori: ${_getCategoryName()}',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white.withValues(alpha: 0.85),
                ),
              ),
              const SizedBox(height: 24),

              // Skor
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 20,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    const Text(
                      'Skor Kamu',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white70,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${widget.score} / ${widget.totalQuestions}',
                      style: const TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // === Skor Tertinggi (dari local storage) ===
              if (_highScore != null)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        _isNewHighScore ? Icons.star : Icons.workspace_premium,
                        color: Colors.amber,
                        size: 24,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        _isNewHighScore
                            ? '🎊 Skor Tertinggi Baru!'
                            : 'Skor Tertinggi: $_highScore',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: 40),

              // Tombol Ulangi Quiz
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 48),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      // Kembali ke HomePage dan clear navigation stack
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const HomePage(),
                        ),
                        (route) => false,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: resultColor,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      elevation: 4,
                    ),
                    child: const Text(
                      'Ulangi Quiz',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

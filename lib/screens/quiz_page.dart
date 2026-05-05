import 'package:flutter/material.dart';
import '../models/question_model.dart';
import 'result_page.dart';

class QuizPage extends StatefulWidget {
  const QuizPage({super.key});

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  late List<Question> quizQuestions;
  int _currentQuestionIndex = 0;
  int _score = 0;
  bool _answered = false;
  int? _selectedAnswerIndex;

  @override
  void initState() {
    super.initState();
    // Acak soal dan ambil 10 soal dari bank soal
    quizQuestions = List<Question>.from(allQuestions)..shuffle();
    quizQuestions = quizQuestions.take(10).toList();
  }

  void _onAnswerSelected(int selectedIndex) {
    if (_answered) return; // Cegah jawab lebih dari sekali

    setState(() {
      _answered = true;
      _selectedAnswerIndex = selectedIndex;

      // Cek jawaban benar
      if (selectedIndex ==
          quizQuestions[_currentQuestionIndex].correctAnswerIndex) {
        _score++;
      }
    });

    // Delay sebelum lanjut ke soal berikutnya (biar user lihat feedback warna)
    Future.delayed(const Duration(milliseconds: 800), () {
      if (!mounted) return;
      if (_currentQuestionIndex < quizQuestions.length - 1) {
        // Lanjut ke soal berikutnya
        setState(() {
          _currentQuestionIndex++;
          _answered = false;
          _selectedAnswerIndex = null;
        });
      } else {
        // Soal habis → pindah ke Result Page
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => ResultPage(
              score: _score,
              totalQuestions: quizQuestions.length,
            ),
          ),
        );
      }
    });
  }

  Color _getButtonColor(int index) {
    if (!_answered) return Colors.deepPurple.shade50;

    final correctIndex =
        quizQuestions[_currentQuestionIndex].correctAnswerIndex;

    if (index == correctIndex) {
      return Colors.green.shade100; // Jawaban benar → hijau
    }
    if (index == _selectedAnswerIndex) {
      return Colors.red.shade100; // Jawaban salah yang dipilih → merah
    }
    return Colors.deepPurple.shade50;
  }

  Color _getBorderColor(int index) {
    if (!_answered) return Colors.deepPurple.shade200;

    final correctIndex =
        quizQuestions[_currentQuestionIndex].correctAnswerIndex;

    if (index == correctIndex) return Colors.green;
    if (index == _selectedAnswerIndex) return Colors.red;
    return Colors.deepPurple.shade200;
  }

  @override
  Widget build(BuildContext context) {
    final question = quizQuestions[_currentQuestionIndex];

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'QuizQu',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Progress bar
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value:
                    (_currentQuestionIndex + 1) / quizQuestions.length,
                minHeight: 8,
                backgroundColor: Colors.deepPurple.shade50,
                valueColor: AlwaysStoppedAnimation<Color>(
                  Colors.deepPurple.shade400,
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Nomor soal
            Text(
              'Soal ${_currentQuestionIndex + 1} / ${quizQuestions.length}',
              style: TextStyle(
                fontSize: 16,
                color: Colors.deepPurple.shade300,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 20),

            // Teks pertanyaan
            Text(
              question.questionText,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 28),

            // Pilihan jawaban
            ...List.generate(question.answers.length, (index) {
              return Container(
                width: double.infinity,
                margin: const EdgeInsets.symmetric(vertical: 6),
                child: ElevatedButton(
                  onPressed: _answered ? null : () => _onAnswerSelected(index),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _getButtonColor(index),
                    foregroundColor: Colors.black87,
                    disabledBackgroundColor: _getButtonColor(index),
                    disabledForegroundColor: Colors.black87,
                    padding: const EdgeInsets.symmetric(
                        vertical: 14, horizontal: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(color: _getBorderColor(index), width: 1.5),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    question.answers[index],
                    style: const TextStyle(fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                ),
              );
            }),

            const Spacer(),

            // Skor saat ini
            Center(
              child: Text(
                'Skor: $_score',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey.shade600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

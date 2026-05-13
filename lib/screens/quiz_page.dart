import 'dart:async';
import 'package:flutter/material.dart';
import '../models/question_model.dart';
import '../widgets/answer_button.dart';
import 'result_page.dart';

class QuizPage extends StatefulWidget {
  final QuizCategory category;

  const QuizPage({super.key, required this.category});

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  late List<Question> quizQuestions;
  int _currentQuestionIndex = 0;
  int _score = 0;
  bool _answered = false;
  int? _selectedAnswerIndex;

  // === Timer per soal ===
  static const int _timePerQuestion = 15; // detik per soal
  int _timeRemaining = _timePerQuestion;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    // Acak soal dan ambil 25 soal dari bank soal berdasarkan kategori
    quizQuestions = List<Question>.from(questionBank[widget.category] ?? [])..shuffle();
    quizQuestions = quizQuestions.take(25).toList();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  // Mulai countdown timer untuk soal saat ini
  void _startTimer() {
    _timer?.cancel();
    _timeRemaining = _timePerQuestion;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      setState(() {
        if (_timeRemaining > 0) {
          _timeRemaining--;
        } else {
          // Waktu habis → otomatis lanjut (dianggap salah)
          timer.cancel();
          _onTimeUp();
        }
      });
    });
  }

  // Dipanggil saat waktu habis tanpa menjawab
  void _onTimeUp() {
    if (_answered) return;

    setState(() {
      _answered = true;
      _selectedAnswerIndex = null; // Tidak ada yang dipilih
    });

    Future.delayed(const Duration(milliseconds: 800), () {
      _goToNextQuestion();
    });
  }

  void _onAnswerSelected(int selectedIndex) {
    if (_answered) return; // Cegah jawab lebih dari sekali

    _timer?.cancel(); // Stop timer saat sudah jawab

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
      _goToNextQuestion();
    });
  }

  void _goToNextQuestion() {
    if (!mounted) return;

    if (_currentQuestionIndex < quizQuestions.length - 1) {
      // Lanjut ke soal berikutnya
      setState(() {
        _currentQuestionIndex++;
        _answered = false;
        _selectedAnswerIndex = null;
      });
      _startTimer();
    } else {
      // Soal habis → pindah ke Result Page
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ResultPage(
            score: _score,
            totalQuestions: quizQuestions.length,
            category: widget.category,
          ),
        ),
      );
    }
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

  // Warna timer berubah sesuai sisa waktu
  Color _getTimerColor() {
    if (_timeRemaining > 10) return Colors.green;
    if (_timeRemaining > 5) return Colors.orange;
    return Colors.red;
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
            const SizedBox(height: 12),

            // Nomor soal + Timer
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Soal ${_currentQuestionIndex + 1} / ${quizQuestions.length}',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.deepPurple.shade300,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                // Timer badge
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: _getTimerColor().withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: _getTimerColor(),
                      width: 1.5,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.timer_outlined,
                        size: 18,
                        color: _getTimerColor(),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${_timeRemaining}s',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: _getTimerColor(),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
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

            // Pilihan jawaban — menggunakan widget AnswerButton
            ...List.generate(question.answers.length, (index) {
              return AnswerButton(
                answerText: question.answers[index],
                onTap: _answered ? null : () => _onAnswerSelected(index),
                backgroundColor: _getButtonColor(index),
                borderColor: _getBorderColor(index),
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

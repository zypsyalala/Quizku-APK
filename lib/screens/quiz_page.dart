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

  // Timer per soal
  static const int _timePerQuestion = 15;
  int _timeRemaining = _timePerQuestion;
  Timer? _timer;

  final List<String> _labels = ['A', 'B', 'C', 'D'];

  // Stopwatch untuk tracking waktu total
  final Stopwatch _stopwatch = Stopwatch();

  @override
  void initState() {
    super.initState();
    quizQuestions = List<Question>.from(questionBank[widget.category] ?? [])..shuffle();
    quizQuestions = quizQuestions.take(25).toList();
    _stopwatch.start();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _stopwatch.stop();
    super.dispose();
  }

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
          timer.cancel();
          _onTimeUp();
        }
      });
    });
  }

  void _onTimeUp() {
    if (_answered) return;
    setState(() {
      _answered = true;
      _selectedAnswerIndex = null;
    });
  }

  void _onAnswerSelected(int selectedIndex) {
    if (_answered) return;
    _timer?.cancel();

    setState(() {
      _answered = true;
      _selectedAnswerIndex = selectedIndex;
      if (selectedIndex == quizQuestions[_currentQuestionIndex].correctAnswerIndex) {
        _score++;
      }
    });
  }

  void _goToNextQuestion() {
    if (!mounted) return;

    if (_currentQuestionIndex < quizQuestions.length - 1) {
      setState(() {
        _currentQuestionIndex++;
        _answered = false;
        _selectedAnswerIndex = null;
      });
      _startTimer();
    } else {
      _stopwatch.stop();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ResultPage(
            score: _score,
            totalQuestions: quizQuestions.length,
            category: widget.category,
            elapsedSeconds: _stopwatch.elapsed.inSeconds,
          ),
        ),
      );
    }
  }

  String _getCategoryLabel() {
    switch (widget.category) {
      case QuizCategory.programming:
        return 'PEMROGRAMAN';
      case QuizCategory.islamic:
        return 'AGAMA ISLAM';
      case QuizCategory.english:
        return 'BAHASA INGGRIS';
    }
  }

  Color _getTimerColor() {
    if (_timeRemaining > 10) return const Color(0xFF4F46E5);
    if (_timeRemaining > 5) return Colors.orange;
    return const Color(0xFFEF4444);
  }

  @override
  Widget build(BuildContext context) {
    final question = quizQuestions[_currentQuestionIndex];
    final progress = (_currentQuestionIndex + 1) / quizQuestions.length;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),

      // === App Bar ===
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.menu_rounded, color: Color(0xFF1E2A5E)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'QuizQu',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w800,
            color: Color(0xFF1E2A5E),
          ),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: const Color(0xFF1E2A5E),
              shape: BoxShape.circle,
              border: Border.all(
                color: const Color(0xFF4F46E5).withValues(alpha: 0.3),
                width: 2,
              ),
            ),
            child: const Icon(
              Icons.person_rounded,
              color: Colors.white,
              size: 20,
            ),
          ),
        ],
      ),

      body: Column(
        children: [
          // === Sub-header: Category, Question counter, Timer ===
          Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Category + Question counter
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _getCategoryLabel(),
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF4F46E5),
                            letterSpacing: 1.2,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Question ${_currentQuestionIndex + 1} of ${quizQuestions.length}',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF1E2A5E),
                          ),
                        ),
                      ],
                    ),
                    // Timer
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: _getTimerColor().withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.access_time_rounded,
                            size: 16,
                            color: _getTimerColor(),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${(_timeRemaining ~/ 60).toString().padLeft(2, '0')}:${(_timeRemaining % 60).toString().padLeft(2, '0')}',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: _getTimerColor(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                // Progress bar
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 5,
                    backgroundColor: const Color(0xFFE5E7EB),
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      Color(0xFF4F46E5),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // === Scrollable content ===
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
              child: Column(
                children: [
                  // === Question Card ===
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.fromLTRB(24, 28, 24, 28),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEEF2FF),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: const Color(0xFFDDD6FE),
                        width: 1,
                      ),
                    ),
                    child: Column(
                      children: [
                        // Quiz icon
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: const Color(0xFF4F46E5).withValues(alpha: 0.12),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.lightbulb_outline_rounded,
                            size: 28,
                            color: Color(0xFF4F46E5),
                          ),
                        ),
                        const SizedBox(height: 20),
                        // Question text
                        Text(
                          question.questionText,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF1E2A5E),
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // === Answer Options ===
                  ...List.generate(question.answers.length, (index) {
                    final correctIndex = question.correctAnswerIndex;
                    return AnswerButton(
                      label: _labels[index],
                      answerText: question.answers[index],
                      onTap: _answered ? null : () => _onAnswerSelected(index),
                      isSelected: _selectedAnswerIndex == index,
                      isCorrect: index == correctIndex,
                      showResult: _answered,
                    );
                  }),
                ],
              ),
            ),
          ),

          // === Bottom bar: Report Issue + Next button ===
          Container(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Report issue
                TextButton.icon(
                  onPressed: () {},
                  icon: Icon(
                    Icons.flag_outlined,
                    size: 18,
                    color: Colors.grey.shade500,
                  ),
                  label: Text(
                    'Report Issue',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey.shade500,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                // Next button
                SizedBox(
                  height: 48,
                  child: ElevatedButton(
                    onPressed: _answered ? _goToNextQuestion : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4F46E5),
                      foregroundColor: Colors.white,
                      disabledBackgroundColor: const Color(0xFFD1D5DB),
                      disabledForegroundColor: Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(horizontal: 28),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          _currentQuestionIndex < quizQuestions.length - 1
                              ? 'Next'
                              : 'Finish',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(width: 6),
                        const Icon(Icons.arrow_forward_rounded, size: 20),
                      ],
                    ),
                  ),
                ),
              ],
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
              currentIndex: 1,
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
                  label: 'Leagues',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person_rounded),
                  label: 'Profile',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

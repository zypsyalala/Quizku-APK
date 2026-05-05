class Question {
  final String questionText;
  final List<String> answers;
  final int correctAnswerIndex;

  const Question({
    required this.questionText,
    required this.answers,
    required this.correctAnswerIndex,
  });
}

// Data soal quiz statis
final List<Question> quizQuestions = [
  const Question(
    questionText: 'Apa kepanjangan HTML?',
    answers: [
      'Hyper Tool Markup Language',
      'Hyper Text Markup Language',
      'Home Tool Markup Language',
      'Hyperlinks Text Mark Language',
    ],
    correctAnswerIndex: 1,
  ),
  const Question(
    questionText: 'Bahasa pemrograman apa yang digunakan untuk membuat aplikasi Flutter?',
    answers: [
      'Java',
      'Kotlin',
      'Dart',
      'Swift',
    ],
    correctAnswerIndex: 2,
  ),
  const Question(
    questionText: 'Apa kepanjangan CSS?',
    answers: [
      'Creative Style Sheets',
      'Computer Style Sheets',
      'Cascading Style Sheets',
      'Colorful Style Sheets',
    ],
    correctAnswerIndex: 2,
  ),
  const Question(
    questionText: 'Manakah yang merupakan sistem operasi?',
    answers: [
      'Microsoft Word',
      'Google Chrome',
      'Linux',
      'Visual Studio Code',
    ],
    correctAnswerIndex: 2,
  ),
  const Question(
    questionText: 'Apa fungsi utama dari RAM pada komputer?',
    answers: [
      'Menyimpan data secara permanen',
      'Memproses grafis',
      'Menyimpan data sementara saat komputer menyala',
      'Menghubungkan ke internet',
    ],
    correctAnswerIndex: 2,
  ),
];

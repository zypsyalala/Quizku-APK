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

// Bank soal quiz (20 soal)
final List<Question> allQuestions = [
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
  const Question(
    questionText: 'Apa kepanjangan dari CPU?',
    answers: [
      'Central Process Unit',
      'Computer Personal Unit',
      'Central Processing Unit',
      'Central Program Utility',
    ],
    correctAnswerIndex: 2,
  ),
  const Question(
    questionText: 'Bahasa pemrograman apa yang paling populer untuk pengembangan web frontend?',
    answers: [
      'Python',
      'JavaScript',
      'C++',
      'Ruby',
    ],
    correctAnswerIndex: 1,
  ),
  const Question(
    questionText: 'Apa itu Git?',
    answers: [
      'Bahasa pemrograman',
      'Sistem manajemen database',
      'Sistem kontrol versi',
      'Framework web',
    ],
    correctAnswerIndex: 2,
  ),
  const Question(
    questionText: 'Manakah yang bukan bahasa pemrograman?',
    answers: [
      'Python',
      'Photoshop',
      'Java',
      'Go',
    ],
    correctAnswerIndex: 1,
  ),
  const Question(
    questionText: 'Apa fungsi dari DNS?',
    answers: [
      'Mengenkripsi data',
      'Menerjemahkan nama domain ke alamat IP',
      'Menyimpan file',
      'Mengirim email',
    ],
    correctAnswerIndex: 1,
  ),
  const Question(
    questionText: 'Apa kepanjangan dari URL?',
    answers: [
      'Uniform Resource Locator',
      'Universal Reference Link',
      'Uniform Reference Locator',
      'Universal Resource Locator',
    ],
    correctAnswerIndex: 0,
  ),
  const Question(
    questionText: 'Berapa bit dalam 1 byte?',
    answers: [
      '4 bit',
      '8 bit',
      '16 bit',
      '32 bit',
    ],
    correctAnswerIndex: 1,
  ),
  const Question(
    questionText: 'Apa itu firewall?',
    answers: [
      'Perangkat keras untuk mencetak',
      'Sistem keamanan jaringan',
      'Aplikasi pengolah kata',
      'Jenis kabel jaringan',
    ],
    correctAnswerIndex: 1,
  ),
  const Question(
    questionText: 'Framework manakah yang dibuat oleh Google untuk mobile development?',
    answers: [
      'React Native',
      'Xamarin',
      'Flutter',
      'Ionic',
    ],
    correctAnswerIndex: 2,
  ),
  const Question(
    questionText: 'Apa kepanjangan dari API?',
    answers: [
      'Application Programming Interface',
      'Applied Program Integration',
      'Application Process Interface',
      'Automated Programming Interface',
    ],
    correctAnswerIndex: 0,
  ),
  const Question(
    questionText: 'Apa itu database relasional?',
    answers: [
      'Database yang menyimpan data dalam bentuk gambar',
      'Database yang menyimpan data dalam bentuk tabel dengan relasi',
      'Database tanpa struktur',
      'Database yang hanya menyimpan teks',
    ],
    correctAnswerIndex: 1,
  ),
  const Question(
    questionText: 'Manakah yang merupakan bahasa markup?',
    answers: [
      'Python',
      'Java',
      'HTML',
      'C#',
    ],
    correctAnswerIndex: 2,
  ),
  const Question(
    questionText: 'Apa itu cloud computing?',
    answers: [
      'Komputasi menggunakan awan',
      'Penyediaan layanan komputasi melalui internet',
      'Penyimpanan data di harddisk',
      'Jaringan komputer lokal',
    ],
    correctAnswerIndex: 1,
  ),
  const Question(
    questionText: 'Apa kepanjangan dari SSD?',
    answers: [
      'Solid State Drive',
      'Super Speed Disk',
      'System Storage Device',
      'Solid System Drive',
    ],
    correctAnswerIndex: 0,
  ),
  const Question(
    questionText: 'Siapa pendiri Microsoft?',
    answers: [
      'Steve Jobs',
      'Mark Zuckerberg',
      'Bill Gates',
      'Elon Musk',
    ],
    correctAnswerIndex: 2,
  ),
  const Question(
    questionText: 'Apa itu algoritma?',
    answers: [
      'Jenis komputer',
      'Langkah-langkah sistematis untuk menyelesaikan masalah',
      'Bahasa pemrograman',
      'Perangkat keras komputer',
    ],
    correctAnswerIndex: 1,
  ),
];

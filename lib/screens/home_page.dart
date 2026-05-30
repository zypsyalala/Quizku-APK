import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'quiz_page.dart';
import '../models/question_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentNavIndex = 0;
  int _highScoreProgramming = 0;
  int _highScoreIslamic = 0;
  int _highScoreEnglish = 0;

  @override
  void initState() {
    super.initState();
    _loadHighScores();
  }

  Future<void> _loadHighScores() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _highScoreProgramming = prefs.getInt('highscore_programming') ?? 0;
      _highScoreIslamic = prefs.getInt('highscore_islamic') ?? 0;
      _highScoreEnglish = prefs.getInt('highscore_english') ?? 0;
    });
  }

  int get _totalHighScore => _highScoreProgramming + _highScoreIslamic + _highScoreEnglish;

  void _showCategoryPicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        padding: const EdgeInsets.fromLTRB(24, 12, 24, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Pilih Kategori',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: Color(0xFF1E2A5E),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              '25 soal acak akan dipilih untuk kamu',
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey.shade500,
              ),
            ),
            const SizedBox(height: 24),

            // Category tiles
            _buildCategoryTile(
              icon: Icons.code_rounded,
              title: 'Pemrograman',
              subtitle: '51 soal tersedia',
              color: const Color(0xFF7C3AED),
              category: QuizCategory.programming,
            ),
            const SizedBox(height: 12),
            _buildCategoryTile(
              icon: Icons.mosque_rounded,
              title: 'Agama Islam',
              subtitle: '51 soal tersedia',
              color: const Color(0xFF059669),
              category: QuizCategory.islamic,
            ),
            const SizedBox(height: 12),
            _buildCategoryTile(
              icon: Icons.translate_rounded,
              title: 'Bahasa Inggris',
              subtitle: '50 soal tersedia',
              color: const Color(0xFF2563EB),
              category: QuizCategory.english,
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  void _showQuestionCountPicker(QuizCategory category, String categoryName, Color color) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        padding: const EdgeInsets.fromLTRB(24, 12, 24, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Pilih Jumlah Soal',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: const Color(0xFF1E2A5E),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Kategori: $categoryName',
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey.shade500,
              ),
            ),
            const SizedBox(height: 24),

            // Question count options
            Row(
              children: [
                Expanded(
                  child: _buildCountOption(
                    count: 10,
                    label: '10 Soal',
                    subtitle: 'Cepat',
                    icon: Icons.bolt_rounded,
                    color: color,
                    category: category,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _buildCountOption(
                    count: 15,
                    label: '15 Soal',
                    subtitle: 'Sedang',
                    icon: Icons.timer_rounded,
                    color: color,
                    category: category,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _buildCountOption(
                    count: 25,
                    label: '25 Soal',
                    subtitle: 'Lengkap',
                    icon: Icons.star_rounded,
                    color: color,
                    category: category,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Widget _buildCountOption({
    required int count,
    required String label,
    required String subtitle,
    required IconData icon,
    required Color color,
    required QuizCategory category,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          Navigator.pop(context); // close count picker
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => QuizPage(
                category: category,
                questionCount: count,
              ),
            ),
          ).then((_) => _loadHighScores());
        },
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 8),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.06),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: color.withValues(alpha: 0.15),
              width: 1,
            ),
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 22, color: Colors.white),
              ),
              const SizedBox(height: 10),
              Text(
                label,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: color,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.grey.shade500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required QuizCategory category,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          Navigator.pop(context); // close category bottom sheet
          _showQuestionCountPicker(category, title, color);
        },
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.06),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: color.withValues(alpha: 0.15),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, size: 24, color: Colors.white),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: color,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios_rounded,
                size: 16,
                color: color.withValues(alpha: 0.5),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),

      // === App Bar ===
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
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFF1E2A5E).withValues(alpha: 0.08),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.quiz_rounded,
              color: Color(0xFF1E2A5E),
              size: 22,
            ),
          ),
        ],
      ),

      // === Body ===
      body: IndexedStack(
        index: _currentNavIndex,
        children: [
          // === TAB 0: Home ===
          _buildHomeContent(),
          // === TAB 1: Skor ===
          _buildSkorContent(),
        ],
      ),

      // === Bottom Navigation Bar ===
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentNavIndex,
          onTap: (index) => setState(() => _currentNavIndex = index),
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
    );
  }

  // === HOME TAB CONTENT ===
  Widget _buildHomeContent() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(height: 20),

            // === Hero Image Card ===
            Stack(
              children: [
                Container(
                  width: double.infinity,
                  height: 220,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xFF6366F1),
                        Color(0xFF4F46E5),
                        Color(0xFF3730A3),
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF4F46E5).withValues(alpha: 0.3),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: Stack(
                      children: [
                        Positioned(
                          top: -30,
                          right: -20,
                          child: Container(
                            width: 120,
                            height: 120,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white.withValues(alpha: 0.08),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: -40,
                          left: -20,
                          child: Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white.withValues(alpha: 0.06),
                            ),
                          ),
                        ),
                        Positioned.fill(
                          child: Image.asset(
                            'assets/images/hero_illustration.png',
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Center(
                                child: Icon(
                                  Icons.auto_stories_rounded,
                                  size: 80,
                                  color: Colors.white.withValues(alpha: 0.5),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: 14,
                  left: 14,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.emoji_events_rounded, size: 16, color: Colors.amber.shade700),
                        const SizedBox(width: 4),
                        const Text(
                          'Top Scorer!',
                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Color(0xFF1E2A5E)),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  bottom: 14,
                  right: 14,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.bolt_rounded, size: 16, color: Colors.amber.shade700),
                        const SizedBox(width: 4),
                        Text(
                          'Skor: $_totalHighScore',
                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Color(0xFF1E2A5E)),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 28),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFF6366F1).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                'EDUCATION & FUN',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Color(0xFF6366F1), letterSpacing: 1.2),
              ),
            ),
            const SizedBox(height: 16),

            const Text(
              'Selamat Datang di\nQuizQu!',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800, color: Color(0xFF1E2A5E), height: 1.2),
            ),
            const SizedBox(height: 12),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                'Uji pengetahuanmu, kumpulkan poin, dan bersaing '
                'dengan teman dalam petualangan belajar yang seru. '
                'Tantangan baru menantimu setiap hari!',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Colors.grey.shade600, height: 1.6),
              ),
            ),
            const SizedBox(height: 28),

            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _showCategoryPicker,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4F46E5),
                  foregroundColor: Colors.white,
                  elevation: 4,
                  shadowColor: const Color(0xFF4F46E5).withValues(alpha: 0.4),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Mulai Quiz', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                    SizedBox(width: 8),
                    Icon(Icons.play_arrow_rounded, size: 24),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    icon: Icons.quiz_rounded, value: '152', label: 'Total Soal',
                    color: Colors.amber.shade700, bgColor: Colors.amber.shade50,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatCard(
                    icon: Icons.category_rounded, value: '3', label: 'Kategori',
                    color: const Color(0xFF6366F1), bgColor: const Color(0xFFEEF2FF),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatCard(
                    icon: Icons.star_rounded, value: '$_totalHighScore', label: 'Best Score',
                    color: const Color(0xFF059669), bgColor: const Color(0xFFECFDF5),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  // === SKOR TAB CONTENT ===
  Widget _buildSkorContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          const Text(
            'Skor Tertinggi',
            style: TextStyle(fontSize: 26, fontWeight: FontWeight.w800, color: Color(0xFF1E2A5E)),
          ),
          const SizedBox(height: 6),
          Text(
            'Rekor terbaikmu di setiap kategori',
            style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
          ),
          const SizedBox(height: 24),

          // Total skor card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF6366F1), Color(0xFF4F46E5)],
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF4F46E5).withValues(alpha: 0.3),
                  blurRadius: 16,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              children: [
                const Icon(Icons.emoji_events_rounded, size: 40, color: Colors.amber),
                const SizedBox(height: 8),
                Text(
                  '$_totalHighScore',
                  style: const TextStyle(fontSize: 48, fontWeight: FontWeight.w800, color: Colors.white),
                ),
                const Text(
                  'Total Skor Tertinggi',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.white70),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Per-category scores
          _buildScoreCard(
            icon: Icons.code_rounded,
            title: 'Pemrograman',
            score: _highScoreProgramming,
            maxScore: 25,
            color: const Color(0xFF7C3AED),
          ),
          const SizedBox(height: 12),
          _buildScoreCard(
            icon: Icons.mosque_rounded,
            title: 'Agama Islam',
            score: _highScoreIslamic,
            maxScore: 25,
            color: const Color(0xFF059669),
          ),
          const SizedBox(height: 12),
          _buildScoreCard(
            icon: Icons.translate_rounded,
            title: 'Bahasa Inggris',
            score: _highScoreEnglish,
            maxScore: 25,
            color: const Color(0xFF2563EB),
          ),
          const SizedBox(height: 24),

          // Reset button
          SizedBox(
            width: double.infinity,
            height: 48,
            child: OutlinedButton.icon(
              onPressed: () async {
                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: const Text('Reset Skor'),
                    content: const Text('Yakin ingin menghapus semua skor tertinggi?'),
                    actions: [
                      TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Batal')),
                      TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Reset', style: TextStyle(color: Colors.red))),
                    ],
                  ),
                );
                if (confirm == true) {
                  final prefs = await SharedPreferences.getInstance();
                  await prefs.remove('highscore_programming');
                  await prefs.remove('highscore_islamic');
                  await prefs.remove('highscore_english');
                  _loadHighScores();
                }
              },
              icon: const Icon(Icons.restart_alt_rounded, size: 20),
              label: const Text('Reset Semua Skor', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.red.shade400,
                side: BorderSide(color: Colors.red.shade300),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildScoreCard({
    required IconData icon,
    required String title,
    required int score,
    required int maxScore,
    required Color color,
  }) {
    final progress = maxScore > 0 ? score / maxScore : 0.0;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, size: 24, color: color),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: const Color(0xFF1E2A5E))),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 6,
                    backgroundColor: const Color(0xFFE5E7EB),
                    valueColor: AlwaysStoppedAnimation<Color>(color),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 14),
          Text(
            '$score/$maxScore',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: color),
          ),
        ],
      ),
    );
  }
  // === Stat Card Widget ===
  Widget _buildStatCard({
    required IconData icon,
    required String value,
    required String label,
    required Color color,
    required Color bgColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: bgColor,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 22, color: color),
          ),
          const SizedBox(height: 10),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: color,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: Colors.grey.shade500,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

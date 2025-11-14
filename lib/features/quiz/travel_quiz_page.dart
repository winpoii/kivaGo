import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/models/travel_quiz.dart';
import '../../core/models/travel_profile.dart';
import '../../core/models/user_model.dart';
import '../../core/services/auth_service.dart';
import 'quiz_result_page.dart';

/// Travel personality quiz page with experience-focused design
class TravelQuizPage extends StatefulWidget {
  const TravelQuizPage({super.key});

  @override
  State<TravelQuizPage> createState() => _TravelQuizPageState();
}

class _TravelQuizPageState extends State<TravelQuizPage>
    with SingleTickerProviderStateMixin {
  final List<int> _answers = [];
  int _currentQuestion = 0;
  final AuthService _authService = AuthService();
  bool _isLoading = false;
  static const List<String> _optionPrefixes = ['A', 'B', 'C', 'D', 'E', 'F'];
  late AnimationController _optionsAnimationController;

  @override
  void initState() {
    super.initState();
    _optionsAnimationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    // İlk soru için animasyonu başlat
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _optionsAnimationController.forward();
    });
  }

  @override
  void dispose() {
    _optionsAnimationController.dispose();
    super.dispose();
  }

  void _selectAnswer(int answerIndex) {
    if (!mounted || _isLoading) return;

    setState(() {
      if (_currentQuestion < _answers.length) {
        _answers[_currentQuestion] = answerIndex;
      } else {
        _answers.add(answerIndex);
      }
    });

    Future.delayed(const Duration(milliseconds: 280), () async {
      if (!mounted) return;

      if (_currentQuestion < TravelQuiz.questions.length - 1) {
        // Animasyonu sıfırla ve yeni soru için başlat
        _optionsAnimationController.reset();
        setState(() => _currentQuestion++);
        _optionsAnimationController.forward();
      } else {
        await _showResults();
      }
    });
  }

  Future<void> _showResults() async {
    if (!mounted) return;

    setState(() => _isLoading = true);

    try {
      final profile = TravelQuiz.calculateProfile(_answers);
      await _saveQuizResults(_answers, profile);

      if (mounted) {
        Get.off(
          () => QuizResultPage(profile: profile),
          transition: Transition.cupertino,
          duration: const Duration(milliseconds: 420),
        );
      }
    } catch (e) {
      if (mounted) {
        Get.snackbar(
          'Hata',
          'Quiz sonuçları kaydedilirken hata oluştu',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: const Color(0xFF1F1F1F),
          colorText: Colors.white,
          margin: const EdgeInsets.all(18),
          borderRadius: 14,
          duration: const Duration(seconds: 2),
        );

        final fallbackProfile = TravelQuiz.calculateProfile(_answers);
        Get.off(
          () => QuizResultPage(profile: fallbackProfile),
          transition: Transition.cupertino,
          duration: const Duration(milliseconds: 420),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _saveQuizResults(
      List<int> answers, TravelProfile profile) async {
    try {
      final user = await _authService.getCurrentUserFromFirestore();
      if (user == null) throw Exception('Kullanıcı bulunamadı');

      final newSeekerProfile = SeekerProfileModel(
        title: profile.type.title,
        description: profile.type.description,
        testAnswers: answers,
        calculatedScores: CalculatedScoresModel(
          adventure: profile.scores[TravelProfileType.adventureSeeker] ?? 0.0,
          serenity: profile.scores[TravelProfileType.relaxedTraveler] ?? 0.0,
          culture: profile.scores[TravelProfileType.explorer] ?? 0.0,
          social: profile.scores[TravelProfileType.socialTraveler] ?? 0.0,
        ),
      );

      await _authService.updateSeekerProfile(newSeekerProfile);
    } catch (e) {
      debugPrint('Error saving quiz results: $e');
      rethrow;
    }
  }

  void _previousQuestion() {
    if (!mounted || _isLoading) return;
    if (_currentQuestion > 0) {
      // Animasyonu sıfırla ve önceki soru için başlat
      _optionsAnimationController.reset();
      setState(() => _currentQuestion--);
      _optionsAnimationController.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    final progress = (_currentQuestion + 1) / TravelQuiz.questions.length;
    final question = TravelQuiz.questions[_currentQuestion];
    final screenWidth = Get.width;
    final screenHeight = Get.height;
    final isSmallScreen = screenWidth < 360;
    final horizontalPadding = isSmallScreen ? 22.0 : 28.0;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: horizontalPadding,
            vertical: 24,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(isSmallScreen),
              const SizedBox(height: 15),
              _buildProgressBar(progress, screenWidth, horizontalPadding),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 1),
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 420),
                    switchInCurve: Curves.easeOutCubic,
                    switchOutCurve: Curves.easeInCubic,
                    transitionBuilder: (child, animation) {
                      final slideAnimation = Tween<Offset>(
                        begin: const Offset(0.06, 0),
                        end: Offset.zero,
                      ).animate(CurvedAnimation(
                        parent: animation,
                        curve: Curves.easeOutCubic,
                      ));
                      return FadeTransition(
                        opacity: animation,
                        child: SlideTransition(
                          position: slideAnimation,
                          child: child,
                        ),
                      );
                    },
                    child: _isLoading
                        ? _buildLoadingState(isSmallScreen, screenHeight)
                        : _buildQuestionContent(
                            key: ValueKey(_currentQuestion),
                            question: question,
                            isSmallScreen: isSmallScreen,
                            screenHeight: screenHeight,
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

  Widget _buildHeader(bool isSmallScreen) {
    return Row(
      children: [
        _HeaderIconButton(
          icon: Icons.arrow_back_rounded,
          onTap: _currentQuestion == 0 ? () => Get.back() : _previousQuestion,
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Kişilik Testi.',
                style: TextStyle(
                  fontSize: isSmallScreen ? 17 : 18,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.2,
                  color: const Color(0xFF0A0A0A),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Senin için doğru seyahat kimliğini bulalım.',
                style: TextStyle(
                  fontSize: isSmallScreen ? 12 : 13,
                  color: const Color(0xFF8C8C8C),
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        const SizedBox(width: 44),
      ],
    );
  }

  Widget _buildProgressBar(
    double progress,
    double screenWidth,
    double horizontalPadding,
  ) {
    final totalWidth = screenWidth - (horizontalPadding * 2);
    final double baseWidth = 60;
    final double dynamicWidth = baseWidth + (totalWidth - baseWidth) * progress;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          '${(_currentQuestion + 1).toString().padLeft(2, '0')} / ${TravelQuiz.questions.length}',
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Color(0xFF8C8C8C),
          ),
        ),
        const SizedBox(height: 14),
        SizedBox(
          height: 24,
          child: Center(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 420),
              curve: Curves.easeOutCubic,
              width: dynamicWidth,
              height: 8,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                gradient: const LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    Color(0xFFC11336),
                    Color(0xFFE63946),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildQuestionContent({
    required Key key,
    required QuizQuestion question,
    required bool isSmallScreen,
    required double screenHeight,
  }) {
    return SingleChildScrollView(
      key: key,
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(22),
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFFFFF6F2),
                  Color(0xFFFFFBF8),
                ],
              ),
            ),
            child: Text(
              question.question,
              style: TextStyle(
                fontSize: isSmallScreen ? 19 : 21,
                fontWeight: FontWeight.w600,
                height: 1.5,
                letterSpacing: -0.3,
                color: const Color(0xFF343434),
              ),
            ),
          ),
          SizedBox(height: screenHeight * 0.040),
          Transform.translate(
            offset: const Offset(0, -12),
            child: Column(
              children: question.answers.asMap().entries.map((entry) {
                final answerIndex = entry.key;
                final answer = entry.value;
                final isSelected = _answers.length > _currentQuestion &&
                    _answers[_currentQuestion] == answerIndex;

                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _AnimatedAnswerOptionTile(
                    label:
                        _optionPrefixes[answerIndex % _optionPrefixes.length],
                    text: answer.text,
                    isSelected: isSelected,
                    onTap: () => _selectAnswer(answerIndex),
                    animationController: _optionsAnimationController,
                    delay: answerIndex * 0.08, // Her seçenek için 80ms gecikme
                  ),
                );
              }).toList(),
            ),
          ),
          SizedBox(height: screenHeight * 0.02),
        ],
      ),
    );
  }

  Widget _buildLoadingState(bool isSmallScreen, double screenHeight) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(28),
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 22,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: const CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFC11336)),
            strokeWidth: 3.2,
          ),
        ),
        SizedBox(height: screenHeight * 0.035),
        Text(
          'Profilin hazırlanıyor...',
          style: TextStyle(
            fontSize: isSmallScreen ? 16 : 17,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF1F1F1F),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'Sana özel seyahat önerilerini çıkarıyoruz.',
          style: TextStyle(
            fontSize: isSmallScreen ? 13 : 14,
            color: const Color(0xFF8C8C8C),
          ),
        ),
      ],
    );
  }
}

class _HeaderIconButton extends StatelessWidget {
  const _HeaderIconButton({
    required this.icon,
    required this.onTap,
  });

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFFFAFAFA),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Icon(
          icon,
          size: 22,
          color: const Color(0xFF0A0A0A),
        ),
      ),
    );
  }
}

class _AnimatedAnswerOptionTile extends StatelessWidget {
  const _AnimatedAnswerOptionTile({
    required this.label,
    required this.text,
    required this.isSelected,
    required this.onTap,
    required this.animationController,
    required this.delay,
  });

  final String label;
  final String text;
  final bool isSelected;
  final VoidCallback onTap;
  final AnimationController animationController;
  final double delay;

  @override
  Widget build(BuildContext context) {
    // Her seçenek için gecikmeli animasyon
    final animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: animationController,
        curve: Interval(
          delay,
          delay + 0.3,
          curve: Curves.easeOutCubic,
        ),
      ),
    );

    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Opacity(
          opacity: animation.value,
          child: Transform.translate(
            offset: Offset(0, 20 * (1 - animation.value)),
            child: _AnswerOptionTile(
              label: label,
              text: text,
              isSelected: isSelected,
              onTap: onTap,
            ),
          ),
        );
      },
    );
  }
}

class _AnswerOptionTile extends StatelessWidget {
  const _AnswerOptionTile({
    required this.label,
    required this.text,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final String text;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 240),
      curve: Curves.easeOutCubic,
      decoration: BoxDecoration(
        color: Colors.white,
        gradient: isSelected
            ? const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFFC11336),
                  Color(0xFFE63946),
                ],
              )
            : null,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white,
          width: 1.2,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 18,
              vertical: 16,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _AnswerLabel(label: label, isSelected: isSelected),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    '$text.',
                    style: TextStyle(
                      fontSize: 15.5,
                      fontWeight: FontWeight.w600,
                      letterSpacing: -0.2,
                      height: 1.45,
                      color:
                          isSelected ? Colors.white : const Color(0xFF171717),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _AnswerLabel extends StatelessWidget {
  const _AnswerLabel({
    required this.label,
    required this.isSelected,
  });

  final String label;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOutCubic,
      width: 34,
      height: 34,
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFFC11336) : const Color(0xFFFAFAFA),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Center(
        child: Text(
          label,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.3,
            color: isSelected ? Colors.white : const Color(0xFF4C4C4C),
          ),
        ),
      ),
    );
  }
}

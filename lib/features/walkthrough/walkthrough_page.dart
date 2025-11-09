import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../auth/signup_page.dart';

/// Modern onboarding page with professional design
/// Features: gradient overlays, glassmorphism cards, smooth transitions
class WalkthroughPage extends StatefulWidget {
  const WalkthroughPage({super.key});

  @override
  State<WalkthroughPage> createState() => _WalkthroughPageState();
}

class _WalkthroughPageState extends State<WalkthroughPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  final List<WalkthroughItem> _pages = [
    WalkthroughItem(
      title: 'Rotaları unut, hisleri keşfet',
      description:
          'Geleneksel seyahat uygulamalarının aksine, biz sana nereye gitmeliyim? değil, nasıl hissetmek istiyorum? sorularını soruyoruz.',
      emoji: '🧭',
      color: const Color(0xFFFCE4EC),
      imageUrl:
          'https://images.unsplash.com/photo-1528543606781-2f6e6857f318?ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&q=80&w=2400',
    ),
    WalkthroughItem(
      title: 'Duygularınla yolculuk et',
      description:
          'Heyecan mı, huzur mu, macera mı? Sadece hissini seç, gerisini bize bırak. Seni en çok etkileyecek deneyimleri buluyoruz.',
      emoji: '✨',
      color: const Color(0xFFFFF3E0),
      imageUrl:
          'https://images.unsplash.com/photo-1504598318550-17eba1008a68?ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&q=80&w=2400',
    ),
    WalkthroughItem(
      title: 'Anılarını paylaş, ilham ver',
      description:
          'Seyahatlerini sadece fotoğraflarla değil, duygularınla da paylaş. Topluluğumuza ilham ver, onlardan ilham al.',
      emoji: '💫',
      color: const Color(0xFFE8EAF6),
      imageUrl:
          'https://images.unsplash.com/photo-1517868163143-6eb6c78dbf54?ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&q=80&w=687',
    ),
  ];

  void _nextPage() {
    if (_currentPage == _pages.length - 1) {
      _goToAuth();
    } else {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOutCubic,
      );
    }
  }

  void _goToAuth() {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const SignUpPage(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
        transitionDuration: const Duration(milliseconds: 350),
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Colors.transparent,
        statusBarBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: Colors.black,
        body: PageView.builder(
          controller: _pageController,
          physics: const BouncingScrollPhysics(),
          onPageChanged: (index) {
            setState(() {
              _currentPage = index;
            });
          },
          itemCount: _pages.length,
          itemBuilder: (context, index) {
            return _OnboardingPage(
              item: _pages[index],
              currentPage: _currentPage,
              totalPages: _pages.length,
              onNext: _nextPage,
              onSkip: _goToAuth,
            );
          },
        ),
      ),
    );
  }
}

/// Individual onboarding page with modern design
class _OnboardingPage extends StatelessWidget {
  final WalkthroughItem item;
  final int currentPage;
  final int totalPages;
  final VoidCallback onNext;
  final VoidCallback onSkip;

  const _OnboardingPage({
    required this.item,
    required this.currentPage,
    required this.totalPages,
    required this.onNext,
    required this.onSkip,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final padding = MediaQuery.of(context).padding;
    final isWide = size.width >= 700;

    return Column(
      children: [
        // Upper section: Image (60%)
        Flexible(
          flex: 6,
          child: _buildImageSection(context, padding.top, isWide),
        ),
        // Lower section: White card (40%)
        Flexible(
          flex: 4,
          child: _buildInfoCard(context, padding.bottom, isWide),
        ),
      ],
    );
  }

  /// Upper image section with header overlay
  Widget _buildImageSection(
      BuildContext context, double topPadding, bool isWide) {
    return Container(
      color: Colors.black,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Hero image (full coverage, high quality)
          Image.network(
            item.imageUrl,
            fit: BoxFit.cover,
            alignment: Alignment.center,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return Container(
                color: item.color.withValues(alpha: 0.3),
                child: const Center(
                  child: CircularProgressIndicator(
                    valueColor:
                        AlwaysStoppedAnimation<Color>(Color(0xFFD7193F)),
                    strokeWidth: 3,
                  ),
                ),
              );
            },
            errorBuilder: (context, error, stackTrace) {
              return Container(
                color: item.color.withValues(alpha: 0.4),
                alignment: Alignment.center,
                child: Text(
                  item.emoji,
                  style: const TextStyle(fontSize: 96),
                ),
              );
            },
          ),
          // Gradient overlay for text readability
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.6),
                    Colors.transparent,
                  ],
                  stops: const [0.0, 0.5],
                ),
              ),
            ),
          ),
          // Top header (kivaGo + Skip)
          _buildTopBar(context, topPadding, isWide),
        ],
      ),
    );
  }

  /// Top bar with branding and skip button
  Widget _buildTopBar(BuildContext context, double topPadding, bool isWide) {
    return Positioned(
      top: topPadding + 16,
      left: isWide ? 32 : 20,
      right: isWide ? 32 : 20,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Brand name
          Text(
            'kivaGo',
            style: TextStyle(
              fontSize: isWide ? 28 : 24,
              fontWeight: FontWeight.w700,
              color: Colors.white,
              letterSpacing: 0.5,
              shadows: [
                Shadow(
                  color: Colors.black.withValues(alpha: 0.3),
                  offset: const Offset(0, 2),
                  blurRadius: 8,
                ),
              ],
            ),
          ),
          // Skip button
          TextButton(
            onPressed: onSkip,
            style: TextButton.styleFrom(
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            ),
            child: Text(
              'Geç',
              style: TextStyle(
                fontSize: isWide ? 16 : 15,
                fontWeight: FontWeight.w500,
                shadows: [
                  Shadow(
                    color: Colors.black.withValues(alpha: 0.3),
                    offset: const Offset(0, 1),
                    blurRadius: 4,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Bottom white card with content
  Widget _buildInfoCard(
      BuildContext context, double bottomPadding, bool isWide) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(isWide ? 36 : 32),
          topRight: Radius.circular(isWide ? 36 : 32),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SingleChildScrollView(
        padding: EdgeInsets.only(
          left: isWide ? 40 : 24,
          right: isWide ? 40 : 24,
          top: isWide ? 36 : 32,
          bottom: bottomPadding + 24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Title
            Text(
              item.title,
              textAlign: TextAlign.center,
              style: theme.textTheme.headlineMedium?.copyWith(
                fontSize: isWide ? 26 : 23,
                fontWeight: FontWeight.w800,
                color: const Color(0xFF1A1A1A),
                height: 1.25,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 16),
            // Description
            Text(
              item.description,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyLarge?.copyWith(
                fontSize: isWide ? 17 : 16,
                color: const Color(0xFF666666),
                height: 1.6,
              ),
            ),
            const SizedBox(height: 32),
            // Page indicators
            _buildPageIndicators(),
            const SizedBox(height: 24),
            // CTA Button
            _buildCTAButton(context, isWide),
          ],
        ),
      ),
    );
  }

  /// Page indicator dots
  Widget _buildPageIndicators() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        totalPages,
        (index) {
          final isActive = index == currentPage;
          return AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            width: isActive ? 32 : 8,
            height: 8,
            margin: const EdgeInsets.symmetric(horizontal: 4),
            decoration: BoxDecoration(
              color: isActive
                  ? const Color(0xFFD7193F)
                  : const Color(0xFFD7193F).withValues(alpha: 0.25),
              borderRadius: BorderRadius.circular(12),
            ),
          );
        },
      ),
    );
  }

  /// Call-to-action button
  Widget _buildCTAButton(BuildContext context, bool isWide) {
    final isLastPage = currentPage == totalPages - 1;

    return SizedBox(
      width: double.infinity,
      height: isWide ? 56 : 54,
      child: FilledButton(
        onPressed: onNext,
        style: FilledButton.styleFrom(
          backgroundColor: const Color(0xFFD7193F),
          foregroundColor: Colors.white,
          elevation: 2,
          shadowColor: const Color(0xFFD7193F).withValues(alpha: 0.4),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Text(
          isLastPage ? 'Başlayalım' : 'Devam Et',
          style: TextStyle(
            fontSize: isWide ? 17 : 16,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.3,
          ),
        ),
      ),
    );
  }
}

/// Data model for onboarding items
class WalkthroughItem {
  final String title;
  final String description;
  final String emoji;
  final Color color;
  final String imageUrl;

  const WalkthroughItem({
    required this.title,
    required this.description,
    required this.emoji,
    required this.color,
    required this.imageUrl,
  });
}

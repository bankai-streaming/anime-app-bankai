import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class MockupCarouselPage extends StatefulWidget {
  const MockupCarouselPage({super.key});

  @override
  State<MockupCarouselPage> createState() => _MockupCarouselPageState();
}

class _MockupCarouselPageState extends State<MockupCarouselPage> {
  static final Uri _playStoreUrl = Uri.parse(
    'https://play.google.com/store/apps/details?id=com.bankai.app&pcampaignid=web_share',
  );

  static const List<String> _mockups = [
    'mockups/S10_1_Airing_now.png',
    'mockups/S10_2_Sub__Dub.png',
    'mockups/S10_3_Downloads.png',
    'mockups/S10_4_Continue_watching.png',
    'mockups/S10_5_Schedule.png',
    'mockups/S10_6_Watchlist.png',
    'mockups/S10_7_Search.png',
    'mockups/S10_8_Episodes__cast.png',
  ];

  final PageController _pageController = PageController();
  int _currentIndex = 0;

  bool get _isLastPage => _currentIndex == _mockups.length - 1;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _openPlayStore() async {
    final launched = await launchUrl(
      _playStoreUrl,
      mode: LaunchMode.externalApplication,
    );
    if (!launched && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Could not open Google Play Store.'),
        ),
      );
    }
  }

  void _goToPage(int index) {
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0E0E10),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  PageView.builder(
                    controller: _pageController,
                    itemCount: _mockups.length,
                    onPageChanged: (index) {
                      setState(() => _currentIndex = index);
                    },
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        child: Center(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Image.asset(
                              _mockups[index],
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  if (_currentIndex > 0)
                    Positioned(
                      left: 12,
                      child: _NavArrowButton(
                        icon: Icons.chevron_left_rounded,
                        onPressed: () => _goToPage(_currentIndex - 1),
                      ),
                    ),
                  if (!_isLastPage)
                    Positioned(
                      right: 12,
                      child: _NavArrowButton(
                        icon: Icons.chevron_right_rounded,
                        onPressed: () => _goToPage(_currentIndex + 1),
                      ),
                    ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(_mockups.length, (index) {
                      final isActive = index == _currentIndex;
                      return GestureDetector(
                        onTap: () => _goToPage(index),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 220),
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          height: 8,
                          width: isActive ? 24 : 8,
                          decoration: BoxDecoration(
                            color: isActive
                                ? const Color(0xFFFF6B00)
                                : Colors.white24,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      );
                    }),
                  ),
                  if (_isLastPage) ...[
                    const SizedBox(height: 16),
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 360),
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: _openPlayStore,
                          icon: const Icon(Icons.play_arrow_rounded, size: 22),
                          label: const Text(
                            'Get it on Google Play',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFFF6B00),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 14,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                            elevation: 0,
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavArrowButton extends StatelessWidget {
  const _NavArrowButton({
    required this.icon,
    required this.onPressed,
  });

  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black54,
      shape: const CircleBorder(),
      child: IconButton(
        icon: Icon(icon, color: Colors.white),
        onPressed: onPressed,
      ),
    );
  }
}

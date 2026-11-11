
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:trip_planner/l10n/app_localizations.dart';
//import 'package:trip_planner/screens/home/home_screen.dart';
//import 'package:trip_planner/screens/language/language_selection_screen.dart';

import 'screens/auth/login_screen.dart';
import 'services/locale_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive
  await Hive.initFlutter();

  // Open settings box
  await Hive.openBox('settings');

  // Load the previously selected language
  await LocaleService.loadSavedLanguage();

  runApp(const TravelMindApp());
}

// ============================================================
// APP THEME + MULTILINGUAL CONFIGURATION
// ============================================================

class TravelMindApp extends StatelessWidget {
  const TravelMindApp({super.key});

  static const Color primary = Color(0xFF5146C8);
  static const Color darkBlue = Color(0xFF17165C);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Locale>(
      valueListenable: LocaleService.localeNotifier,
      builder: (context, currentLocale, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'TravelMind',

          // Currently selected app language
          locale: currentLocale,

          // Supported languages
          supportedLocales: AppLocalizations.supportedLocales,

          // Localization delegates
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],

          theme: ThemeData(
            useMaterial3: true,
            fontFamily: 'Roboto',
            colorScheme: ColorScheme.fromSeed(
              seedColor: primary,
            ),
            scaffoldBackgroundColor: const Color(0xFFF8F8FF),
          ),

          home: const SplashScreen(),
        );
      },
    );
  }
}

// ============================================================
// 1. SPLASH SCREEN
// ============================================================

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  Timer? _navigationTimer;

  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    );

    _scaleAnimation = Tween<double>(
      begin: 0.75,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.elasticOut,
      ),
    );

    _controller.forward();

    _navigationTimer = Timer(
      const Duration(seconds: 3),
      () {
        if (mounted) {
          openOnboarding();
        }
      },
    );
  }

  void openOnboarding() {
    if (!mounted) return;

    _navigationTimer?.cancel();

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => const OnboardingScreen(),
      ),
    );
  }

  @override
  void dispose() {
    _navigationTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFDDEAFF),
              Color(0xFFEDE5FF),
              Color(0xFFFDF2FF),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              top: 80,
              right: -60,
              child: _decorationCircle(170),
            ),

            Positioned(
              top: 250,
              left: -75,
              child: _decorationCircle(150),
            ),

            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              height: 290,
              child: CustomPaint(
                painter: MountainPainter(),
              ),
            ),

            SafeArea(
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: ScaleTransition(
                  scale: _scaleAnimation,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Spacer(),

                      Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            height: 180,
                            width: 180,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white.withValues(alpha: 0.45),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFF5146C8)
                                      .withValues(alpha: 0.12),
                                  blurRadius: 35,
                                ),
                              ],
                            ),
                          ),

                          const Icon(
                            Icons.landscape_rounded,
                            size: 115,
                            color: Color(0xFF355CB5),
                          ),

                          const Positioned(
                            top: 15,
                            right: 22,
                            child: Icon(
                              Icons.flight_rounded,
                              size: 45,
                              color: Color(0xFF17165C),
                            ),
                          ),

                          const Positioned(
                            top: 35,
                            left: 25,
                            child: Icon(
                              Icons.location_on_rounded,
                              size: 48,
                              color: Color(0xFFE64E65),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 22),

                      const Text(
                        'TravelMind',
                        style: TextStyle(
                          fontSize: 43,
                          fontWeight: FontWeight.w900,
                          letterSpacing: -1.5,
                          color: Color(0xFF17165C),
                        ),
                      ),

                      const SizedBox(height: 8),

                      const Text(
                        'Plan. Connect. Travel Safely.',
                        style: TextStyle(
                          fontSize: 16,
                          letterSpacing: 0.5,
                          color: Color(0xFF555B83),
                          fontWeight: FontWeight.w500,
                        ),
                      ),

                      const Spacer(),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 35),
                        child: SizedBox(
                          width: double.infinity,
                          height: 55,
                          child: ElevatedButton(
                            onPressed: openOnboarding,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF5146C8),
                              foregroundColor: Colors.white,
                              elevation: 8,
                              shadowColor: const Color(0xFF5146C8)
                                  .withValues(alpha: 0.35),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18),
                              ),
                            ),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Get Started',
                                  style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(width: 10),
                                Icon(Icons.arrow_forward_rounded),
                              ],
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _decorationCircle(double size) {
    return Container(
      height: size,
      width: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withValues(alpha: 0.22),
      ),
    );
  }
}

// ============================================================
// 2. MOUNTAIN BACKGROUND PAINTER
// ============================================================

class MountainPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final mountain1 = Paint()..color = const Color(0xFF9EBCEB);
    final mountain2 = Paint()..color = const Color(0xFF668ACB);
    final mountain3 = Paint()..color = const Color(0xFF344F9C);

    final path1 = Path()
      ..moveTo(0, size.height * 0.55)
      ..lineTo(size.width * 0.28, size.height * 0.05)
      ..lineTo(size.width * 0.56, size.height * 0.55)
      ..lineTo(size.width, size.height * 0.25)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    final path2 = Path()
      ..moveTo(0, size.height * 0.65)
      ..lineTo(size.width * 0.45, size.height * 0.22)
      ..lineTo(size.width * 0.75, size.height * 0.68)
      ..lineTo(size.width, size.height * 0.42)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    final path3 = Path()
      ..moveTo(0, size.height * 0.78)
      ..quadraticBezierTo(
        size.width * 0.5,
        size.height * 0.38,
        size.width,
        size.height * 0.78,
      )
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    canvas.drawPath(path1, mountain1);
    canvas.drawPath(path2, mountain2);
    canvas.drawPath(path3, mountain3);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

// ============================================================
// 3. ONBOARDING DATA
// ============================================================

class OnboardingData {
  final String title;
  final String description;
  final IconData icon;
  final String label;
  final Color color;

  const OnboardingData({
    required this.title,
    required this.description,
    required this.icon,
    required this.label,
    required this.color,
  });
}

// ============================================================
// 4. ONBOARDING SCREEN
// ============================================================

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();

  int currentPage = 0;

  final List<OnboardingData> pages = const [
    OnboardingData(
      title: 'Your Smart Travel Companion',
      description:
          'Plan amazing trips, discover beautiful destinations '
          'and explore the world with confidence.',
      icon: Icons.travel_explore_rounded,
      label: 'EXPLORE THE WORLD',
      color: Color(0xFF5479D8),
    ),
    OnboardingData(
      title: 'Find Your Travel Buddies',
      description:
          'Travel solo or connect with like-minded travellers '
          'who share your interests and destinations.',
      icon: Icons.groups_rounded,
      label: 'TRAVEL TOGETHER',
      color: Color(0xFF8060CF),
    ),
    OnboardingData(
      title: 'Travel Smart & Safely',
      description:
          'Get personalized itineraries, smart recommendations '
          'and useful travel information in one place.',
      icon: Icons.shield_rounded,
      label: 'TRAVEL WITH CONFIDENCE',
      color: Color(0xFF269C9B),
    ),
  ];

  void nextPage() {
    if (currentPage < pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 450),
        curve: Curves.easeInOut,
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const LoginScreen(),
        ),
      );
    }
  }

  void skipPages() {
    _pageController.animateToPage(
      pages.length - 1,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFF0F1FF),
              Color(0xFFF8F0FF),
              Color(0xFFFFFFFF),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 15,
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.explore_rounded,
                      color: Color(0xFF5146C8),
                      size: 29,
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'TravelMind',
                      style: TextStyle(
                        color: Color(0xFF17165C),
                        fontSize: 19,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    TextButton(
                      onPressed: skipPages,
                      child: const Text(
                        'Skip',
                        style: TextStyle(
                          color: Color(0xFF5146C8),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: pages.length,
                  onPageChanged: (index) {
                    setState(() {
                      currentPage = index;
                    });
                  },
                  itemBuilder: (context, index) {
                    return OnboardingPage(data: pages[index]);
                  },
                ),
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(pages.length, (index) {
                  final selected = currentPage == index;

                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    height: 8,
                    width: selected ? 28 : 8,
                    decoration: BoxDecoration(
                      color: selected
                          ? const Color(0xFF5146C8)
                          : const Color(0xFFD1CFF0),
                      borderRadius: BorderRadius.circular(20),
                    ),
                  );
                }),
              ),

              const SizedBox(height: 27),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: nextPage,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF5146C8),
                      foregroundColor: Colors.white,
                      elevation: 6,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(17),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          currentPage == pages.length - 1
                              ? 'Get Started'
                              : 'Next',
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 10),
                        const Icon(Icons.arrow_forward_rounded),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 22),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================
// 5. ONBOARDING PAGE DESIGN
// ============================================================

class OnboardingPage extends StatelessWidget {
  final OnboardingData data;

  const OnboardingPage({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Column(
        children: [
          const SizedBox(height: 15),

          Expanded(
            flex: 5,
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                gradient: LinearGradient(
                  colors: [
                    data.color.withValues(alpha: 0.15),
                    const Color(0xFFE9E7FF),
                    Colors.white,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                border: Border.all(
                  color: Colors.white,
                  width: 3,
                ),
                boxShadow: [
                  BoxShadow(
                    color: data.color.withValues(alpha: 0.12),
                    blurRadius: 25,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Positioned(
                    top: 25,
                    right: 20,
                    child: _circle(
                      75,
                      data.color.withValues(alpha: 0.12),
                    ),
                  ),

                  Positioned(
                    bottom: 30,
                    left: 15,
                    child: _circle(
                      95,
                      data.color.withValues(alpha: 0.10),
                    ),
                  ),

                  const Positioned(
                    top: 55,
                    left: 35,
                    child: Icon(
                      Icons.star_rounded,
                      size: 35,
                      color: Color(0xFFFFB94A),
                    ),
                  ),

                  Positioned(
                    right: 35,
                    bottom: 90,
                    child: Icon(
                      Icons.flight_rounded,
                      size: 35,
                      color: data.color,
                    ),
                  ),

                  Container(
                    height: 190,
                    width: 190,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withValues(alpha: 0.75),
                    ),
                    child: Icon(
                      data.icon,
                      size: 105,
                      color: data.color,
                    ),
                  ),

                  Positioned(
                    bottom: 25,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(25),
                        boxShadow: [
                          BoxShadow(
                            color: data.color.withValues(alpha: 0.12),
                            blurRadius: 10,
                          ),
                        ],
                      ),
                      child: Text(
                        data.label,
                        style: TextStyle(
                          color: data.color,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 35),

          Text(
            data.title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Color(0xFF17165C),
              fontSize: 27,
              fontWeight: FontWeight.w800,
              height: 1.25,
            ),
          ),

          const SizedBox(height: 15),

          Text(
            data.description,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Color(0xFF73738F),
              fontSize: 15,
              height: 1.7,
            ),
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _circle(double size, Color color) {
    return Container(
      height: size,
      width: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
      ),
    );
  }
}

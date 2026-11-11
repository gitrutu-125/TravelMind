
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../home/home_screen.dart';

class LanguageSelectionScreen extends StatefulWidget {
  const LanguageSelectionScreen({super.key});

  @override
  State<LanguageSelectionScreen> createState() =>
      _LanguageSelectionScreenState();
}

class _LanguageSelectionScreenState
    extends State<LanguageSelectionScreen> {

  static const Color primary = Color(0xFF5146C8);
  static const Color darkBlue = Color(0xFF17165C);

  final List<Map<String, String>> languages = [
    {'name': 'English', 'native': 'English', 'code': 'en'},
    {'name': 'Hindi', 'native': 'हिन्दी', 'code': 'hi'},
    {'name': 'Marathi', 'native': 'मराठी', 'code': 'mr'},
    {'name': 'Tamil', 'native': 'தமிழ்', 'code': 'ta'},
    {'name': 'Telugu', 'native': 'తెలుగు', 'code': 'te'},
    {'name': 'Gujarati', 'native': 'ગુજરાતી', 'code': 'gu'},
  ];

  String selectedLanguage = 'en';

  @override
  void initState() {
    super.initState();

    final box = Hive.box('settings');

    selectedLanguage =
        box.get('languageCode', defaultValue: 'en');
  }

  // ==========================================================
  // SAVE LANGUAGE AND NAVIGATE TO HOME SCREEN
  // ==========================================================

  void continueWithLanguage() {
    final box = Hive.box('settings');

    // Save selected language in Hive.
    box.put('languageCode', selectedLanguage);

    // Navigate to HomeScreen.
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const HomeScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8FF),
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFE9EDFF),
              Color(0xFFF8F0FF),
              Colors.white,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 25,
              ),
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: 450,
                ),
                child: Column(
                  children: [
                    Container(
                      height: 85,
                      width: 85,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: primary.withValues(alpha: 0.12),
                            blurRadius: 20,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.language_rounded,
                        size: 48,
                        color: primary,
                      ),
                    ),

                    const SizedBox(height: 22),

                    const Text(
                      'Choose Your Language',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 27,
                        fontWeight: FontWeight.w900,
                        color: darkBlue,
                      ),
                    ),

                    const SizedBox(height: 10),

                    const Text(
                      'Select your preferred language '
                      'for a personalized travel experience.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black54,
                        height: 1.6,
                      ),
                    ),

                    const SizedBox(height: 32),

                    // LANGUAGE OPTIONS

                    ...languages.map((language) {
                      final isSelected =
                          selectedLanguage == language['code'];

                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedLanguage =
                                language['code']!;
                          });
                        },
                        child: AnimatedContainer(
                          duration:
                              const Duration(milliseconds: 200),
                          margin: const EdgeInsets.only(bottom: 13),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 18,
                            vertical: 17,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? const Color(0xFFEDEAFF)
                                : Colors.white,
                            borderRadius:
                                BorderRadius.circular(17),
                            border: Border.all(
                              color: isSelected
                                  ? primary
                                  : const Color(0xFFE5E3F5),
                              width: isSelected ? 2 : 1,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: primary.withValues(
                                  alpha: isSelected ? 0.08 : 0.03,
                                ),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      language['native']!,
                                      style: const TextStyle(
                                        fontSize: 19,
                                        fontWeight: FontWeight.bold,
                                        color: darkBlue,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      language['name']!,
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Colors.black54,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              Icon(
                                isSelected
                                    ? Icons.check_circle_rounded
                                    : Icons.circle_outlined,
                                color: isSelected
                                    ? primary
                                    : Colors.grey.shade400,
                                size: 24,
                              ),
                            ],
                          ),
                        ),
                      );
                    }),

                    const SizedBox(height: 20),

                    // CONTINUE BUTTON

                    SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: ElevatedButton(
                        onPressed: continueWithLanguage,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primary,
                          foregroundColor: Colors.white,
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(16),
                          ),
                        ),
                        child: const Row(
                          mainAxisAlignment:
                              MainAxisAlignment.center,
                          children: [
                            Text(
                              'Continue',
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

                    const SizedBox(height: 20),

                    const Text(
                      'You can change your language later '
                      'in settings.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.black45,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

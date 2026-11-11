
import 'package:flutter/material.dart';

import '../../services/auth_service.dart';
import '../../services/google_auth_service.dart';
import '../language/language_selection_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Theme colors
  static const Color primary = Color(0xFF5146C8);
  static const Color darkBlue = Color(0xFF17165C);

  // Authentication services
  final AuthService authService = AuthService();
  final GoogleAuthService googleAuthService = GoogleAuthService();

  // Form key
  final _formKey = GlobalKey<FormState>();

  // Text controllers
  final TextEditingController _nameController =
      TextEditingController();

  final TextEditingController _emailController =
      TextEditingController();

  final TextEditingController _passwordController =
      TextEditingController();

  final TextEditingController _confirmPasswordController =
      TextEditingController();

  // Screen states
  bool isLogin = true;
  bool isPasswordVisible = false;
  bool isConfirmPasswordVisible = false;
  bool isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  // Navigate after successful authentication
  void navigateAfterLogin() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const LanguageSelectionScreen(),
      ),
    );
  }

  // Switch between Login and Signup
  void toggleAuthMode() {
    setState(() {
      isLogin = !isLogin;

      _formKey.currentState?.reset();

      _nameController.clear();
      _emailController.clear();
      _passwordController.clear();
      _confirmPasswordController.clear();

      isPasswordVisible = false;
      isConfirmPasswordVisible = false;
    });
  }

  // Email validation
  String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your email address';
    }

    final emailPattern =
        RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

    if (!emailPattern.hasMatch(value.trim())) {
      return 'Please enter a valid email address';
    }

    return null;
  }

  // Password validation
  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    }

    if (value.length < 8) {
      return 'Password must contain at least 8 characters';
    }

    return null;
  }

  // LOGIN AND SIGNUP SUBMISSION
  Future<void> submitForm() async {
    if (isLoading) return;

    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      if (isLogin) {
        // =====================================
        // EMAIL / PASSWORD LOGIN
        // =====================================

        await authService.login(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        );

        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Login successful! Welcome to TravelMind.'),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
          ),
        );

        navigateAfterLogin();
      } else {
        // =====================================
        // EMAIL / PASSWORD SIGNUP
        // =====================================

        await authService.register(
          name: _nameController.text.trim(),
          email: _emailController.text.trim(),
          password: _passwordController.text,
        );

        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Account created successfully! Please login.',
            ),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
          ),
        );

        // Switch back to Login after registration.
        setState(() {
          isLogin = true;

          _formKey.currentState?.reset();

          _nameController.clear();
          _passwordController.clear();
          _confirmPasswordController.clear();

          isPasswordVisible = false;
          isConfirmPasswordVisible = false;
        });
      }
    } catch (error) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            error.toString().replaceFirst('Exception: ', ''),
          ),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  // GOOGLE SIGN-IN
  Future<void> googleSignIn() async {
    if (isLoading) return;

    setState(() {
      isLoading = true;
    });

    try {
      // Step 1: Get Google ID token.
      final String? idToken =
          await googleAuthService.signInAndGetIdToken();

      if (idToken == null || idToken.isEmpty) {
        throw Exception('Google ID token was not received.');
      }

      // Step 2: Send Google ID token to FastAPI.
      // Backend verifies the token and returns TravelMind JWT.
      await authService.googleLogin(idToken);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Google login successful!'),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
        ),
      );

      navigateAfterLogin();
    } catch (error) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Google Sign-In failed: ${error.toString().replaceFirst('Exception: ', '')}',
          ),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  // FORGOT PASSWORD
  void showForgotPasswordDialog() {
    final TextEditingController emailController =
        TextEditingController(text: _emailController.text);

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
          ),
          title: const Text(
            'Forgot Password?',
            style: TextStyle(
              color: darkBlue,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Enter your registered email address to reset your password.',
              ),
              const SizedBox(height: 18),
              TextField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  hintText: 'Enter your email',
                  prefixIcon: const Icon(Icons.email_outlined),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
                emailController.dispose();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: primary,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                final email = emailController.text.trim();

                if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$')
                    .hasMatch(email)) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Enter a valid email address'),
                    ),
                  );
                  return;
                }

                Navigator.pop(dialogContext);
                emailController.dispose();

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Password reset will be available in a future update.',
                    ),
                  ),
                );
              },
              child: const Text('Continue'),
            ),
          ],
        );
      },
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
                horizontal: 25,
                vertical: 20,
              ),
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: 450,
                ),
                child: Column(
                  children: [
                    // LOGO
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
                        Icons.travel_explore_rounded,
                        size: 52,
                        color: primary,
                      ),
                    ),

                    const SizedBox(height: 17),

                    const Text(
                      'TravelMind',
                      style: TextStyle(
                        fontSize: 31,
                        fontWeight: FontWeight.w900,
                        color: darkBlue,
                      ),
                    ),

                    const SizedBox(height: 7),

                    Text(
                      isLogin
                          ? 'Welcome back, explorer!'
                          : 'Start your next adventure with us!',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 15,
                        color: Colors.black54,
                      ),
                    ),

                    const SizedBox(height: 28),

                    // AUTHENTICATION CARD
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(23),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(25),
                        boxShadow: [
                          BoxShadow(
                            color: primary.withValues(alpha: 0.08),
                            blurRadius: 25,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // TITLE
                            Text(
                              isLogin ? 'Login' : 'Create Account',
                              style: const TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                                color: darkBlue,
                              ),
                            ),

                            const SizedBox(height: 7),

                            Text(
                              isLogin
                                  ? 'Enter your details to continue.'
                                  : 'Fill in your details to join TravelMind.',
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 13,
                              ),
                            ),

                            const SizedBox(height: 25),

                            // FULL NAME - SIGNUP ONLY
                            if (!isLogin) ...[
                              _buildLabel('Full Name'),
                              const SizedBox(height: 8),

                              TextFormField(
                                controller: _nameController,
                                keyboardType: TextInputType.name,
                                textCapitalization:
                                    TextCapitalization.words,
                                decoration: _inputDecoration(
                                  hint: 'Enter your full name',
                                  icon: Icons.person_outline_rounded,
                                ),
                                validator: (value) {
                                  if (value == null ||
                                      value.trim().isEmpty) {
                                    return 'Please enter your name';
                                  }

                                  if (value.trim().length < 2) {
                                    return 'Name is too short';
                                  }

                                  return null;
                                },
                              ),

                              const SizedBox(height: 18),
                            ],

                            // EMAIL
                            _buildLabel('Email Address'),
                            const SizedBox(height: 8),

                            TextFormField(
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
                              decoration: _inputDecoration(
                                hint: 'Enter your email',
                                icon: Icons.email_outlined,
                              ),
                              validator: validateEmail,
                            ),

                            const SizedBox(height: 18),

                            // PASSWORD
                            _buildLabel('Password'),
                            const SizedBox(height: 8),

                            TextFormField(
                              controller: _passwordController,
                              obscureText: !isPasswordVisible,
                              decoration: _inputDecoration(
                                hint: 'Enter your password',
                                icon: Icons.lock_outline_rounded,
                                suffix: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      isPasswordVisible =
                                          !isPasswordVisible;
                                    });
                                  },
                                  icon: Icon(
                                    isPasswordVisible
                                        ? Icons.visibility_off_outlined
                                        : Icons.visibility_outlined,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                              validator: validatePassword,
                            ),

                            // FORGOT PASSWORD
                            if (isLogin) ...[
                              Align(
                                alignment: Alignment.centerRight,
                                child: TextButton(
                                  onPressed: isLoading
                                      ? null
                                      : showForgotPasswordDialog,
                                  child: const Text(
                                    'Forgot Password?',
                                    style: TextStyle(
                                      color: primary,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            ] else ...[
                              const SizedBox(height: 18),

                              // CONFIRM PASSWORD
                              _buildLabel('Confirm Password'),
                              const SizedBox(height: 8),

                              TextFormField(
                                controller: _confirmPasswordController,
                                obscureText:
                                    !isConfirmPasswordVisible,
                                decoration: _inputDecoration(
                                  hint: 'Confirm your password',
                                  icon: Icons.lock_outline_rounded,
                                  suffix: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        isConfirmPasswordVisible =
                                            !isConfirmPasswordVisible;
                                      });
                                    },
                                    icon: Icon(
                                      isConfirmPasswordVisible
                                          ? Icons.visibility_off_outlined
                                          : Icons.visibility_outlined,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please confirm your password';
                                  }

                                  if (value != _passwordController.text) {
                                    return 'Passwords do not match';
                                  }

                                  return null;
                                },
                              ),
                            ],

                            const SizedBox(height: 15),

                            // MAIN LOGIN / SIGNUP BUTTON
                            SizedBox(
                              width: double.infinity,
                              height: 54,
                              child: ElevatedButton(
                                onPressed:
                                    isLoading ? null : submitForm,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: primary,
                                  foregroundColor: Colors.white,
                                  elevation: 4,
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.circular(15),
                                  ),
                                ),
                                child: isLoading
                                    ? const SizedBox(
                                        height: 23,
                                        width: 23,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2.5,
                                          color: Colors.white,
                                        ),
                                      )
                                    : Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            isLogin
                                                ? 'Login'
                                                : 'Create Account',
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(width: 10),
                                          const Icon(
                                            Icons.arrow_forward_rounded,
                                          ),
                                        ],
                                      ),
                              ),
                            ),

                            const SizedBox(height: 22),

                            // DIVIDER
                            Row(
                              children: [
                                const Expanded(
                                  child: Divider(
                                    color: Color(0xFFE0E0E0),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                  ),
                                  child: Text(
                                    'OR CONTINUE WITH',
                                    style: TextStyle(
                                      color: Colors.grey.shade600,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 1,
                                    ),
                                  ),
                                ),
                                const Expanded(
                                  child: Divider(
                                    color: Color(0xFFE0E0E0),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 20),

                            // GOOGLE SIGN-IN BUTTON
                            SizedBox(
                              width: double.infinity,
                              height: 52,
                              child: OutlinedButton(
                                onPressed:
                                    isLoading ? null : googleSignIn,
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: darkBlue,
                                  side: const BorderSide(
                                    color: Color(0xFFE0E0E0),
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.circular(14),
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.center,
                                  children: [
                                    const Text(
                                      'G',
                                      style: TextStyle(
                                        fontSize: 23,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF4285F4),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Text(
                                      isLogin
                                          ? 'Continue with Google'
                                          : 'Sign up with Google',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            const SizedBox(height: 22),

                            // LOGIN / SIGNUP SWITCH
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Flexible(
                                  child: Text(
                                    isLogin
                                        ? "Don't have an account? "
                                        : 'Already have an account? ',
                                    style: const TextStyle(
                                      color: Colors.black54,
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap:
                                      isLoading ? null : toggleAuthMode,
                                  child: Text(
                                    isLogin ? 'Sign Up' : 'Login',
                                    style: const TextStyle(
                                      color: primary,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 25),

                    const Text(
                      'Plan. Connect. Travel Safely.',
                      style: TextStyle(
                        color: Colors.black45,
                        fontSize: 12,
                        letterSpacing: 0.5,
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

  // FIELD LABEL
  Widget _buildLabel(String label) {
    return Text(
      label,
      style: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: darkBlue,
      ),
    );
  }

  // COMMON INPUT DECORATION
  InputDecoration _inputDecoration({
    required String hint,
    required IconData icon,
    Widget? suffix,
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(
        color: Colors.black38,
        fontSize: 13,
      ),
      prefixIcon: Icon(
        icon,
        color: primary,
        size: 21,
      ),
      suffixIcon: suffix,
      filled: true,
      fillColor: const Color(0xFFF8F8FF),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 15,
        vertical: 16,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(13),
        borderSide: const BorderSide(
          color: Color(0xFFE5E3F5),
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(13),
        borderSide: const BorderSide(
          color: Color(0xFFE5E3F5),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(13),
        borderSide: const BorderSide(
          color: primary,
          width: 1.5,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(13),
        borderSide: const BorderSide(
          color: Colors.redAccent,
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(13),
        borderSide: const BorderSide(
          color: Colors.redAccent,
          width: 1.5,
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../widgets/gradient_button.dart';
import '../../services/auth_service.dart';
import '../home/home_screen.dart';
import 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final AuthService authService = AuthService();

  bool hidePassword = true;
  bool hideConfirmPassword = true;
  bool isLoading = false;

  Future<void> createAccount() async {
    if (isLoading) return;

    final name = nameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text;
    final confirmPassword = confirmPasswordController.text;

    if (name.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty) {
      showMessage('Please fill in all fields');
      return;
    }

    if (!email.contains('@') || !email.contains('.')) {
      showMessage('Please enter a valid email address');
      return;
    }

    if (password.length < 6) {
      showMessage('Password must be at least 6 characters');
      return;
    }

    if (password != confirmPassword) {
      showMessage('Passwords do not match');
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final user = await authService.register(email: email, password: password);

      await user?.updateDisplayName(name);

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    } catch (e) {
      if (!mounted) return;
      showMessage(e.toString());
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  void showMessage(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : AppColors.darkPurple;
    final subtitleColor = isDark ? Colors.white70 : AppColors.textGrey;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: textColor),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 26),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  Center(
                    child: Image.asset(
                      'assets/images/logo.png',
                      height: 105,
                      width: 105,
                      fit: BoxFit.contain,
                    ),
                  ),
                  const SizedBox(height: 15),
                  Center(
                    child: Text(
                      'Create Account',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Center(
                    child: Text(
                      'Join ScamShield Pay and shop safely!',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 14, color: subtitleColor),
                    ),
                  ),
                  const SizedBox(height: 28),
                  _fieldLabel('Full Name', textColor),
                  const SizedBox(height: 8),
                  TextField(
                    controller: nameController,
                    textCapitalization: TextCapitalization.words,
                    decoration: const InputDecoration(
                      hintText: 'Enter your full name',
                      prefixIcon: Icon(
                        Icons.person_outline,
                        color: AppColors.softPurple,
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  _fieldLabel('Email Address', textColor),
                  const SizedBox(height: 8),
                  TextField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      hintText: 'Enter your email',
                      prefixIcon: Icon(
                        Icons.email_outlined,
                        color: AppColors.softPurple,
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  _fieldLabel('Password', textColor),
                  const SizedBox(height: 8),
                  TextField(
                    controller: passwordController,
                    obscureText: hidePassword,
                    decoration: InputDecoration(
                      hintText: 'Create a password',
                      prefixIcon: const Icon(
                        Icons.lock_outline,
                        color: AppColors.softPurple,
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          hidePassword
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          color: subtitleColor,
                        ),
                        onPressed: () {
                          setState(() {
                            hidePassword = !hidePassword;
                          });
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  _fieldLabel('Confirm Password', textColor),
                  const SizedBox(height: 8),
                  TextField(
                    controller: confirmPasswordController,
                    obscureText: hideConfirmPassword,
                    decoration: InputDecoration(
                      hintText: 'Re-enter your password',
                      prefixIcon: const Icon(
                        Icons.lock_outline,
                        color: AppColors.softPurple,
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          hideConfirmPassword
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          color: subtitleColor,
                        ),
                        onPressed: () {
                          setState(() {
                            hideConfirmPassword = !hideConfirmPassword;
                          });
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 28),
                  GradientButton(
                    text: isLoading ? 'Creating Account...' : 'Create Account',
                    onPressed: createAccount,
                    icon: Icons.arrow_forward,
                  ),
                  const SizedBox(height: 22),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Already have an account? ',
                        style: TextStyle(color: subtitleColor),
                      ),
                      GestureDetector(
                        onTap: () {
                          if (isLoading) return;

                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const LoginScreen(),
                            ),
                          );
                        },
                        child: const Text(
                          'Log In',
                          style: TextStyle(
                            color: AppColors.softPurple,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 25),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _fieldLabel(String text, Color color) {
    return Text(
      text,
      style: TextStyle(fontWeight: FontWeight.w600, color: color),
    );
  }
}

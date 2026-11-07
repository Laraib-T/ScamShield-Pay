import 'package:flutter/material.dart';

void main() {
  runApp(const ScamShieldApp());
}

const purple = Color(0xFF713A82);
const darkPurple = Color(0xFF452052);
const lavender = Color(0xFFEAD8F3);
const background = Color(0xFFFFF5FC);

class ScamShieldApp extends StatelessWidget {
  const ScamShieldApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: background,
        colorScheme: ColorScheme.fromSeed(seedColor: purple),
        useMaterial3: true,
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 18, vertical: 17),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: lavender),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: lavender),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: purple, width: 1.5),
          ),
        ),
      ),
      home: const WelcomeScreen(),
    );
  }
}

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [background, Color(0xFFF0E0F7), Color(0xFFFFEAF5)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(28),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 110,
                    width: 110,
                    decoration: BoxDecoration(
                      color: purple,
                      borderRadius: BorderRadius.circular(32),
                      boxShadow: [
                        BoxShadow(
                          color: purple.withOpacity(.22),
                          blurRadius: 25,
                          offset: const Offset(0, 12),
                        )
                      ],
                    ),
                    child: const Icon(Icons.shield_rounded,
                        color: Colors.white, size: 65),
                  ),
                  const SizedBox(height: 28),
                  const Text("ScamShield Pay",
                    style: TextStyle(fontSize: 30,
                      fontWeight: FontWeight.bold, color: darkPurple)),
                  const SizedBox(height: 12),
                  const Text("Let AI check before you pay.",
                    style: TextStyle(fontSize: 16, color: purple)),
                  const SizedBox(height: 55),
                  authButton("Create Account", () {
                    Navigator.push(context, MaterialPageRoute(
                      builder: (_) => const RegisterScreen()));
                  }),
                  const SizedBox(height: 15),
                  OutlinedButton(
                    onPressed: () => Navigator.push(context,
                      MaterialPageRoute(builder: (_) => const LoginScreen())),
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 56),
                      foregroundColor: purple,
                      side: const BorderSide(color: purple),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                    ),
                    child: const Text("Log In",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

Widget authButton(String text, VoidCallback onTap) {
  return Container(
    width: double.infinity,
    height: 56,
    decoration: BoxDecoration(
      gradient: const LinearGradient(
        colors: [purple, darkPurple]),
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(color: purple.withOpacity(.2),
          blurRadius: 12, offset: const Offset(0, 6))
      ],
    ),
    child: ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16)),
      ),
      child: Text(text, style: const TextStyle(
        color: Colors.white, fontSize: 16,
        fontWeight: FontWeight.bold)),
    ),
  );
}

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final formKey = GlobalKey<FormState>();
  final name = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();
  bool hidePassword = true;

  @override
  void dispose() {
    name.dispose();
    email.dispose();
    password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: background, elevation: 0),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 12),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.shield_rounded,
                  color: purple, size: 48),
                const SizedBox(height: 20),
                const Text("Create Account",
                  style: TextStyle(fontSize: 29,
                    fontWeight: FontWeight.bold, color: darkPurple)),
                const SizedBox(height: 8),
                const Text("Join ScamShield Pay and shop safely.",
                  style: TextStyle(color: Colors.black54, fontSize: 15)),
                const SizedBox(height: 32),
                const Text("Full Name"),
                const SizedBox(height: 8),
                TextFormField(
                  controller: name,
                  decoration: const InputDecoration(
                    hintText: "Enter your full name",
                    prefixIcon: Icon(Icons.person_outline)),
                  validator: (v) =>
                    v == null || v.trim().isEmpty ? "Enter your name" : null,
                ),
                const SizedBox(height: 20),
                const Text("Email Address"),
                const SizedBox(height: 8),
                TextFormField(
                  controller: email,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    hintText: "Enter your email",
                    prefixIcon: Icon(Icons.email_outlined)),
                  validator: (v) =>
                    v == null || !v.contains('@') || !v.contains('.')
                    ? "Enter a valid email" : null,
                ),
                const SizedBox(height: 20),
                const Text("Password"),
                const SizedBox(height: 8),
                TextFormField(
                  controller: password,
                  obscureText: hidePassword,
                  decoration: InputDecoration(
                    hintText: "Create a password",
                    prefixIcon: const Icon(Icons.lock_outline),
                    suffixIcon: IconButton(
                      icon: Icon(hidePassword
                        ? Icons.visibility_off : Icons.visibility),
                      onPressed: () => setState(
                        () => hidePassword = !hidePassword),
                    ),
                  ),
                  validator: (v) =>
                    v == null || v.length < 8
                    ? "Password must be at least 8 characters" : null,
                ),
                const SizedBox(height: 30),
                authButton("Create Account", () {
                  if (formKey.currentState!.validate()) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text(
                        "Form validated. Connect authentication API next.")));
                  }
                }),
                const SizedBox(height: 22),
                Center(child: TextButton(
                  onPressed: () => Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (_) => const LoginScreen())),
                  child: const Text("Already have an account? Log In",
                    style: TextStyle(color: purple)),
                )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final formKey = GlobalKey<FormState>();
  final email = TextEditingController();
  final password = TextEditingController();
  bool hidePassword = true;

  @override
  void dispose() {
    email.dispose();
    password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: background, elevation: 0),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(25),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.shield_rounded,
                  color: purple, size: 48),
                const SizedBox(height: 22),
                const Text("Welcome Back!",
                  style: TextStyle(fontSize: 29,
                    fontWeight: FontWeight.bold, color: darkPurple)),
                const SizedBox(height: 8),
                const Text("Log in to continue shopping safely.",
                  style: TextStyle(color: Colors.black54)),
                const SizedBox(height: 35),
                const Text("Email Address"),
                const SizedBox(height: 8),
                TextFormField(
                  controller: email,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    hintText: "Enter your email",
                    prefixIcon: Icon(Icons.email_outlined)),
                  validator: (v) =>
                    v == null || !v.contains('@')
                    ? "Enter a valid email" : null,
                ),
                const SizedBox(height: 22),
                const Text("Password"),
                const SizedBox(height: 8),
                TextFormField(
                  controller: password,
                  obscureText: hidePassword,
                  decoration: InputDecoration(
                    hintText: "Enter your password",
                    prefixIcon: const Icon(Icons.lock_outline),
                    suffixIcon: IconButton(
                      icon: Icon(hidePassword
                        ? Icons.visibility_off : Icons.visibility),
                      onPressed: () => setState(
                        () => hidePassword = !hidePassword),
                    ),
                  ),
                  validator: (v) =>
                    v == null || v.isEmpty ? "Enter your password" : null,
                ),
                const SizedBox(height: 30),
                authButton("Log In", () {
                  if (formKey.currentState!.validate()) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text(
                        "Form validated. Connect authentication API next.")));
                  }
                }),
                const SizedBox(height: 20),
                Center(child: TextButton(
                  onPressed: () => Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const RegisterScreen())),
                  child: const Text("Don't have an account? Register",
                    style: TextStyle(color: purple)),
                )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
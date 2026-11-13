import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SecurityScreen extends StatefulWidget {
  const SecurityScreen({super.key});

  @override
  State<SecurityScreen> createState() => _SecurityScreenState();
}

class _SecurityScreenState extends State<SecurityScreen> {
  final TextEditingController currentCtrl = TextEditingController();
  final TextEditingController newCtrl = TextEditingController();
  final TextEditingController confirmCtrl = TextEditingController();

  bool hide = true;
  bool busy = false;

  User? get user => FirebaseAuth.instance.currentUser;
  bool get verified => user?.emailVerified ?? false;
  bool get usesPassword =>
      user?.providerData.any((p) => p.providerId == 'password') ?? false;

  @override
  void dispose() {
    currentCtrl.dispose();
    newCtrl.dispose();
    confirmCtrl.dispose();
    super.dispose();
  }

  void toast(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
    );
  }

  int strengthOf(String p) {
    int s = 0;
    if (p.length >= 8) s++;
    if (RegExp(r'[a-z]').hasMatch(p)) s++;
    if (RegExp(r'[A-Z]').hasMatch(p)) s++;
    if (RegExp(r'[0-9]').hasMatch(p)) s++;
    if (RegExp(r'[^A-Za-z0-9]').hasMatch(p)) s++;
    return s;
  }

  Future<void> sendVerification() async {
    try {
      await user?.sendEmailVerification();
      toast('Verification link sent. Check your inbox (and spam).');
    } on FirebaseAuthException catch (e) {
      toast(e.message ?? 'Could not send the verification email.');
    }
  }

  Future<void> refreshVerification() async {
    try {
      await FirebaseAuth.instance.currentUser?.reload();
      if (mounted) setState(() {});
      toast(verified ? 'Email verified.' : 'Still not verified. Open the link in your email first.');
    } on FirebaseAuthException catch (e) {
      toast(e.message ?? 'Could not refresh.');
    }
  }

  Future<void> sendReset() async {
    final email = user?.email;
    if (email == null) return;
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      toast('Password reset link sent to $email');
    } on FirebaseAuthException catch (e) {
      toast(e.message ?? 'Could not send the reset email.');
    }
  }

  Future<void> changePassword() async {
    final u = user;
    if (u == null || u.email == null) {
      toast('You are not signed in.');
      return;
    }
    if (currentCtrl.text.isEmpty) {
      toast('Enter your current password.');
      return;
    }
    if (newCtrl.text != confirmCtrl.text) {
      toast('New passwords do not match.');
      return;
    }
    if (strengthOf(newCtrl.text) < 3 || newCtrl.text.length < 8) {
      toast('Choose a stronger password (8+ characters, mix of letters and numbers).');
      return;
    }

    setState(() => busy = true);

    try {
      final cred = EmailAuthProvider.credential(
        email: u.email!,
        password: currentCtrl.text,
      );
      await u.reauthenticateWithCredential(cred);
      await u.updatePassword(newCtrl.text);

      currentCtrl.clear();
      newCtrl.clear();
      confirmCtrl.clear();
      toast('Password changed successfully.');
    } on FirebaseAuthException catch (e) {
      if (e.code == 'wrong-password' || e.code == 'invalid-credential') {
        toast('Current password is incorrect.');
      } else if (e.code == 'weak-password') {
        toast('That password is too weak.');
      } else {
        toast(e.message ?? 'Could not change the password.');
      }
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }

  Widget section(String title, List<Widget> children) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget emailSection() {
    return section('Email', [
      Row(
        children: [
          Expanded(child: Text(user?.email ?? 'No email on this account')),
          Chip(
            avatar: Icon(
              verified ? Icons.verified_rounded : Icons.error_outline_rounded,
              size: 18,
              color: verified ? Colors.green : Colors.orange,
            ),
            label: Text(verified ? 'Verified' : 'Not verified'),
          ),
        ],
      ),
      const SizedBox(height: 8),
      const Text(
        'Verification proves this email belongs to you. It does not check anything else about you.',
        style: TextStyle(fontSize: 12),
      ),
      if (!verified) ...[
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          children: [
            FilledButton(onPressed: sendVerification, child: const Text('Send verification link')),
            OutlinedButton(onPressed: refreshVerification, child: const Text('I verified, refresh')),
          ],
        ),
      ],
    ]);
  }

  Widget passwordSection() {
    if (!usesPassword) {
      return section('Password', [
        const Text('This account signs in without a password, so there is nothing to change here.'),
      ]);
    }

    final strength = strengthOf(newCtrl.text);
    const labels = ['Very weak', 'Weak', 'Fair', 'Good', 'Strong', 'Very strong'];
    final colors = [Colors.red, Colors.red, Colors.orange, Colors.amber, Colors.green, Colors.green];

    return section('Password', [
      TextField(
        controller: currentCtrl,
        obscureText: hide,
        decoration: const InputDecoration(labelText: 'Current password', border: OutlineInputBorder()),
      ),
      const SizedBox(height: 10),
      TextField(
        controller: newCtrl,
        obscureText: hide,
        onChanged: (_) => setState(() {}),
        decoration: InputDecoration(
          labelText: 'New password',
          border: const OutlineInputBorder(),
          suffixIcon: IconButton(
            icon: Icon(hide ? Icons.visibility_off_rounded : Icons.visibility_rounded),
            onPressed: () => setState(() => hide = !hide),
          ),
        ),
      ),
      if (newCtrl.text.isNotEmpty) ...[
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: strength / 5,
          minHeight: 6,
          color: colors[strength],
          backgroundColor: colors[strength].withValues(alpha: 0.15),
        ),
        const SizedBox(height: 4),
        Text(labels[strength], style: TextStyle(fontSize: 12, color: colors[strength])),
      ],
      const SizedBox(height: 10),
      TextField(
        controller: confirmCtrl,
        obscureText: hide,
        decoration: const InputDecoration(labelText: 'Confirm new password', border: OutlineInputBorder()),
      ),
      const SizedBox(height: 14),
      SizedBox(
        width: double.infinity,
        child: FilledButton(
          onPressed: busy ? null : changePassword,
          child: busy
              ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2.5))
              : const Text('Change password'),
        ),
      ),
      TextButton(onPressed: sendReset, child: const Text('Forgot it? Email me a reset link')),
      const Text(
        'Never share your password. ScamShield will never ask for it by message or email.',
        style: TextStyle(fontSize: 12),
      ),
    ]);
  }

  Widget privacySection() {
    return section('Privacy', const [
      Text(
        'What we send: the listing text and any screenshot you add are sent to an AI service '
        '(Google Gemini) to produce the safety report.',
      ),
      SizedBox(height: 8),
      Text(
        'Seller comparisons: website links you enter are checked for public information '
        '(domain age and certificate) and compared with a brand registry.',
      ),
      SizedBox(height: 8),
      Text(
        'Results are an AI estimate, not a guarantee. Always verify a seller before paying.',
      ),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Security & Privacy'), centerTitle: true),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          emailSection(),
          passwordSection(),
          privacySection(),
        ],
      ),
    );
  }
}
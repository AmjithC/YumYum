import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../theme.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _isLogin = true;
  bool _busy = false;
  bool _hidePassword = true;

  Future<void> _submit() async {
    final email = _email.text.trim();
    final password = _password.text;
    if (email.isEmpty || !email.contains('@') || password.length < 6) {
      _showMessage('Enter a valid email and a password of 6+ characters');
      return;
    }

    setState(() => _busy = true);
    try {
      final auth = FirebaseAuth.instance;
      if (_isLogin) {
        await auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
      } else {
        await auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
      }
    } on FirebaseAuthException catch (error) {
      _showMessage(error.message ?? 'Authentication failed');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _resetPassword() async {
    final email = _email.text.trim();
    if (email.isEmpty) {
      _showMessage('Enter your email first');
      return;
    }
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      _showMessage('Password reset email sent');
    } on FirebaseAuthException catch (error) {
      _showMessage(error.message ?? 'Could not send reset email');
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(26, 22, 26, 70),
              decoration: const BoxDecoration(
                color: AppColors.yellow,
                borderRadius:
                    BorderRadius.vertical(bottom: Radius.circular(34)),
              ),
              child: SafeArea(
                bottom: false,
                child: Column(
                  children: [
                    Image.asset('assets/Capa_2.png', width: 76, height: 76),
                    const SizedBox(height: 12),
                    Text(
                      _isLogin ? 'Welcome back!' : 'Create your account',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: AppColors.dark,
                        fontSize: 25,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      _isLogin
                          ? 'Your next favourite meal is waiting.'
                          : 'Join us and enjoy something delicious.',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: AppColors.dark,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Transform.translate(
              offset: const Offset(0, -38),
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.dark.withValues(alpha: .07),
                      blurRadius: 18,
                      offset: const Offset(0, 7),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      _isLogin ? 'Log in' : 'Sign up',
                      style: const TextStyle(
                        color: AppColors.dark,
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 18),
                    const _FieldLabel('Email'),
                    const SizedBox(height: 7),
                    TextField(
                      controller: _email,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(
                        hintText: 'Enter your email address',
                        prefixIcon: Icon(Icons.email_outlined,
                            color: AppColors.primary, size: 19),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const _FieldLabel('Password'),
                    const SizedBox(height: 7),
                    TextField(
                      controller: _password,
                      obscureText: _hidePassword,
                      textInputAction: TextInputAction.done,
                      onSubmitted: (_) {
                        if (!_busy) _submit();
                      },
                      decoration: InputDecoration(
                        hintText: 'Enter your password',
                        prefixIcon: const Icon(Icons.lock_outline,
                            color: AppColors.primary, size: 19),
                        suffixIcon: IconButton(
                          tooltip:
                              _hidePassword ? 'Show password' : 'Hide password',
                          onPressed: () =>
                              setState(() => _hidePassword = !_hidePassword),
                          icon: Icon(
                            _hidePassword
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            color: AppColors.grey,
                            size: 19,
                          ),
                        ),
                      ),
                    ),
                    if (_isLogin)
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: _resetPassword,
                          style: TextButton.styleFrom(
                            foregroundColor: AppColors.primary,
                          ),
                          child: const Text(
                            'Forgot password?',
                            style: TextStyle(fontSize: 12),
                          ),
                        ),
                      )
                    else
                      const SizedBox(height: 12),
                    const SizedBox(height: 4),
                    ElevatedButton(
                      onPressed: _busy ? null : _submit,
                      child: _busy
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : Text(_isLogin ? 'Log in' : 'Create account'),
                    ),
                    const SizedBox(height: 14),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          _isLogin
                              ? "Don't have an account?"
                              : 'Already have an account?',
                          style: const TextStyle(
                            color: AppColors.grey,
                            fontSize: 12,
                          ),
                        ),
                        TextButton(
                          onPressed: () => setState(() => _isLogin = !_isLogin),
                          style: TextButton.styleFrom(
                            foregroundColor: AppColors.primary,
                            padding: const EdgeInsets.only(left: 5),
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: Text(
                            _isLogin ? 'Sign up' : 'Log in',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  final String label;
  const _FieldLabel(this.label);

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: const TextStyle(
        color: AppColors.dark,
        fontSize: 12,
        fontWeight: FontWeight.w700,
      ),
    );
  }
}

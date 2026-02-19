import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../services/auth_service.dart';
import '../../models/user_model.dart';
import '../../providers/app_state.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _email = TextEditingController(text: 'name@example.com');
  final TextEditingController _password = TextEditingController(text: 'password');
  final AuthService _auth = AuthService();

  bool _loading = false;
  bool _obscure = true;

  Future<void> _doLogin() async {
    setState(() => _loading = true);
    final user = await _auth.login(_email.text, _password.text);
    Provider.of<AppState>(context, listen: false).login(user);
    setState(() => _loading = false);
    if (mounted) context.go('/home');
  }

  @override
  Widget build(BuildContext context) {
    final bg = const Color(0xFF0B1220);
    final card = const Color(0xFF111827);
    final inputFill = const Color(0xFF14202B);
    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 8),
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(color: card, borderRadius: BorderRadius.circular(18)),
                child: const Center(child: Icon(Icons.headset_mic_rounded, color: Colors.blueAccent, size: 36)),
              ),
              const SizedBox(height: 18),
              const Text('SupportSync', style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold)),
              const SizedBox(height: 6),
              Text('Sign in to your account', style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 14)),
              const SizedBox(height: 28),

              // Email field
              Align(alignment: Alignment.centerLeft, child: Text('Email Address', style: TextStyle(color: Colors.white.withOpacity(0.8)))),
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(color: inputFill, borderRadius: BorderRadius.circular(28)),
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: TextField(
                  controller: _email,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.email_outlined, color: Colors.white70),
                    border: InputBorder.none,
                    hintText: 'name@example.com',
                    hintStyle: TextStyle(color: Colors.white54),
                  ),
                ),
              ),
              const SizedBox(height: 18),

              // Password label + forgot
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Password', style: TextStyle(color: Colors.white.withOpacity(0.8))),
                  TextButton(onPressed: () {}, child: Text('Forgot Password?', style: TextStyle(color: Colors.blueAccent)))
                ],
              ),
              Container(
                decoration: BoxDecoration(color: inputFill, borderRadius: BorderRadius.circular(28)),
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: TextField(
                  controller: _password,
                  obscureText: _obscure,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.lock_outline, color: Colors.white70),
                    border: InputBorder.none,
                    hintText: '********',
                    hintStyle: const TextStyle(color: Colors.white54),
                    suffixIcon: IconButton(
                      icon: Icon(_obscure ? Icons.visibility_off : Icons.visibility, color: Colors.white70),
                      onPressed: () => setState(() => _obscure = !_obscure),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 22),
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: _loading ? null : _doLogin,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1E88E5),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
                    elevation: 8,
                  ),
                  child: _loading ? const CircularProgressIndicator(color: Colors.white) : const Text('Sign In', style: TextStyle(fontSize: 18)),
                ),
              ),

              const SizedBox(height: 20),
              Row(children: [
                Expanded(child: Divider(color: Colors.white24)),
                Padding(padding: const EdgeInsets.symmetric(horizontal: 12), child: Text('OR CONTINUE WITH', style: TextStyle(color: Colors.white54, fontSize: 12))),
                Expanded(child: Divider(color: Colors.white24)),
              ]),

              const SizedBox(height: 18),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () {},
                  icon: Image.network('https://www.gstatic.com/firebasejs/ui/2.0.0/images/auth/google.svg', width: 20, height: 20),
                  label: const Padding(padding: EdgeInsets.symmetric(vertical: 14), child: Text('Sign in with Google', style: TextStyle(color: Colors.white))),
                  style: OutlinedButton.styleFrom(
                    backgroundColor: card,
                    side: BorderSide.none,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
                  ),
                ),
              ),

              const SizedBox(height: 36),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Text("Don't have an account? ", style: TextStyle(color: Colors.white.withOpacity(0.7))),
                GestureDetector(onTap: () {}, child: const Text('Register', style: TextStyle(color: Colors.blueAccent)))
              ])
            ],
          ),
        ),
      ),
    );
  }
}

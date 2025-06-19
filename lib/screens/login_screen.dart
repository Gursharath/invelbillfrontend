import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';
import '../constants/app_routes.dart';
import '../widgets/custom_text_field.dart';
import '../utils/validators.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String? error;
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Positioned.fill(
            child: Image.asset(
              'assets/images/login_bg.jpg',
              fit: BoxFit.cover,
            ),
          ),

          // Foreground content
          Center(
            child: SingleChildScrollView(
              child: Card(
                color: Colors.black.withOpacity(0.7),
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                margin: const EdgeInsets.all(32),
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "InvenBill Login",
                          style: GoogleFonts.poppins(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF00FFC6), // Neon cyan
                            shadows: [
                              const Shadow(
                                color: Color(0xFF00FFC6),
                                blurRadius: 12,
                              )
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                        CustomTextField(
                          controller: _email,
                          label: "Email",
                          validator: Validators.validateEmail,
                        ),
                        const SizedBox(height: 16),
                        CustomTextField(
                          controller: _password,
                          label: "Password",
                          obscure: true,
                          validator: Validators.validatePassword,
                        ),
                        if (error != null) ...[
                          const SizedBox(height: 12),
                          Text(
                            error!,
                            style: const TextStyle(color: Colors.redAccent),
                          ),
                        ],
                        const SizedBox(height: 20),
                        loading
                            ? const CircularProgressIndicator()
                            : ElevatedButton.icon(
                                onPressed: () async {
                                  if (!_formKey.currentState!.validate())
                                    return;
                                  setState(() {
                                    loading = true;
                                    error = null;
                                  });
                                  final ok = await context
                                      .read<AuthProvider>()
                                      .login(_email.text.trim(),
                                          _password.text.trim());
                                  setState(() {
                                    loading = false;
                                  });
                                  if (ok) {
                                    Navigator.pushReplacementNamed(
                                        context, AppRoutes.dashboard);
                                  } else {
                                    setState(() {
                                      error = "Invalid credentials";
                                    });
                                  }
                                },
                                icon: const Icon(Icons.lock_open_rounded),
                                label: const Text("Login"),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF00FFC6),
                                  foregroundColor: Colors.black,
                                  textStyle: const TextStyle(fontSize: 16),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 24, vertical: 14),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              ),
                        const SizedBox(height: 10),
                        TextButton(
                          onPressed: () =>
                              Navigator.pushNamed(context, AppRoutes.register),
                          child: Text(
                            "Register as Owner",
                            style: GoogleFonts.poppins(
                              color: Colors.white70,
                              fontSize: 14,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

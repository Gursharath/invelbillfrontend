import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../constants/app_routes.dart';
import '../widgets/custom_text_field.dart';
import '../utils/validators.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String? error;
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Positioned.fill(
            child: Image.asset(
              'assets/images/login_bg.jpg', // <-- Update path if needed
              fit: BoxFit.cover,
            ),
          ),
          // Foreground content
          Center(
            child: Card(
              margin: const EdgeInsets.all(32),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text("Register Owner",
                          style: Theme.of(context).textTheme.headlineSmall),
                      const SizedBox(height: 16),
                      CustomTextField(
                        controller: _name,
                        label: "Name",
                        validator: Validators.validateRequired,
                      ),
                      const SizedBox(height: 12),
                      CustomTextField(
                        controller: _email,
                        label: "Email",
                        validator: Validators.validateEmail,
                      ),
                      const SizedBox(height: 12),
                      CustomTextField(
                        controller: _password,
                        label: "Password",
                        obscure: true,
                        validator: Validators.validatePassword,
                      ),
                      if (error != null) ...[
                        const SizedBox(height: 10),
                        Text(error!, style: const TextStyle(color: Colors.red)),
                      ],
                      const SizedBox(height: 20),
                      loading
                          ? const CircularProgressIndicator()
                          : ElevatedButton(
                              onPressed: () async {
                                if (!_formKey.currentState!.validate()) return;
                                setState(() {
                                  loading = true;
                                  error = null;
                                });
                                final ok = await context
                                    .read<AuthProvider>()
                                    .register(
                                        _name.text.trim(),
                                        _email.text.trim(),
                                        _password.text.trim());
                                setState(() {
                                  loading = false;
                                });
                                if (ok) {
                                  Navigator.pushReplacementNamed(
                                      context, AppRoutes.dashboard);
                                } else {
                                  setState(() {
                                    error = "Registration failed";
                                  });
                                }
                              },
                              child: const Text("Register"),
                            ),
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text("Back to Login"),
                      ),
                    ],
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

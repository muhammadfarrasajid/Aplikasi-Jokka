// lib/features/auth/presentation/login_page.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Import yang dibutuhkan
import '../../../core/theme/app_theme.dart'; 
import 'register_page.dart'; 
// import 'forgot_password_page.dart'; // DIHAPUS

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailUsernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _ingatSaya = false;
  bool _isPasswordVisible = false;

  @override
  void dispose() {
    _emailUsernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // Logika login (simulasi)
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Login Berhasil (Simulasi)')),
      );
    }
  }

  void _navigateToRegister() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const RegisterPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              // Logo JOKKA
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'JOKKA',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: JokkaColors.primary, 
                    ),
                  ),
                  const Icon(Icons.person_outline),
                ],
              ),
              const SizedBox(height: 48),

              // Kartu Form Login
              Center(
                child: Container(
                  padding: const EdgeInsets.all(24.0),
                  decoration: BoxDecoration(
                    color: Colors.white, 
                    borderRadius: BorderRadius.circular(16.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        const Text(
                          'Masuk Akun',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 24),
                        
                        // Input Email / Username
                        _buildTextField(
                          controller: _emailUsernameController,
                          hint: 'Email / Username',
                          validator: (value) => value!.isEmpty ? 'Email/Username tidak boleh kosong' : null,
                          keyboardType: TextInputType.text,
                        ),
                        const SizedBox(height: 16),
                        
                        // Input Password
                        _buildPasswordTextField(
                          controller: _passwordController,
                          hint: 'Password',
                          isVisible: _isPasswordVisible,
                          toggleVisibility: () {
                            setState(() {
                              _isPasswordVisible = !_isPasswordVisible;
                            });
                          },
                          validator: (value) => value!.isEmpty ? 'Password tidak boleh kosong' : null,
                        ),
                        const SizedBox(height: 8),

                        // Checkbox dan Placeholder Lupa Password
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                SizedBox(
                                  height: 24,
                                  width: 24,
                                  child: Checkbox(
                                    value: _ingatSaya,
                                    onChanged: (bool? newValue) {
                                      setState(() {
                                        _ingatSaya = newValue!;
                                      });
                                    },
                                    activeColor: JokkaColors.primary,
                                  ),
                                ),
                                const Text('Ingat saya', style: TextStyle(fontSize: 14)),
                              ],
                            ),
                            // TEKS LUPA PASSWORD HANYA SEBAGAI PLACEHOLDER, TIDAK ADA NAVIGASI
                            const Text( 
                                'Lupa password?',
                                style: TextStyle(
                                  color: JokkaColors.primary,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),

                        // Tombol Masuk
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _submitForm,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: JokkaColors.primary,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: const Text(
                              'Masuk',
                              style: TextStyle(fontSize: 18, color: Colors.white),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        
                        // Pemisah "atau"
                        const Text('atau', style: TextStyle(color: Colors.grey)),
                        const SizedBox(height: 16),

                        // Tombol Register with Google
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton(
                            onPressed: () {
                              // Logika Google Sign-in
                            },
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              side: const BorderSide(color: Colors.grey),
                            ),
                            child: const Text('Register with Google', style: TextStyle(fontSize: 16, color: JokkaColors.textPrimary)),
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Belum punya akun? Daftar di sini
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text('Belum punya akun? '),
                            GestureDetector(
                              onTap: _navigateToRegister, 
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                decoration: BoxDecoration(
                                  color: JokkaColors.primary,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Text(
                                  'Daftar di sini',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 100), 
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  // --- WIDGET HELPER ---
  
  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required String? Function(String?) validator,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide.none,
        ),
      ),
      validator: validator,
    );
  }

  Widget _buildPasswordTextField({
    required TextEditingController controller,
    required String hint,
    required bool isVisible,
    required VoidCallback toggleVisibility,
    required String? Function(String?) validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: !isVisible,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide.none,
        ),
        suffixIcon: IconButton(
          icon: Icon(
            isVisible ? Icons.visibility : Icons.visibility_off,
            color: Colors.grey,
          ),
          onPressed: toggleVisibility,
        ),
      ),
      validator: validator,
    );
  }

  Widget _buildBottomNavBar() {
    return Container(
      height: 60,
      decoration: const BoxDecoration(
        color: Colors.black,
        border: Border(
          top: BorderSide(color: Colors.grey, width: 0.1),
        ),
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Icon(Icons.home_outlined, color: Colors.white, size: 30),
          Icon(Icons.explore_outlined, color: Colors.white, size: 30),
          Icon(Icons.description_outlined, color: Colors.white, size: 30),
          Icon(Icons.bookmark_border, color: Colors.white, size: 30),
        ],
      ),
    );
  }
}
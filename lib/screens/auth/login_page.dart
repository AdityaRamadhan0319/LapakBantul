import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'register_page.dart';
import 'forgot_password_page.dart';
import '../../main_navigation.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final _formKey    = GlobalKey<FormState>();
  final _emailCtrl  = TextEditingController();
  final _passCtrl   = TextEditingController();

  bool _obscure    = true;
  bool _isLoading  = false;
  String? _errorMessage;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  // ─── Login Handler ─────────────────────────────────────────────
  Future<void> _login() async {
    setState(() => _errorMessage = null);

    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      // Step 1 — Login ke Firebase Auth
      final credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
        email:    _emailCtrl.text.trim(),
        password: _passCtrl.text,
      );

      // Step 2 — Cek data user di Firestore
      final uid = credential.user!.uid;
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .get();

      if (!mounted) return;

      if (!doc.exists) {
        // Data user tidak ada di Firestore — tolak login
        await FirebaseAuth.instance.signOut();
        setState(() {
          _errorMessage =
              'Data akun tidak ditemukan. Silakan daftar terlebih dahulu.';
        });
        return;
      }

      // Step 3 — Berhasil, masuk ke halaman utama
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const MainNavigation()),
      );

    } on FirebaseAuthException catch (e) {
      setState(() {
        _errorMessage = _firebaseErrorMessage(e.code);
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Terjadi kesalahan. Periksa koneksi Anda.';
      });
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  String _firebaseErrorMessage(String code) {
    switch (code) {
      case 'user-not-found':
        return 'Email tidak terdaftar.';
      case 'wrong-password':
        return 'Password salah. Coba lagi.';
      case 'invalid-credential':
        return 'Email atau password salah.';
      case 'invalid-email':
        return 'Format email tidak valid.';
      case 'user-disabled':
        return 'Akun ini telah dinonaktifkan.';
      case 'network-request-failed':
        return 'Koneksi internet bermasalah. Coba lagi.';
      default:
        return 'Terjadi kesalahan ($code). Coba lagi.';
    }
  }

  // ─── Build ─────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      backgroundColor: const Color(0xFFF4F7FB),

      body: SafeArea(
        child: SingleChildScrollView(

          child: Column(
            children: [

              // ================= HEADER =================

              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(24, 50, 24, 40),

                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFF0B3A66),
                      Color(0xFF145DA0),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.only(
                    bottomLeft:  Radius.circular(35),
                    bottomRight: Radius.circular(35),
                  ),
                ),

                child: Column(
                  children: [

                    Container(
                      width:  90,
                      height: 90,
                      decoration: BoxDecoration(
                        color:  Colors.white.withOpacity(0.15),
                        shape:  BoxShape.circle,
                        border: Border.all(color: Colors.white24, width: 2),
                      ),
                      child: const Icon(
                        Icons.account_balance_rounded,
                        color: Colors.white,
                        size:  45,
                      ),
                    ),

                    const SizedBox(height: 25),

                    const Text(
                      "LaPak Bantul",
                      style: TextStyle(
                        color:      Colors.white,
                        fontSize:   30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 8),

                    const Text(
                      "Pusat layanan pajak terpadu",
                      style: TextStyle(color: Colors.white70, fontSize: 15),
                    ),
                  ],
                ),
              ),

              // ================= FORM LOGIN =================

              Padding(
                padding: const EdgeInsets.all(24),

                child: Form(
                  key: _formKey,

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      const SizedBox(height: 10),

                      const Text(
                        "Login",
                        style: TextStyle(
                          fontSize:   28,
                          fontWeight: FontWeight.bold,
                          color:      Color(0xFF0B3A66),
                        ),
                      ),

                      const SizedBox(height: 8),

                      const SizedBox(height: 35),

                      // ── Error Banner ──────────────────────────
                      if (_errorMessage != null) ...[
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                          decoration: BoxDecoration(
                            color:        const Color(0xFFFFEBEE),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: const Color(0xFFEF9A9A)),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.error_outline,
                                color: Color(0xFFC62828),
                                size:  20,
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  _errorMessage!,
                                  style: const TextStyle(
                                    color:    Color(0xFFC62828),
                                    fontSize: 13.5,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],

                      // EMAIL
                      const Text(
                        "Email",
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller:   _emailCtrl,
                        keyboardType: TextInputType.emailAddress,
                        decoration:   _inputDecoration(
                          "Masukkan email",
                          Icons.email_outlined,
                        ),
                        validator: (v) {
                          if (v == null || !v.contains('@')) {
                            return "Masukkan email valid";
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 20),

                      // PASSWORD
                      const Text(
                        "Kata Sandi",
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller:  _passCtrl,
                        obscureText: _obscure,
                        decoration:  _inputDecoration(
                          "Masukkan kata sandi",
                          Icons.lock_outline,
                        ).copyWith(
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscure
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                            ),
                            onPressed: () =>
                                setState(() => _obscure = !_obscure),
                          ),
                        ),
                        validator: (v) {
                          if (v == null || v.length < 6) {
                            return "Password minimal 6 karakter";
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 15),

                      Align(
                        alignment: Alignment.centerRight,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const ForgotPasswordPage(),
                              ),
                            );
                          },
                          child: const Text(
                            "Lupa Kata Sandi?",
                            style: TextStyle(
                              color:      Color(0xFF145DA0),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 35),

                      // BUTTON LOGIN
                      SizedBox(
                        width:  double.infinity,
                        height: 58,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _login,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF0B3A66),
                            disabledBackgroundColor:
                                const Color(0xFF0B3A66).withOpacity(0.6),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18),
                            ),
                          ),
                          child: _isLoading
                              ? const SizedBox(
                                  width:  24,
                                  height: 24,
                                  child:  CircularProgressIndicator(
                                    strokeWidth: 2.5,
                                    color:       Colors.white,
                                  ),
                                )
                              : const Text(
                                  "Masuk",
                                  style: TextStyle(
                                    fontSize:   17,
                                    fontWeight: FontWeight.bold,
                                    color:      Colors.white,
                                  ),
                                ),
                        ),
                      ),

                      const SizedBox(height: 35),

                      // REGISTER
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Belum punya akun?",
                            style: TextStyle(color: Colors.grey),
                          ),
                          const SizedBox(width: 5),
                          GestureDetector(
                            onTap: _isLoading
                                ? null
                                : () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => const RegisterPage(),
                                      ),
                                    );
                                  },
                            child: const Text(
                              "Register",
                              style: TextStyle(
                                color:      Color(0xFF0B3A66),
                                fontWeight: FontWeight.bold,
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
      ),
    );
  }

  InputDecoration _inputDecoration(String hint, IconData icon) {
    return InputDecoration(
      hintText:   hint,
      prefixIcon: Icon(icon, color: const Color(0xFF145DA0)),
      filled:     true,
      fillColor:  Colors.white,
      contentPadding: const EdgeInsets.symmetric(vertical: 18),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide:   BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide:   BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: const BorderSide(color: Color(0xFF145DA0), width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: const BorderSide(color: Color(0xFFEF5350), width: 1.5),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: const BorderSide(color: Color(0xFFEF5350), width: 2),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import '../../services/auth_service.dart';
import 'login_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {

  final _formKey            = GlobalKey<FormState>();
  final _nameCtrl           = TextEditingController();
  final _emailCtrl          = TextEditingController();
  final _phoneCtrl          = TextEditingController();
  final _passCtrl           = TextEditingController();
  final _confirmPassCtrl    = TextEditingController();

  final AuthService _authService = AuthService();

  bool _obscure        = true;
  bool _obscureConfirm = true;
  bool _isLoading      = false;
  String? _errorMessage;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    _passCtrl.dispose();
    _confirmPassCtrl.dispose();
    super.dispose();
  }

  // ─── Register Handler ──────────────────────────────────────────
  Future<void> _register() async {
    setState(() => _errorMessage = null);

    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final result = await _authService.register(
        name:     _nameCtrl.text.trim(),
        email:    _emailCtrl.text.trim(),
        password: _passCtrl.text,
        phone:    _phoneCtrl.text.trim(), // ← sudah ditambahkan
      );

      if (!mounted) return;

      if (result['success'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Row(
              children: [
                Icon(Icons.check_circle_outline, color: Colors.white),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Akun berhasil dibuat! Silakan masuk.',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
            backgroundColor: Color(0xFF2E7D32),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(12)),
            ),
          ),
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const LoginPage()),
        );
      } else {
        setState(() {
          _errorMessage = result['message'] as String? ??
              'Pendaftaran gagal. Coba lagi.';
        });
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = 'Terjadi kesalahan jaringan. Periksa koneksi Anda.';
      });
    } finally {
      if (mounted) setState(() => _isLoading = false);
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
                        Icons.person_add_alt_1_rounded,
                        color: Colors.white,
                        size:  45,
                      ),
                    ),

                    const SizedBox(height: 25),

                    const Text(
                      "Daftar Akun",
                      style: TextStyle(
                        color:      Colors.white,
                        fontSize:   30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 8),

                    const Text(
                      "Buat akun baru LaPak Bantul",
                      style: TextStyle(color: Colors.white70, fontSize: 15),
                    ),
                  ],
                ),
              ),

              // ================= FORM =================

              Padding(
                padding: const EdgeInsets.all(24),

                child: Form(
                  key: _formKey,

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      const SizedBox(height: 10),

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
                            border: Border.all(
                              color: const Color(0xFFEF9A9A),
                            ),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.error_outline,
                                color: Color(0xFFC62828),
                                size: 20,
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

                      // ── Nama ──────────────────────────────────
                      _fieldLabel("Nama Lengkap"),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: _nameCtrl,
                        textCapitalization: TextCapitalization.words,
                        decoration: _inputDecoration(
                          "Masukkan nama lengkap",
                          Icons.person_outline,
                        ),
                        validator: (v) {
                          if (v == null || v.trim().isEmpty) {
                            return "Nama tidak boleh kosong";
                          }
                          if (v.trim().length < 3) {
                            return "Nama minimal 3 karakter";
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 20),

                      // ── Email ─────────────────────────────────
                      _fieldLabel("Email"),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller:   _emailCtrl,
                        keyboardType: TextInputType.emailAddress,
                        decoration:   _inputDecoration(
                          "Masukkan email",
                          Icons.email_outlined,
                        ),
                        validator: (v) {
                          if (v == null || v.isEmpty) {
                            return "Email tidak boleh kosong";
                          }
                          final emailRegex = RegExp(
                            r'^[\w\-.]+@([\w\-]+\.)+[\w\-]{2,}$',
                          );
                          if (!emailRegex.hasMatch(v.trim())) {
                            return "Format email tidak valid";
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 20),

                      // ── Nomor Telepon ─────────────────────────
                      _fieldLabel("Nomor Telepon"),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller:   _phoneCtrl,
                        keyboardType: TextInputType.phone,
                        decoration:   _inputDecoration(
                          "Masukkan nomor telepon",
                          Icons.phone_outlined,
                        ),
                        validator: (v) {
                          if (v == null || v.isEmpty) {
                            return "Nomor telepon tidak boleh kosong";
                          }
                          if (v.length < 10 || v.length > 15) {
                            return "Nomor telepon tidak valid (10-15 digit)";
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 20),

                      // ── Password ──────────────────────────────
                      _fieldLabel("Kata Sandi"),
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

                      const SizedBox(height: 20),

                      // ── Konfirmasi Password ───────────────────
                      _fieldLabel("Konfirmasi Kata Sandi"),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller:  _confirmPassCtrl,
                        obscureText: _obscureConfirm,
                        decoration:  _inputDecoration(
                          "Ulangi kata sandi",
                          Icons.lock_outline,
                        ).copyWith(
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscureConfirm
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                            ),
                            onPressed: () => setState(
                                () => _obscureConfirm = !_obscureConfirm),
                          ),
                        ),
                        validator: (v) {
                          if (v != _passCtrl.text) {
                            return "Password tidak cocok";
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 35),

                      // ── Button Daftar ─────────────────────────
                      SizedBox(
                        width:  double.infinity,
                        height: 58,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _register,
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
                                  "Daftar",
                                  style: TextStyle(
                                    fontSize:   17,
                                    fontWeight: FontWeight.bold,
                                    color:      Colors.white,
                                  ),
                                ),
                        ),
                      ),

                      const SizedBox(height: 30),

                      // ── Link ke Login ─────────────────────────
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Sudah punya akun?",
                            style: TextStyle(color: Colors.grey),
                          ),
                          const SizedBox(width: 5),
                          GestureDetector(
                            onTap: _isLoading
                                ? null
                                : () => Navigator.pop(context),
                            child: const Text(
                              "Masuk",
                              style: TextStyle(
                                color:      Color(0xFF0B3A66),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 30),
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

  // ─── Helpers ───────────────────────────────────────────────────

  Widget _fieldLabel(String label) => Text(
        label,
        style: const TextStyle(fontWeight: FontWeight.w600),
      );

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
        borderSide: const BorderSide(
          color: Color(0xFF145DA0),
          width: 2,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: const BorderSide(
          color: Color(0xFFEF5350),
          width: 1.5,
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: const BorderSide(
          color: Color(0xFFEF5350),
          width: 2,
        ),
      ),
    );
  }
}
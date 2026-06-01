import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() =>
      _ForgotPasswordPageState();
}

class _ForgotPasswordPageState
    extends State<ForgotPasswordPage> {

  final _formKey  = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();

  bool _sent      = false;
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _emailCtrl.dispose();
    super.dispose();
  }

  // ─── Submit ────────────────────────────────────────────────────
Future<void> _submit() async {
  setState(() => _errorMessage = null);

  if (!_formKey.currentState!.validate()) return;

  setState(() => _isLoading = true);

  try {
    final actionCodeSettings = ActionCodeSettings(
      url: 'https://lapakbantul-7ce0b.web.app/reset-password.html',
      handleCodeInApp: false,
    );

    await FirebaseAuth.instance.sendPasswordResetEmail(
      email: _emailCtrl.text.trim(),
      actionCodeSettings: actionCodeSettings,
    );

    if (mounted) setState(() => _sent = true);

  } on FirebaseAuthException catch (e) {
    setState(() {
      _errorMessage = _firebaseErrorMessage(e.code);
    });
  } catch (e) {
    setState(() {
      _errorMessage = 'Terjadi kesalahan. Coba lagi.';
    });
  } finally {
    if (mounted) setState(() => _isLoading = false);
  }
}

  String _firebaseErrorMessage(String code) {
    switch (code) {
      case 'user-not-found':
        return 'Email tidak terdaftar.';
      case 'invalid-email':
        return 'Format email tidak valid.';
      case 'network-request-failed':
        return 'Koneksi internet bermasalah. Coba lagi.';
      default:
        return 'Terjadi kesalahan ($code). Coba lagi.';
    }
  }

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
                        Icons.lock_reset_rounded,
                        color: Colors.white,
                        size:  45,
                      ),
                    ),

                    const SizedBox(height: 25),

                    Text(
                      _sent ? "Email Terkirim" : "Lupa Password",
                      style: const TextStyle(
                        color:      Colors.white,
                        fontSize:   30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 8),

                    Text(
                      _sent
                          ? "Silahkan cek email Anda"
                          : "Reset password akun LaPak Bantul",
                      style: const TextStyle(
                        color:    Colors.white70,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(24),
                child: _sent ? _successView() : _formView(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ================= FORM =================

  Widget _formView() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          const SizedBox(height: 20),

          // ── Error Banner ────────────────────────────────
          if (_errorMessage != null) ...[
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical:   14,
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

          const Text(
            "Email",
            style: TextStyle(fontWeight: FontWeight.w600),
          ),

          const SizedBox(height: 10),

          TextFormField(
            controller:   _emailCtrl,
            keyboardType: TextInputType.emailAddress,
            decoration:   _inputDecoration(
              "Masukkan email Anda",
              Icons.email_outlined,
            ),
            validator: (v) {
              if (v == null || !v.contains('@')) {
                return "Masukkan email valid";
              }
              return null;
            },
          ),

          const SizedBox(height: 18),

          const Text(
            "Kami akan mengirim tautan reset password ke email Anda.",
            style: TextStyle(color: Colors.grey, height: 1.5),
          ),

          const SizedBox(height: 35),

          SizedBox(
            width:  double.infinity,
            height: 58,
            child: ElevatedButton(
              onPressed: _isLoading ? null : _submit,
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
                      "Kirim Reset Password",
                      style: TextStyle(
                        fontSize:   16,
                        fontWeight: FontWeight.bold,
                        color:      Colors.white,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  // ================= SUCCESS VIEW =================

  Widget _successView() {
    return Column(
      children: [

        const SizedBox(height: 30),

        Container(
          width:  120,
          height: 120,
          decoration: BoxDecoration(
            color: Colors.green.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.mark_email_read_rounded,
            size:  60,
            color: Colors.green,
          ),
        ),

        const SizedBox(height: 30),

        const Text(
          "Berhasil!",
          style: TextStyle(
            fontSize:   28,
            fontWeight: FontWeight.bold,
            color:      Color(0xFF0B3A66),
          ),
        ),

        const SizedBox(height: 15),

        Text(
          "Link reset password telah dikirim ke:\n${_emailCtrl.text.trim()}",
          textAlign: TextAlign.center,
          style: const TextStyle(
            color:    Colors.grey,
            fontSize: 15,
            height:   1.6,
          ),
        ),

        const SizedBox(height: 10),

        const Text(
          "Cek folder Spam jika tidak ada di Inbox.",
          textAlign: TextAlign.center,
          style: TextStyle(
            color:    Colors.orange,
            fontSize: 13,
          ),
        ),

        const SizedBox(height: 40),

        SizedBox(
          width:  double.infinity,
          height: 58,
          child: ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0B3A66),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
            ),
            child: const Text(
              "Kembali ke Login",
              style: TextStyle(
                fontSize:   16,
                fontWeight: FontWeight.bold,
                color:      Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ================= INPUT DECORATION =================

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
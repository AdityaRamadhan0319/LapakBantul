import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // ─── ReqRes API Register ───────────────────────────────────────
  Future<Map<String, dynamic>> reqresRegister({
    required String email,
    required String password,
  }) async {
    final uri = Uri.parse('https://reqres.in/api/register');
    final response = await http.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'x-api-key': 'free_user_3EUnpgPatFYwZT9A1Jqprc5D8bj',
      },
      body: jsonEncode({'email': email, 'password': password}),
    );

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    if (response.statusCode == 200) {
      return {'success': true, 'data': data};
    } else {
      final errorMsg = data['error'] ?? 'Registrasi gagal';
      return {'success': false, 'message': errorMsg};
    }
  }

  // ─── Firebase Register + Simpan ke Firestore ──────────────────
  Future<Map<String, dynamic>> firebaseRegister({
    required String email,
    required String password,
    required String displayName,
    String? phone,
  }) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await credential.user?.updateDisplayName(displayName);
      await credential.user?.reload();

      // Simpan nama, email, telepon ke Firestore
      await _firestore
          .collection('users')
          .doc(credential.user!.uid)
          .set({
        'nama': displayName,
        'email': email,
        'telepon': phone ?? '',
        'createdAt': FieldValue.serverTimestamp(),
      });

      return {'success': true, 'user': credential.user};
    } on FirebaseAuthException catch (e) {
      return {'success': false, 'message': _firebaseErrorMessage(e.code)};
    } catch (e) {
      return {'success': false, 'message': 'Terjadi kesalahan: $e'};
    }
  }

  // ─── Full Register Flow ────────────────────────────────────────
  Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String password,
    String? phone,
  }) async {
    final reqresResult = await reqresRegister(
      email: email,
      password: password,
    );

    if (!reqresResult['success']) {
      final msg = reqresResult['message'] as String? ?? '';
      if (msg.toLowerCase().contains('missing') ||
          msg.toLowerCase().contains('undefined')) {
        return {'success': false, 'message': msg};
      }
    }

    return await firebaseRegister(
      email: email,
      password: password,
      displayName: name,
      phone: phone,
    );
  }

  // ─── Login ────────────────────────────────────────────────────
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return {'success': true, 'user': credential.user};
    } on FirebaseAuthException catch (e) {
      return {'success': false, 'message': _firebaseErrorMessage(e.code)};
    } catch (e) {
      return {'success': false, 'message': 'Terjadi kesalahan: $e'};
    }
  }

  // ─── Get Data User dari Firestore ─────────────────────────────
  Future<Map<String, dynamic>?> getUserData(String uid) async {
    final doc = await _firestore.collection('users').doc(uid).get();
    return doc.data();
  }

  // ─── Logout ───────────────────────────────────────────────────
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // ─── Helpers ──────────────────────────────────────────────────
  String _firebaseErrorMessage(String code) {
    switch (code) {
      case 'email-already-in-use':
        return 'Email sudah terdaftar. Silakan gunakan email lain.';
      case 'invalid-email':
        return 'Format email tidak valid.';
      case 'weak-password':
        return 'Password terlalu lemah. Minimal 6 karakter.';
      case 'wrong-password':
        return 'Password salah. Coba lagi.';
      case 'user-not-found':
        return 'Email tidak terdaftar.';
      case 'network-request-failed':
        return 'Koneksi internet bermasalah. Coba lagi.';
      default:
        return 'Terjadi kesalahan ($code). Coba lagi.';
    }
  }
}
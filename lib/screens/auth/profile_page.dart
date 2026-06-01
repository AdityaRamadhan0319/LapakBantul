import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'login_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Map<String, dynamic>? _userData;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      final uid = FirebaseAuth.instance.currentUser!.uid;
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .get();

      if (mounted) {
        setState(() {
          _userData  = doc.data();
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _logout() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: const Text(
          "Keluar",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: const Text("Apakah kamu yakin ingin keluar?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text(
              "Batal",
              style: TextStyle(color: Colors.grey),
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0B3A66),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              "Keluar",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await FirebaseAuth.instance.signOut();
      if (!mounted) return;
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const LoginPage()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),

      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: Color(0xFF0B3A66),
              ),
            )
          : SingleChildScrollView(
              child: Column(
                children: [

                  // ── HEADER ──────────────────────────────────
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.fromLTRB(24, 60, 24, 40),
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

                        // Avatar
                        Container(
                          width:  90,
                          height: 90,
                          decoration: BoxDecoration(
                            color:  Colors.white.withOpacity(0.2),
                            shape:  BoxShape.circle,
                            border: Border.all(
                              color: Colors.white54,
                              width: 3,
                            ),
                          ),
                          child: const Icon(
                            Icons.person,
                            color: Colors.white,
                            size:  50,
                          ),
                        ),

                        const SizedBox(height: 15),

                        Text(
                          _userData?['nama'] ?? '-',
                          style: const TextStyle(
                            color:      Colors.white,
                            fontSize:   22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 5),

                        Text(
                          _userData?['email'] ?? '-',
                          style: const TextStyle(
                            color:    Colors.white70,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),

                  // ── DATA USER ────────────────────────────────
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color:        Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color:      Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset:     const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          const Text(
                            "Data Akun",
                            style: TextStyle(
                              fontSize:   16,
                              fontWeight: FontWeight.bold,
                              color:      Color(0xFF0B3A66),
                            ),
                          ),

                          const SizedBox(height: 20),

                          _dataRow(
                            Icons.person_outline,
                            "Nama Lengkap",
                            _userData?['nama'] ?? '-',
                          ),

                          const Divider(height: 24),

                          _dataRow(
                            Icons.email_outlined,
                            "Email",
                            _userData?['email'] ?? '-',
                          ),

                          const Divider(height: 24),

                          _dataRow(
                            Icons.phone_outlined,
                            "Nomor Telepon",
                            _userData?['telepon']?.isNotEmpty == true
                                ? _userData!['telepon']
                                : '-',
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // ── TOMBOL LOGOUT ────────────────────────────
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: SizedBox(
                      width:  double.infinity,
                      height: 55,
                      child: ElevatedButton.icon(
                        onPressed: _logout,
                        icon: const Icon(
                          Icons.logout_rounded,
                          color: Colors.white,
                        ),
                        label: const Text(
                          "Keluar",
                          style: TextStyle(
                            fontSize:   16,
                            fontWeight: FontWeight.bold,
                            color:      Colors.white,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFC62828),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 40),
                ],
              ),
            ),
    );
  }

  Widget _dataRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color:        const Color(0xFFEEF2FF),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: const Color(0xFF0B3A66), size: 22),
        ),
        const SizedBox(width: 15),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  color:    Colors.grey,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                value,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize:   15,
                  color:      Color(0xFF1F3B63),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
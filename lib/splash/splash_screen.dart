import 'package:flutter/material.dart';
import '/screens/Auth/login_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final PageController _controller = PageController();

  int _currentPage = 0;

  final List<_SplashData> pages = [
    _SplashData(
      title: "Selamat Datang",
      subtitle: "LaPak Bantul",
      description:
          "Pusat layanan pajak terpadu Kabupaten Bantul yang cepat, mudah, dan transparan.",
      icon: Icons.account_balance_wallet_rounded,
    ),

    _SplashData(
      title: "Kelola Pajak",
      subtitle: "Dalam Satu Aplikasi",
      description:
          "Pantau pembayaran PBB, BPHTB, dan layanan pajak lainnya dengan mudah.",
      icon: Icons.receipt_long_rounded,
    ),

    _SplashData(
      title: "Layanan Keliling",
      subtitle: "Siap Membantu Anda",
      description:
          "Cek jadwal layanan pajak keliling secara realtime langsung dari aplikasi.",
      icon: Icons.local_shipping_rounded,
    ),
  ];

  void nextPage() {
    if (_currentPage < pages.length - 1) {
      _controller.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const LoginPage(),
        ),
      );
    }
  }

  void skipPage() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => const LoginPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(

        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF0B3A66),
              Color(0xFF145DA0),
            ],
          ),
        ),

        child: SafeArea(
          child: Column(
            children: [

              // TOP BUTTON
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),

                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [

                    if (_currentPage != pages.length - 1)
                      TextButton(
                        onPressed: skipPage,

                        child: const Text(
                          "Lewati",
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 16,
                          ),
                        ),
                      ),
                  ],
                ),
              ),

              // PAGEVIEW
              Expanded(
                child: PageView.builder(
                  controller: _controller,
                  itemCount: pages.length,

                  onPageChanged: (index) {
                    setState(() {
                      _currentPage = index;
                    });
                  },

                  itemBuilder: (context, index) {
                    return _SplashContent(
                      data: pages[index],
                    );
                  },
                ),
              ),

              // INDICATOR
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  pages.length,
                  (index) {
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 300),

                      margin: const EdgeInsets.symmetric(horizontal: 4),

                      width: _currentPage == index ? 26 : 8,
                      height: 8,

                      decoration: BoxDecoration(
                        color: _currentPage == index
                            ? Colors.white
                            : Colors.white38,

                        borderRadius: BorderRadius.circular(10),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 30),

              // BUTTON
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),

                child: SizedBox(
                  width: double.infinity,
                  height: 55,

                  child: ElevatedButton(
                    onPressed: nextPage,

                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,

                      foregroundColor: const Color(0xFF0B3A66),

                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),

                    child: Text(
                      _currentPage == pages.length - 1
                          ? "Mulai Sekarang"
                          : "Selanjutnya",

                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}

class _SplashData {
  final String title;
  final String subtitle;
  final String description;
  final IconData icon;

  _SplashData({
    required this.title,
    required this.subtitle,
    required this.description,
    required this.icon,
  });
}

class _SplashContent extends StatelessWidget {
  final _SplashData data;

  const _SplashContent({
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),

      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [

          // ICON CARD
          Container(
            width: 170,
            height: 170,

            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),

              borderRadius: BorderRadius.circular(40),

              border: Border.all(
                color: Colors.white24,
                width: 1.5,
              ),
            ),

            child: Icon(
              data.icon,
              size: 80,
              color: Colors.white,
            ),
          ),

          const SizedBox(height: 50),

          Text(
            data.title,

            style: const TextStyle(
              color: Colors.white70,
              fontSize: 20,
            ),
          ),

          const SizedBox(height: 8),

          Text(
            data.subtitle,
            textAlign: TextAlign.center,

            style: const TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 20),

          Text(
            data.description,
            textAlign: TextAlign.center,

            style: const TextStyle(
              color: Colors.white70,
              fontSize: 16,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}
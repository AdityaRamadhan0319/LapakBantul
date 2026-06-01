import 'package:flutter/material.dart';
import 'pbb_detail_page.dart';

class PbbResultPage extends StatelessWidget {
  const PbbResultPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: const Text("PBB"),
      ),

      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [

          _spptCard(
            context,
            "SPPT 2021",
            "DS. Ngireng-ireng RT01/RW01",
            "200,000",
            "Belum Lunas",
            Colors.red,
          ),

          const SizedBox(height: 20),

          _spptCard(
            context,
            "SPPT 2020",
            "DS. Ngireng-ireng RT01/RW01",
            "376,000",
            "Lunas",
            Colors.green,
          ),

        ],
      ),
    );
  }

  Widget _spptCard(BuildContext context, String title, String alamat,
      String harga, String status, Color warna) {
    return InkWell(

      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const PbbDetailPage(),
          ),
        );
      },

      child: Container(
        padding: const EdgeInsets.all(16),

        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade300,
              blurRadius: 10,
            )
          ],
        ),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [

                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: warna,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    status,
                    style: const TextStyle(color: Colors.white),
                  ),
                )
              ],
            ),

            const SizedBox(height: 10),

            Text(alamat),

            const SizedBox(height: 10),

            Text("NJOP Bumi dan Bangunan  $harga"),

            const SizedBox(height: 10),

            const Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text("Lihat Detail"),
                Icon(Icons.arrow_forward_ios, size: 14)
              ],
            )
          ],
        ),
      ),
    );
  }
}
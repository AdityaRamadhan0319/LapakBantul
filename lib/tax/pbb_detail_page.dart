import 'package:flutter/material.dart';

class PbbDetailPage extends StatelessWidget {
  const PbbDetailPage({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(),

      body: ListView(
        padding: const EdgeInsets.all(20),
        children: const [

          Text(
            "AHMAD NABIL BAHROIN ROGER SUMATRA",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),

          SizedBox(height: 20),

          Text("Lokasi"),
          Text("DS. Ngireng-ireng, RT01/RW01"),

          Divider(),

          Text("Status"),
          Text("Sudah Lunas"),

          Divider(),

          Text("NJOP Bumi"),
          Text("Rp. 300,000"),

          Divider(),

          Text("NJOP Bangunan"),
          Text("Rp. 0"),

          Divider(),

          Text("Luas Bumi"),
          Text("227m"),
        ],
      ),
    );
  }
}
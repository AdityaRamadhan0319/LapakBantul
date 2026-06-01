import 'package:flutter/material.dart';

class LayananKelilingPage extends StatefulWidget {
  const LayananKelilingPage({super.key});

  @override
  State<LayananKelilingPage> createState() => _LayananKelilingPageState();
}

class _LayananKelilingPageState extends State<LayananKelilingPage> {

  int selectedDate = 0;

  List<String> dates = [
    "21/01/2024",
    "25/01/2024",
    "28/01/2024",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F8),

      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        title: const Text(
          "Layanan Keliling",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // DATE SELECTOR
            SizedBox(
              height: 45,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: dates.length,
                itemBuilder: (context, index) {

                  bool active = selectedDate == index;

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedDate = index;
                      });
                    },

                    child: Container(
                      margin: const EdgeInsets.only(right: 10),
                      padding: const EdgeInsets.symmetric(horizontal: 16),

                      decoration: BoxDecoration(
                        color: active
                            ? const Color(0xFF1F3B63)
                            : const Color(0xFFE3E7EC),
                        borderRadius: BorderRadius.circular(10),
                      ),

                      child: Row(
                        children: [

                          Icon(
                            Icons.calendar_month,
                            size: 18,
                            color: active
                                ? Colors.white
                                : Colors.black54,
                          ),

                          const SizedBox(width: 6),

                          Text(
                            dates[index],
                            style: TextStyle(
                              color: active
                                  ? Colors.white
                                  : Colors.black87,
                              fontWeight: FontWeight.w500,
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 20),

            Text(
              "Hari ini, ${dates[selectedDate]}",
              style: const TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),

            const SizedBox(height: 15),

            // JADWAL BERUBAH SESUAI TANGGAL
            ..._jadwalMobil()

          ],
        ),
      ),
    );
  }

  // DATA JADWAL
  List<Widget> _jadwalMobil() {

    if (selectedDate == 0) {
      return [
        _mobilCard("Mobil 01", "Mangir lor & Manager tengah, sendang", "08:00 - 16:00"),
        const SizedBox(height: 15),
        _mobilCard("Mobil 02", "Mangir lor & Manager tengah, sendang", "08:00 - 16:00"),
      ];
    }

    if (selectedDate == 1) {
      return [
        _mobilCard("Mobil 01", "Kasihan & Bangunjiwo", "08:00 - 16:00"),
      ];
    }

    if (selectedDate == 2) {
      return [
        _mobilCard("Mobil 02", "Sewon & Panggungharjo", "08:00 - 16:00"),
      ];
    }

    return [];
  }

  // CARD MOBIL
  Widget _mobilCard(String title, String lokasi, String jam) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: const Offset(0, 3),
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
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),

              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFF1F4E8C),
                  borderRadius: BorderRadius.circular(20),
                ),

                child: Text(
                  jam,
                  style: const TextStyle(color: Colors.white),
                ),
              )
            ],
          ),

          const SizedBox(height: 12),

          Row(
            children: [

              const Icon(
                Icons.location_on_outlined,
                size: 18,
                color: Colors.grey,
              ),

              const SizedBox(width: 6),

              Expanded(
                child: Text(
                  lokasi,
                  style: const TextStyle(
                    color: Colors.black54,
                    fontSize: 15,
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
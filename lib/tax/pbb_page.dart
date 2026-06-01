import 'package:flutter/material.dart';
import 'pbb_result_page.dart';

class PbbPage extends StatelessWidget {
  const PbbPage({super.key});

  @override
  Widget build(BuildContext context) {

    TextEditingController nopController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text("PBB"),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(
          children: [

            TextField(
              controller: nopController,
              decoration: InputDecoration(
                hintText: "Masukan NOP...",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),

            const SizedBox(height: 40),

            ElevatedButton(
              onPressed: () {

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PbbResultPage(),
                  ),
                );

              },
              child: const Text("Cari"),
            )

          ],
        ),
      ),
    );
  }
}
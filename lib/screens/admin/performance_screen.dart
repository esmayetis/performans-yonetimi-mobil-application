import 'package:flutter/material.dart';

class AdminPerformanceScreen extends StatelessWidget {
  const AdminPerformanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> performansListesi = [
      {
        "name": "Ayşe Yılmaz",
        "ortalamaPuan": 4.3,
        "tamamlanan": 5,
      },
      {
        "name": "Ali Çalışkan",
        "ortalamaPuan": 3.8,
        "tamamlanan": 4,
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Performans Özeti"),
        backgroundColor: const Color(0xFF3F3056),
      ),
      body: ListView.builder(
        itemCount: performansListesi.length,
        itemBuilder: (context, index) {
          final calisan = performansListesi[index];
          return ListTile(
            title: Text(calisan['name']),
            subtitle: Text("Ortalama Puan: ${calisan['ortalamaPuan']}"),
            trailing: Text("✔ ${calisan['tamamlanan']} görev"),
          );
        },
      ),
    );
  }
}

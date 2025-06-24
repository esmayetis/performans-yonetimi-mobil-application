import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'employee_detail_screen.dart';

class AdminDashboard extends StatefulWidget {
  final String userId;

  const AdminDashboard({super.key, required this.userId});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  final TextEditingController _searchController = TextEditingController();

  List<Map<String, dynamic>> _tumCalisanlar = [];
  List<Map<String, dynamic>> _filtreliListe = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_filtrele);
    _fetchUsersFromFirestore();
  }

  Future<double> calculateUserAverage(String userId) async {
    final taskSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('tasks')
        .get();

    List<double> allScores = [];

    for (var task in taskSnapshot.docs) {
      final feedbacks = await task.reference.collection('feedbacks').get();
      final puanlar = feedbacks.docs
          .map((f) => f['puan'] as double?)
          .where((p) => p != null)
          .cast<double>()
          .toList();
      allScores.addAll(puanlar);
    }

    if (allScores.isEmpty) return 0.0;
    final ort = allScores.reduce((a, b) => a + b) / allScores.length;
    return double.parse(ort.toStringAsFixed(2));
  }

  void _fetchUsersFromFirestore() async {
    final snapshot = await FirebaseFirestore.instance.collection('users').get();

    final List<Map<String, dynamic>> loadedUsers = snapshot.docs.map((doc) {
      final data = doc.data();
      return {
        "id": doc.id,
        "name": data["name"] ?? "İsimsiz",
        "email": data["email"] ?? "",
        "birim": data["birim"] ?? "",
        "gorevSayisi": data["gorevSayisi"] ?? 0,
        "puan": data["puan"] ?? 0.0,
        "avatarUrl": data["avatarUrl"] ?? "",
        "tasks": data["tasks"] ?? [],
      };
    }).toList();

    setState(() {
      _tumCalisanlar = loadedUsers;
      _filtreliListe = loadedUsers;
      isLoading = false;
    });

    for (var i = 0; i < loadedUsers.length; i++) {
      final userId = loadedUsers[i]['id'];
      final avg = await calculateUserAverage(userId);
      setState(() {
        _filtreliListe[i]['puan'] = avg;
      });
    }
  }

  void _filtrele() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filtreliListe = _tumCalisanlar.where((kisi) {
        final ad = (kisi["name"] ?? "").toString().toLowerCase();
        return ad.contains(query);
      }).toList();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF1E3C72), Color(0xFF2A5298)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Stack(
            children: [
              Positioned(
                top: 50,
                left: 20,
                child: Text(
                  "Ekibim",
                  style: GoogleFonts.poppins(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              Positioned(
                top: 100,
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(
                  decoration: const BoxDecoration(
                    color: Color(0xFFF0F4F8),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(32),
                      topRight: Radius.circular(32),
                    ),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                  child: Column(
                    children: [
                      TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: "Çalışan ara...",
                          hintStyle:
                              GoogleFonts.poppins(color: Colors.grey[500]),
                          prefixIcon: const Icon(Icons.search),
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding:
                              const EdgeInsets.symmetric(vertical: 14),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                      Expanded(
                        child: isLoading
                            ? const Center(child: CircularProgressIndicator())
                            : ListView.builder(
                                itemCount: _filtreliListe.length,
                                itemBuilder: (context, index) {
                                  final kisi = _filtreliListe[index];
                                  final double puan =
                                      (kisi['puan'] as double?) ?? 0.0;

                                  return Card(
                                    color: Colors.white,
                                    elevation: 4,
                                    shadowColor: Colors.black12,
                                    margin:
                                        const EdgeInsets.symmetric(vertical: 8),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: ListTile(
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              horizontal: 16, vertical: 12),
                                      leading: CircleAvatar(
                                        radius: 24,
                                        backgroundColor: Colors.grey.shade300,
                                        backgroundImage: kisi['avatarUrl'] !=
                                                    null &&
                                                (kisi['avatarUrl'] as String)
                                                    .isNotEmpty
                                            ? NetworkImage(kisi['avatarUrl'])
                                            : null,
                                        child: kisi['avatarUrl'] == null ||
                                                (kisi['avatarUrl'] as String)
                                                    .isEmpty
                                            ? const Icon(Icons.person,
                                                color: Colors.white)
                                            : null,
                                      ),
                                      title: Text(
                                        kisi["name"] ?? "İsimsiz",
                                        style: GoogleFonts.poppins(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      subtitle: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const SizedBox(height: 4),
                                          Text(
                                            kisi["birim"] ?? "",
                                            style: GoogleFonts.poppins(
                                              fontSize: 14,
                                              color: Colors.grey[800],
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            "${kisi['gorevSayisi']} görev | Ortalama puan: ${puan.toStringAsFixed(2)}",
                                            style: GoogleFonts.poppins(
                                              fontSize: 12,
                                              color: Colors.grey[600],
                                            ),
                                          ),
                                        ],
                                      ),
                                      trailing: const Icon(
                                          Icons.arrow_forward_ios_rounded,
                                          size: 16),
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                EmployeeDetailScreen(
                                              user: kisi,
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  );
                                },
                              ),
                      ),
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
}

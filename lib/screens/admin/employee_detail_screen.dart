import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobil_app/screens/admin/task_review_screen.dart';

class EmployeeDetailScreen extends StatefulWidget {
  final Map<String, dynamic> user;

  const EmployeeDetailScreen({super.key, required this.user});

  @override
  State<EmployeeDetailScreen> createState() => _EmployeeDetailScreenState();
}

class _EmployeeDetailScreenState extends State<EmployeeDetailScreen> {
  List<Map<String, dynamic>> tasks = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchTasks();
  }

  Future<void> _fetchTasks() async {
    final userId = widget.user['id'];
    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('tasks')
        .get();

    final List<Map<String, dynamic>> loadedTasks =
        await Future.wait(snapshot.docs.map((doc) async {
      final data = doc.data();
      final feedbacks = await doc.reference.collection('feedbacks').get();
      final toplam = feedbacks.size;
      final puanlar =
          feedbacks.docs.map((f) => f['puan'] as num? ?? 0).toList();
      final ortPuan = puanlar.isEmpty
          ? 0.0
          : puanlar.reduce((a, b) => a + b) / puanlar.length;

      final String hex = data['colorHex'] ?? '#FFFFFF';
      final Color color = _parseColorFromHex(hex);

      return {
        'id': doc.id,
        'title': data['title'] ?? '',
        'description': data['description'] ?? '',
        'puan': ortPuan,
        'feedbackCount': toplam,
        'color': color,
      };
    }));

    setState(() {
      tasks = loadedTasks;
      isLoading = false;
    });
  }

  Color _parseColorFromHex(String hexColor) {
    try {
      hexColor = hexColor.replaceAll('#', '');
      if (hexColor.length == 6) {
        hexColor = 'FF$hexColor';
      }
      return Color(int.parse('0x$hexColor'));
    } catch (e) {
      return Colors.white;
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = widget.user;
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xFF002D62),
        body: Stack(
          children: [
            Positioned(
              top: 60,
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                decoration: const BoxDecoration(
                  color: Color(0xFFF5F8FA),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(32),
                    topRight: Radius.circular(32),
                  ),
                ),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 30,
                              backgroundColor: Colors.grey.shade300,
                              backgroundImage: user['avatarUrl'] != null &&
                                      user['avatarUrl'].toString().isNotEmpty
                                  ? NetworkImage(user['avatarUrl'])
                                  : null,
                              child: user['avatarUrl'] == null ||
                                      user['avatarUrl'].toString().isEmpty
                                  ? const Icon(Icons.person,
                                      color: Colors.white)
                                  : null,
                            ),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(user['name'] ?? '',
                                    style: GoogleFonts.poppins(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold)),
                                Text(user['birim'] ?? '',
                                    style: GoogleFonts.poppins(fontSize: 14)),
                                Text(user['email'] ?? '',
                                    style: GoogleFonts.poppins(fontSize: 12)),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text("Görevler",
                        style: GoogleFonts.poppins(
                            fontSize: 16, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 10),
                    isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : Expanded(
                            child: tasks.isEmpty
                                ? Text("Bu çalışana ait görev bulunmamaktadır.",
                                    style: GoogleFonts.poppins())
                                : ListView.builder(
                                    itemCount: tasks.length,
                                    itemBuilder: (context, index) {
                                      final task = tasks[index];
                                      final puanOrani =
                                          (task['puan'] ?? 0.0) / 5.0;
                                      final renk =
                                          task['color'] ?? Colors.white;

                                      return Container(
                                        margin: const EdgeInsets.symmetric(
                                            vertical: 8),
                                        padding: const EdgeInsets.all(16),
                                        decoration: BoxDecoration(
                                          color: renk,
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              task['title'] ?? '',
                                              style: GoogleFonts.poppins(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            const SizedBox(height: 8),
                                            Text(
                                              "${task['feedbackCount']} değerlendirme yapıldı",
                                              style: GoogleFonts.poppins(
                                                  fontSize: 13),
                                            ),
                                            const SizedBox(height: 12),
                                            Stack(
                                              children: [
                                                Container(
                                                  height: 6,
                                                  decoration: BoxDecoration(
                                                    color: Colors.black12,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            3),
                                                  ),
                                                ),
                                                Container(
                                                  height: 6,
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.75 *
                                                      (puanOrani > 1
                                                          ? 1
                                                          : puanOrani),
                                                  decoration: BoxDecoration(
                                                    color: Colors.indigo,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            3),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 6),
                                            Text(
                                              "Ortalama Puan: ${task['puan'].toStringAsFixed(2)}",
                                              style: GoogleFonts.poppins(
                                                fontSize: 13,
                                                color: Colors.black87,
                                              ),
                                            ),
                                            Align(
                                              alignment: Alignment.centerRight,
                                              child: IconButton(
                                                icon: const Icon(
                                                    Icons
                                                        .arrow_forward_ios_rounded,
                                                    size: 16),
                                                onPressed: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          TaskReviewScreen(
                                                        user: user,
                                                        task: task,
                                                      ),
                                                    ),
                                                  );
                                                },
                                              ),
                                            )
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                          ),
                  ],
                ),
              ),
            ),
            Positioned(
              top: 15,
              left: 10,
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Çalışan Detayı',
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

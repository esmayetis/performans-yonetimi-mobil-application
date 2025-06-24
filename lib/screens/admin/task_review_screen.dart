import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';

class TaskReviewScreen extends StatefulWidget {
  final Map<String, dynamic> user;
  final Map<String, dynamic> task;

  const TaskReviewScreen({super.key, required this.user, required this.task});

  @override
  State<TaskReviewScreen> createState() => _TaskReviewScreenState();
}

class _TaskReviewScreenState extends State<TaskReviewScreen> {
  double rating = 0.0;
  final TextEditingController _yorumController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final user = widget.user;
    final task = widget.task;

    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xFF002D62),
        body: Column(
          children: [
            const SizedBox(height: 40),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    "Görev Değerlendirme",
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                decoration: const BoxDecoration(
                  color: Color(0xFFF5F8FA),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(32),
                    topRight: Radius.circular(32),
                  ),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 28,
                            backgroundColor: Colors.grey[300],
                            backgroundImage: user['avatarUrl'] != null &&
                                    user['avatarUrl'].toString().isNotEmpty
                                ? NetworkImage(user['avatarUrl'])
                                : null,
                            child: user['avatarUrl'] == null ||
                                    user['avatarUrl'].toString().isEmpty
                                ? const Icon(Icons.person, color: Colors.white)
                                : null,
                          ),
                          const SizedBox(width: 16),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(user['name'] ?? '-',
                                  style: GoogleFonts.poppins(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600)),
                              Text(user['birim'] ?? '-',
                                  style: GoogleFonts.poppins(
                                      fontSize: 14, color: Colors.grey[600])),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      Text("Görev",
                          style: GoogleFonts.poppins(
                              fontSize: 16, fontWeight: FontWeight.w600)),
                      const SizedBox(height: 8),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF0F2F5),
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(task['title'] ?? '-',
                                style: GoogleFonts.poppins(
                                    fontSize: 15, fontWeight: FontWeight.w600)),
                            const SizedBox(height: 6),
                            Text(task['description'] ?? '-',
                                style: GoogleFonts.poppins(
                                    fontSize: 14, color: Colors.grey[700])),
                          ],
                        ),
                      ),
                      const SizedBox(height: 32),
                      Text("Puan Ver",
                          style: GoogleFonts.poppins(
                              fontSize: 16, fontWeight: FontWeight.w600)),
                      const SizedBox(height: 12),
                      Center(
                        child: RatingBar.builder(
                          initialRating: 0,
                          minRating: 1,
                          direction: Axis.horizontal,
                          allowHalfRating: true,
                          itemCount: 5,
                          unratedColor: Colors.grey[300],
                          itemPadding:
                              const EdgeInsets.symmetric(horizontal: 4.0),
                          itemBuilder: (context, _) =>
                              const Icon(Icons.star, color: Colors.amber),
                          onRatingUpdate: (value) {
                            setState(() {
                              rating = value;
                            });
                          },
                        ),
                      ),
                      const SizedBox(height: 32),
                      Text("Yorum",
                          style: GoogleFonts.poppins(
                              fontSize: 16, fontWeight: FontWeight.w600)),
                      const SizedBox(height: 12),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.05),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: TextField(
                          controller: _yorumController,
                          maxLines: 5,
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.all(16),
                            hintText: "Yorumunuzu buraya yazın...",
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      const SizedBox(height: 36),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () => Navigator.pop(context),
                              style: OutlinedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                side:
                                    const BorderSide(color: Color(0xFF002D62)),
                                padding:
                                    const EdgeInsets.symmetric(vertical: 14),
                              ),
                              child: Text("İptal",
                                  style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w500,
                                      color: const Color(0xFF002D62))),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: _submitFeedback,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF002D62),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                padding:
                                    const EdgeInsets.symmetric(vertical: 14),
                              ),
                              child: Text("Gönder",
                                  style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white)),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> _submitFeedback() async {
    final user = widget.user;
    final task = widget.task;
    final taskRef = FirebaseFirestore.instance
        .collection('users')
        .doc(user['id'])
        .collection('tasks')
        .doc(task['id']);

    try {
      await taskRef.collection('feedbacks').add({
        'puan': rating,
        'yorum': _yorumController.text.trim(),
        'tarih': Timestamp.now(),
      });

      final feedbacksSnapshot = await taskRef.collection('feedbacks').get();
      final puanlar =
          feedbacksSnapshot.docs.map((doc) => doc['puan'] as double).toList();
      final double ortalama = puanlar.reduce((a, b) => a + b) / puanlar.length;

      await taskRef.update({
        'puan': ortalama,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("Geri bildirim kaydedildi ve ortalama güncellendi.")),
      );

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Hata: ${e.toString()}")),
      );
    }
  }
}

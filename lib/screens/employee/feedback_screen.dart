import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// Örnek rozet ikonları ve motivasyon mesajları için varsayılanlar
final List<Map<String, dynamic>> badges = [
  {
    'name': "Teslimat Şampiyonu",
    'icon': Icons.emoji_events,
    'color': Colors.amber
  },
  {
    'name': "Yılın Çalışanı",
    'icon': Icons.military_tech,
    'color': Colors.lightBlue
  },
];

class FeedbacksScreen extends StatefulWidget {
  final String userId;
  const FeedbacksScreen({super.key, required this.userId});

  @override
  State<FeedbacksScreen> createState() => _FeedbacksScreenState();
}

class _FeedbacksScreenState extends State<FeedbacksScreen> {
  Map<String, List<Map<String, dynamic>>> _feedbacksByTask = {};
  bool _isLoading = true;
  double _averageScore = 0;
  int _totalFeedbacks = 0;
  String _lastFeedbackDate = '-';

  @override
  void initState() {
    super.initState();
    _fetchAllFeedbacks();
  }

  Future<void> _fetchAllFeedbacks() async {
    final taskSnapshots = await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.userId)
        .collection('tasks')
        .get();

    Map<String, List<Map<String, dynamic>>> grouped = {};
    List<double> allScores = [];
    DateTime? lastDate;

    for (var taskDoc in taskSnapshots.docs) {
      final taskTitle = taskDoc['title'] ?? 'Görev';
      final feedbackSnapshots =
          await taskDoc.reference.collection('feedbacks').get();

      for (var fb in feedbackSnapshots.docs) {
        final feedback = fb.data();
        feedback['tarih_raw'] = feedback['tarih'];
        feedback['tarih'] = _formatTimestamp(feedback['tarih']);
        grouped.putIfAbsent(taskTitle, () => []).add(feedback);

        // Ortalama ve son tarih için
        if (feedback['puan'] != null) {
          try {
            allScores.add(double.parse(feedback['puan'].toString()));
          } catch (_) {}
        }
        if (feedback['tarih_raw'] != null) {
          try {
            DateTime d = feedback['tarih_raw'] is DateTime
                ? feedback['tarih_raw']
                : feedback['tarih_raw'].toDate();
            if (lastDate == null || d.isAfter(lastDate)) {
              lastDate = d;
            }
          } catch (_) {}
        }
      }
    }

    setState(() {
      _feedbacksByTask = grouped;
      _isLoading = false;
      _totalFeedbacks = allScores.length;
      _averageScore = allScores.isEmpty
          ? 0
          : allScores.reduce((a, b) => a + b) / allScores.length;
      _lastFeedbackDate =
          lastDate == null ? '-' : DateFormat('dd.MM.yyyy').format(lastDate);
    });
  }

  String _formatTimestamp(dynamic tarih) {
    if (tarih == null) return '-';
    try {
      DateTime dt = tarih is DateTime ? tarih : tarih.toDate();
      return DateFormat('dd.MM.yyyy – HH:mm').format(dt);
    } catch (e) {
      return tarih.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        iconTheme: const IconThemeData(color: Color(0xFF1A237E)),
        title: Row(
          children: [
            const Text(
              'Geri Bildirimlerim',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1A237E),
                  fontSize: 22),
            ),
            const SizedBox(width: 8),
            Tooltip(
              message:
                  'Buradan geri bildirimlerin özetini ve detaylarını görebilirsin.',
              child: Icon(Icons.info_outline,
                  color: Colors.blueGrey[400], size: 20),
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          // Arka plan görseli ve buz efekti
          Positioned.fill(
            child: Image.asset(
              'assets/images/kaan_ucak.webp',
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(
            child: Container(
              color: Colors.white.withOpacity(0.65),
            ),
          ),
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
              child: Container(color: Colors.transparent),
            ),
          ),
          // Asıl içerik
          SafeArea(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Özet Panel
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 18, vertical: 18),
                        child: Container(
                          padding: const EdgeInsets.all(18),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.93),
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.blueGrey.withOpacity(0.08),
                                blurRadius: 18,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              _SummaryItem(
                                  label: "Ortalama",
                                  value: _averageScore.toStringAsFixed(2),
                                  icon: Icons.star_rounded,
                                  color: Colors.amber[800]),
                              _SummaryItem(
                                  label: "Toplam",
                                  value: _totalFeedbacks.toString(),
                                  icon: Icons.assignment_turned_in_rounded,
                                  color: Colors.blue[700]),
                              _SummaryItem(
                                  label: "Son Tarih",
                                  value: _lastFeedbackDate,
                                  icon: Icons.calendar_today,
                                  color: Colors.green[700]),
                            ],
                          ),
                        ),
                      ),
                      // Rozet Alanı (isteğe bağlı)
                      if (badges.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 18, vertical: 2),
                          child: Row(
                            children: badges.map((b) {
                              return Padding(
                                padding: const EdgeInsets.only(right: 10),
                                child: Chip(
                                  avatar: Icon(b['icon'],
                                      color: b['color'], size: 18),
                                  label: Text(b['name'],
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w600)),
                                  backgroundColor: Colors.white,
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      // Hedefler ve Motivasyon (isteğe bağlı)
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 18, vertical: 6),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 16),
                          decoration: BoxDecoration(
                            color: Colors.indigo.withOpacity(0.07),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: const [
                              Icon(Icons.rocket_launch,
                                  color: Colors.indigo, size: 24),
                              SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  'Tebrikler! Gelişiminiz başarıyla devam ediyor. Hedeflerinizi güncelleyebilirsiniz.',
                                  style: TextStyle(
                                      fontSize: 15, color: Color(0xFF1A237E)),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      // Feedback Kartları
                      Expanded(
                        child: _feedbacksByTask.isEmpty
                            ? Center(
                                child: Text(
                                  'Henüz geri bildiriminiz yok.',
                                  style: TextStyle(
                                      color: Colors.indigo[900],
                                      fontWeight: FontWeight.w600),
                                ),
                              )
                            : ListView(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10),
                                children: _feedbacksByTask.entries.map((entry) {
                                  final taskTitle = entry.key;
                                  final feedbacks = entry.value;
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 14, vertical: 7),
                                    child: Card(
                                      elevation: 6,
                                      color: Colors.white.withOpacity(0.98),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(18),
                                      ),
                                      child: Theme(
                                        data: Theme.of(context).copyWith(
                                          dividerColor: Colors.transparent,
                                        ),
                                        child: ExpansionTile(
                                          tilePadding:
                                              const EdgeInsets.symmetric(
                                                  horizontal: 18, vertical: 6),
                                          collapsedIconColor:
                                              Colors.blueGrey[400],
                                          iconColor: Colors.indigo[900],
                                          title: Text(
                                            taskTitle,
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Color(0xFF14236B),
                                                fontSize: 17),
                                          ),
                                          children: feedbacks.map((fb) {
                                            return Container(
                                              margin:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 7,
                                                      horizontal: 4),
                                              padding: const EdgeInsets.all(14),
                                              decoration: BoxDecoration(
                                                color: Colors.indigo[50],
                                                borderRadius:
                                                    BorderRadius.circular(16),
                                                boxShadow: [
                                                  BoxShadow(
                                                      color: Colors.blueGrey
                                                          .withOpacity(0.04),
                                                      blurRadius: 8,
                                                      spreadRadius: 1,
                                                      offset:
                                                          const Offset(1, 2))
                                                ],
                                              ),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Icon(Icons.star_rounded,
                                                          color:
                                                              Colors.amber[700],
                                                          size: 22),
                                                      const SizedBox(width: 6),
                                                      Text(
                                                        '${fb['puan'] ?? '-'}',
                                                        style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 16,
                                                          color:
                                                              Color(0xFF283593),
                                                        ),
                                                      ),
                                                      const Spacer(),
                                                      Text(
                                                        fb['tarih'] ?? '-',
                                                        style: TextStyle(
                                                            fontSize: 13,
                                                            color: Colors
                                                                .blueGrey[400]),
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(height: 7),
                                                  Text(
                                                    fb['yorum'] ?? '-',
                                                    style: const TextStyle(
                                                        fontSize: 15,
                                                        color:
                                                            Color(0xFF1A237E)),
                                                  ),
                                                ],
                                              ),
                                            );
                                          }).toList(),
                                        ),
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                      ),
                      // Hedef ekle veya PDF indir butonu gibi alanlar eklenecekse burada ekleyebilirsin
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}

// Küçük özet bilgi kutucuğu widget'ı
class _SummaryItem extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color? color;
  const _SummaryItem(
      {required this.label,
      required this.value,
      required this.icon,
      this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: color ?? Colors.indigo, size: 28),
        const SizedBox(height: 5),
        Text(value,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        const SizedBox(height: 2),
        Text(label, style: TextStyle(color: Colors.grey[600], fontSize: 14)),
      ],
    );
  }
}

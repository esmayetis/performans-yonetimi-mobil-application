import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobil_app/models/task.dart';
import 'package:mobil_app/ui/theme.dart';

class TaskTile extends StatelessWidget {
  final Task? task;
  final VoidCallback? onDelete;

  TaskTile(this.task, {this.onDelete, Key? key}) : super(key: key);

  // Güncel, hatasız hex'ten Color'a çeviren fonksiyon
  Color _parseColorFromHex(String? hexColor) {
    if (hexColor == null || hexColor.isEmpty) return primaryClr;
    final buffer = StringBuffer();
    if (hexColor.length == 7 && hexColor[0] == '#') {
      buffer.write('ff'); // alpha (tam opak)
      buffer.write(hexColor.substring(1));
    } else if (hexColor.length == 9 && hexColor[0] == '#') {
      buffer.write(hexColor.substring(1, 3)); // alpha
      buffer.write(hexColor.substring(3));
    } else if (hexColor.length == 6) {
      buffer.write('ff');
      buffer.write(hexColor);
    } else {
      return primaryClr;
    }
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  @override
  Widget build(BuildContext context) {
    // DEBUG için ekle: Konsolda hangi renk geliyor göreceksin
    print('KART COLORHEX: ${task?.colorHex}');
    final bgColor = _parseColorFromHex(task?.colorHex);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.only(bottom: 12),
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: bgColor,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Başlık
            Text(
              task?.title ?? "",
              style: GoogleFonts.lato(
                textStyle: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(height: 12),

            // Saat bilgisi
            Row(
              children: [
                Icon(Icons.access_time_rounded,
                    color: Colors.grey[200], size: 18),
                SizedBox(width: 4),
                Text(
                  "${task?.startTime ?? ''} - ${task?.endTime ?? ''}",
                  style: GoogleFonts.lato(
                    textStyle: TextStyle(fontSize: 13, color: Colors.grey[100]),
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),

            // Açıklama
            Text(
              task?.note ?? "",
              style: GoogleFonts.lato(
                textStyle: TextStyle(fontSize: 15, color: Colors.grey[100]),
              ),
            ),
            SizedBox(height: 16),

            // TODO yazısı ve çöp kutusu
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                RotatedBox(
                  quarterTurns: 3,
                  child: Text(
                    (task?.isCompleted ?? 0) == 1 ? "COMPLETED" : "TODO",
                    style: GoogleFonts.lato(
                      textStyle: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: IconButton(
                    icon: Icon(Icons.delete, color: Colors.white),
                    onPressed: onDelete,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

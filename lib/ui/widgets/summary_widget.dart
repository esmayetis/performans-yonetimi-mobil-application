import 'package:flutter/material.dart';
import 'package:mobil_app/ui/widgets/pie_chart_widget.dart';
import 'package:mobil_app/ui/widgets/scheduled_widget.dart';
import 'package:mobil_app/ui/widgets/side_menu_widget.dart';
import 'package:mobil_app/ui/widgets/summary_details.dart';

import '../theme.dart';

class SummaryWidget extends StatelessWidget {
  final String userId;

  const SummaryWidget({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(Icons.menu, color: Colors.white),
            onPressed: () {
              Scaffold.of(context).openDrawer(); // Doğru context kullanılıyor
            },
          ),
        ),
      ),
      drawer: Drawer(
        child: Container(
          color: Colors.white12, // Arka plan rengi
          child: SideMenuWidget(userId: userId), // userId gönderiliyor
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(5.0),
        child: Column(
          children: [
            SizedBox(height: 20),
            Chart(),
            Text(
              'Summary',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white),
            ),
            SizedBox(height: 16),
            SummaryDetails(),
            SizedBox(height: 40),
            Scheduled(),
          ],
        ),
      ),
    ));
  }
}

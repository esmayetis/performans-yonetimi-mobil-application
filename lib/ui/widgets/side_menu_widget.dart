import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mobil_app/data/side_menu_data.dart';
import 'package:mobil_app/screens/login_screen.dart';
import 'package:mobil_app/ui/home_page.dart';
import 'package:mobil_app/ui/widgets/dashboard_widget.dart';
import 'package:mobil_app/ui/widgets/summary_widget.dart';

import '../theme.dart';

class SideMenuWidget extends StatefulWidget {
  final String userId;

  const SideMenuWidget({super.key, required this.userId});

  @override
  State<SideMenuWidget> createState() => _SideMenuWidgetState();
}

class _SideMenuWidgetState extends State<SideMenuWidget> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final data = SideMenuData();

    return ListView.builder(
      padding: const EdgeInsets.only(top: 20),
      itemCount: data.menu.length,
      itemBuilder: (context, index) => buildMenuEntry(data, index),
    );
  }

  Widget buildMenuEntry(SideMenuData data, int index) {
    final isSelected = selectedIndex == index;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(6.0)),
        color: isSelected ? selectionColor : Colors.transparent,
      ),
      child: InkWell(
        onTap: () => _navigateToPage(context, index),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 13, vertical: 15),
                child: Icon(
                  data.menu[index].icon,
                  color: isSelected ? Colors.black : Colors.grey,
                ),
              ),
              Text(
                data.menu[index].title,
                style: TextStyle(
                  fontSize: 16,
                  color: isSelected ? Colors.black : Colors.grey,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _navigateToPage(BuildContext context, int index) async {
    setState(() {
      selectedIndex = index;
    });

    switch (index) {
      case 0: // Dashboard
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => DashboardWidget(userId: widget.userId),
          ),
        );
        break;

      case 1: // Profile
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => SummaryWidget(userId: widget.userId),
          ),
        );
        break;

      case 2: // Tasks
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(userId: widget.userId),
          ),
        );
        break;

      case 3: // Settings (şimdilik login sayfasına dönsün)
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const LoginScreen(),
          ),
        );
        break;

      case 4: // Sign Out
        await FirebaseAuth.instance.signOut(); // Firebase oturum kapatma
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const LoginScreen(),
          ),
        );
        break;
    }
  }
}

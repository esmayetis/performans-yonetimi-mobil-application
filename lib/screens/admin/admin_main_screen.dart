import 'package:flutter/material.dart';
import 'package:mobil_app/screens/admin/task_list_screen.dart';

import '../setting_screen.dart';
import 'dashboard_admin.dart';

class AdminMainScreen extends StatefulWidget {
  final String userId; // <--- EKLENDİ
  const AdminMainScreen({super.key, required this.userId});

  @override
  State<AdminMainScreen> createState() => _AdminMainScreenState();
}

class _AdminMainScreenState extends State<AdminMainScreen> {
  int _selectedIndex = 0;

  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    // userId'yi alt sayfalara da iletebilirsin
    _pages = [
      AdminDashboard(userId: widget.userId), //userId: widget.userId
      TaskListScreen(userId: widget.userId),
      SettingsScreen(userId: widget.userId),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: _pages[_selectedIndex],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.black,
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.group),
              label: 'Ekibim',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.task),
              label: 'Görevler',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: 'Ayarlar',
            ),
          ],
        ),
      ),
    );
  }
}

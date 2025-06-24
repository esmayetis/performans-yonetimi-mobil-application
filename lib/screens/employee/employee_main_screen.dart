import 'package:flutter/material.dart';
import 'package:mobil_app/screens/setting_screen.dart';
import 'package:mobil_app/ui/home_page.dart';

import 'feedback_screen.dart';
// Diğer sayfa importlarını ekle

class EmployeeMainScreen extends StatefulWidget {
  final String userId;

  const EmployeeMainScreen({super.key, required this.userId});

  @override
  State<EmployeeMainScreen> createState() => _EmployeeMainScreenState();
}

class _EmployeeMainScreenState extends State<EmployeeMainScreen> {
  int _selectedIndex = 0;
  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      HomePage(userId: widget.userId),
      FeedbacksScreen(userId: widget.userId),
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
          selectedItemColor: Colors.indigo,
          unselectedItemColor: Colors.grey,
          onTap: (index) => setState(() => _selectedIndex = index),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.check_circle),
              label: 'Görevlerim',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.feedback),
              label: 'Geri Bildirimler',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: 'Geri Bildirimler',
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

import '../ui/widgets/side_menu_widget.dart';

class MainScreen extends StatelessWidget {
  final String userId;

  const MainScreen({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: Builder(
            builder: (context) => IconButton(
              icon: Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer(); // Doğru context kullanılıyor
              },
            ),
          ),
        ),
        drawer: Drawer(
          child: Container(
            color: Colors.white12, // Arka plan rengi
            child: SideMenuWidget(userId: userId), //  userId gönderiliyor
          ),
        ),
      ),
    );
  }
}

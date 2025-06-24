import 'package:flutter/material.dart';
import 'package:mobil_app/models/menu_model.dart';

class SideMenuData {
  final menu = const <MenuModel>[
    MenuModel(icon: Icons.home, title: 'Dashboard'),
    MenuModel(icon: Icons.pie_chart, title: 'Task Summary'),
    MenuModel(icon: Icons.task, title: 'Tasks'),
    MenuModel(icon: Icons.settings, title: 'Settings'),
    MenuModel(icon: Icons.logout, title: 'SignOut'),
  ];
}

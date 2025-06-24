import 'package:flutter/material.dart';
import 'package:mobil_app/ui/widgets/side_menu_widget.dart';

import 'bar_graph_widget.dart';
import 'line_chart_card.dart';

class DashboardWidget extends StatelessWidget {
  final String userId;

  const DashboardWidget({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    /*  return const Column(
      children: [
        const SizedBox(height: 18),
        const HeaderWidget(),
      ],
    );
     */
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
            child: SideMenuWidget(userId: userId), // bitti
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Column(
            children: [
              const SizedBox(height: 18),
              //const HeaderWidget(),
              //const SizedBox(height: 18),
              // const ActivityDetailsCard(),
              //const SizedBox(height: 18),
              const LineChartCard(),
              const SizedBox(height: 36),
              const BarGraphCard(),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:mobil_app/ui/add_task_bar.dart';
import 'package:mobil_app/ui/theme.dart';
import 'package:mobil_app/ui/widgets/button.dart';
import 'package:mobil_app/ui/widgets/task_tile.dart';

import '../controllers/task_controller.dart';
import '../models/task.dart';

class HomePage extends StatefulWidget {
  final String userId;

  const HomePage({super.key, required this.userId});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DateTime _selectedDate = DateTime.now();
  final _taskController = Get.put(TaskController());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: context.theme.scaffoldBackgroundColor,
        body: Column(
          children: [
            SizedBox(height: 20),
            _addTaskBar(),
            _addDateBar(),
            SizedBox(height: 10),
            _showTasks(),
          ],
        ),
      ),
    );
  }

  // GÖREVLERİ LİSTELEYEN ALAN
  Widget _showTasks() {
    return Expanded(
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(widget.userId)
            .collection('tasks')
            .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text("Henüz görev eklenmemiş."));
          }

          final tasks = snapshot.data!.docs;

          return ListView.builder(
            itemCount: tasks.length,
            itemBuilder: (context, index) {
              final task = tasks[index].data() as Map<String, dynamic>;

              return AnimationConfiguration.staggeredList(
                position: index,
                child: SlideAnimation(
                  child: FadeInAnimation(
                    child: TaskTile(
                      Task(
                        title: task['title'] ?? '',
                        note: task['note'] ?? '',
                        date: task['date'] ?? '',
                        startTime: task['startTime'] ?? '',
                        endTime: task['endTime'] ?? '',
                        remind: task['remind'] ?? 0,
                        repeat: task['repeat'] ?? '',
                        color: task['color'] is int
                            ? task['color']
                            : int.tryParse(task['color'].toString()) ?? 0,
                        isCompleted: task['isCompleted'] ?? 0,
                        colorHex: task['colorHex'] ?? "",
                      ),
                      onDelete: () async {
                        await FirebaseFirestore.instance
                            .collection('users')
                            .doc(widget.userId)
                            .collection('tasks')
                            .doc(tasks[index].id) // Firestore task id
                            .delete();
                      },
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  // TARİH SEÇİCİ ALANI
  Widget _addDateBar() {
    return Container(
      margin: const EdgeInsets.only(top: 20, left: 20),
      child: DatePicker(
        DateTime.now(),
        height: 100,
        width: 80,
        initialSelectedDate: DateTime.now(),
        selectionColor: primaryClr,
        selectedTextColor: Colors.white,
        dateTextStyle: GoogleFonts.lato(
          textStyle: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.grey,
          ),
        ),
        dayTextStyle: GoogleFonts.lato(
          textStyle: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.grey,
          ),
        ),
        monthTextStyle: GoogleFonts.lato(
          textStyle: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.grey,
          ),
        ),
        onDateChange: (date) {
          _selectedDate = date;
        },
      ),
    );
  }

  // ÜST BAR (Add Task + Tarih)
  Widget _addTaskBar() {
    return Container(
      margin: const EdgeInsets.only(left: 20, right: 20, top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                DateFormat.yMMMMd().format(DateTime.now()),
                style: subHeadingStyle,
              ),
              Text("Today", style: headingStyle),
            ],
          ),
          MyButton(
            label: "+ Add Task",
            onTap: () async {
              await Get.to(() => AddTaskPage(userId: widget.userId));
              _taskController.getTasks(); // Geri gelince görevleri güncelle
            },
          ),
        ],
      ),
    );
  }
}

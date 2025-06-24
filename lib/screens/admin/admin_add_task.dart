import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mobil_app/ui/theme.dart';
import 'package:mobil_app/ui/widgets/button.dart';
import 'package:mobil_app/ui/widgets/input_field.dart';

class AdminAddTaskPage extends StatefulWidget {
  final String userId; // Atanacak çalışanın userId'si
  const AdminAddTaskPage({super.key, required this.userId});

  @override
  State<AdminAddTaskPage> createState() => _AdminAddTaskPageState();
}

class _AdminAddTaskPageState extends State<AdminAddTaskPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  String _endTime = "9:30 PM";
  String _startTime = DateFormat("hh:mm a").format(DateTime.now()).toString();
  int _selectedRemind = 5;
  List<int> remindList = [5, 10, 15, 20];
  String _selectedRepeat = "None";
  List<String> repeatList = ["None", "Daily", "Weekly", "Monthly"];
  int _selectedColor = 0;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: context.theme.scaffoldBackgroundColor,
        appBar: _appBar(context),
        body: Container(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Görev Ekle", style: headingStyle),
                MyInputField(
                  title: "Baslık",
                  hint: "Baslık giriniz",
                  controller: _titleController,
                ),
                MyInputField(
                  title: "Açıklama",
                  hint: "Açıklama giriniz",
                  controller: _noteController,
                ),
                MyInputField(
                  title: "Tarih",
                  hint: DateFormat.yMd().format(_selectedDate),
                  widget: IconButton(
                    icon:
                        Icon(Icons.calendar_today_outlined, color: Colors.grey),
                    onPressed: _getDateFromUser,
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: MyInputField(
                        title: "Baslangıç",
                        hint: _startTime,
                        widget: IconButton(
                          onPressed: () => _getTimeFromUser(isStartTime: true),
                          icon: Icon(Icons.access_time_rounded,
                              color: Colors.grey),
                        ),
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: MyInputField(
                        title: "Bitis",
                        hint: _endTime,
                        widget: IconButton(
                          onPressed: () => _getTimeFromUser(isStartTime: false),
                          icon: Icon(Icons.access_time_rounded,
                              color: Colors.grey),
                        ),
                      ),
                    ),
                  ],
                ),
                MyInputField(
                  title: "Hatırlatma",
                  hint: "$_selectedRemind dakika önce",
                  widget: DropdownButton(
                    icon: Icon(Icons.keyboard_arrow_down, color: Colors.grey),
                    iconSize: 32,
                    elevation: 4,
                    style: subTitleStyle,
                    underline: Container(height: 0),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedRemind = int.parse(newValue!);
                      });
                    },
                    items: remindList.map((value) {
                      return DropdownMenuItem(
                        value: value.toString(),
                        child: Text(value.toString()),
                      );
                    }).toList(),
                  ),
                ),
                MyInputField(
                  title: "Tekrar",
                  hint: _selectedRepeat,
                  widget: DropdownButton(
                    icon: Icon(Icons.keyboard_arrow_down, color: Colors.grey),
                    iconSize: 32,
                    elevation: 4,
                    style: subTitleStyle,
                    underline: Container(height: 0),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedRepeat = newValue!;
                      });
                    },
                    items: repeatList.map((value) {
                      return DropdownMenuItem(
                        value: value,
                        child:
                            Text(value, style: TextStyle(color: Colors.grey)),
                      );
                    }).toList(),
                  ),
                ),
                SizedBox(height: 18),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _colorPallete(),
                    MyButton(label: "Görevi Oluştur", onTap: _validateAndAdd),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _validateAndAdd() {
    if (_titleController.text.isNotEmpty && _noteController.text.isNotEmpty) {
      _addTaskToDb();
      Get.back();
    } else {
      Get.snackbar(
        "Zorunlu Alan",
        "Tüm alanları doldurunuz!",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.white,
        colorText: pinkClr,
        icon: Icon(Icons.warning_amber_rounded, color: Colors.red),
      );
    }
  }

  void _addTaskToDb() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.userId)
        .collection('tasks')
        .add({
      'title': _titleController.text,
      'note': _noteController.text,
      'date': DateFormat.yMd().format(_selectedDate),
      'startTime': _startTime,
      'endTime': _endTime,
      'remind': _selectedRemind,
      'repeat': _selectedRepeat,
      'color': _selectedColor,
      'isCompleted': 0,
      'createdAt': DateTime.now(),
    });
  }

  Widget _colorPallete() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Renk", style: titleStyle),
        SizedBox(height: 8.0),
        Wrap(
          children: List<Widget>.generate(3, (int index) {
            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedColor = index;
                });
              },
              child: Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: CircleAvatar(
                  radius: 14,
                  backgroundColor: index == 0
                      ? primaryClr
                      : index == 1
                          ? pinkClr
                          : yellowClr,
                  child: _selectedColor == index
                      ? Icon(Icons.done, color: Colors.white, size: 16)
                      : null,
                ),
              ),
            );
          }),
        )
      ],
    );
  }

  PreferredSizeWidget _appBar(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: context.theme.scaffoldBackgroundColor,
      leading: GestureDetector(
        onTap: () => Navigator.pop(context),
        child: Icon(
          Icons.arrow_back_ios,
          size: 20,
          color: Get.isDarkMode ? Colors.white : Colors.black,
        ),
      ),
      actions: const [Icon(Icons.person, size: 24), SizedBox(width: 20)],
    );
  }

  void _getDateFromUser() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2080),
    );
    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  void _getTimeFromUser({required bool isStartTime}) async {
    TimeOfDay? pickedTime = await _showTimePicker();
    if (pickedTime != null) {
      String formattedTime = pickedTime.format(context);
      setState(() {
        if (isStartTime) {
          _startTime = formattedTime;
        } else {
          _endTime = formattedTime;
        }
      });
    }
  }

  Future<TimeOfDay?> _showTimePicker() {
    return showTimePicker(
      initialEntryMode: TimePickerEntryMode.input,
      context: context,
      initialTime: TimeOfDay(
        hour: int.parse(_startTime.split(":")[0]),
        minute: int.parse(_startTime.split(":")[1].split(" ")[0]),
      ),
    );
  }
}

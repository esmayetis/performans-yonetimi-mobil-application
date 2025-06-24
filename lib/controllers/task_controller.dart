import 'package:get/get.dart';
import 'package:mobil_app/db/db_helper.dart';

import '../models/task.dart';

class TaskController extends GetxController {
  // Uygulama başladığında görevleri çek
  @override
  void onReady() {
    super.onReady();
    getTasks();
  }

  // RxList ile görev listesi reaktif hale getirildi
  var taskList = <Task>[].obs;

  /// Yeni görev ekle
  Future<int> addTask({Task? task}) async {
    final result = await DBHelper.insert(task);
    getTasks(); // Listeyi güncelle
    return result;
  }

  /// Görev silme işlemi
  Future<int> deleteTask(Task task) async {
    final result = await DBHelper.delete(task);
    getTasks(); // Listeyi güncelle
    return result;
  }

  /// Veritabanından görevleri çek ve taskList'e ata
  void getTasks() async {
    final tasks = await DBHelper.query();
    taskList.assignAll(tasks.map((data) => Task.fromJson(data)).toList());
  }
}

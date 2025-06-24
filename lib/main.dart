import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mobil_app/controllers/task_controller.dart';
import 'package:mobil_app/db/db_helper.dart';
import 'package:mobil_app/screens/login_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Firebase başlatılıyor
  await DBHelper.initDb(); // SQLite veritabanı (eğer aktif kullanıyorsan)
  await GetStorage.init(); // GetStorage başlatılıyor
  Get.put(TaskController()); // TaskController global olarak başlatılıyor
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: const LoginScreen(), // Başlangıç ekranı: Giriş ekranı
    );
  }
}

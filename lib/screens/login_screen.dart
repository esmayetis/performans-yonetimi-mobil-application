import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mobil_app/components/rounded_button.dart';
import 'package:mobil_app/components/rounded_input_field.dart';
import 'package:mobil_app/constant/app_text_style.dart';
import 'package:mobil_app/screens/register_screen.dart';

import 'admin/admin_main_screen.dart';
import 'employee/employee_main_screen.dart';
import 'forgot_password_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreensState();
}

class _LoginScreensState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void _login() async {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    try {
      // Firebase Authentication ile giriş yap
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      // Firestore'da email'e göre kullanıcıyı bul
      final userQuery = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: email)
          .limit(1)
          .get();

      if (userQuery.docs.isNotEmpty) {
        final userDoc = userQuery.docs.first;
        final userId = userDoc.id;
        final role = userDoc['role'] ?? 'employee';

        if (role == 'admin') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  AdminMainScreen(userId: userId), // Admin için ana ekran
            ),
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  EmployeeMainScreen(userId: userId), // Çalışan için ana ekran
            ),
          );
        }
      } else {
        // Email Auth'da var ama Firestore'da kullanıcı yok
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Firestore'da kullanıcı bulunamadı.")),
        );
      }
    } catch (e) {
      print("Login error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Giriş başarısız: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: Container(
          width: screenSize.width,
          height: screenSize.height,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/kaan_ucak.webp'),
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(
                Colors.black.withOpacity(0.5),
                BlendMode.darken,
              ),
            ),
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 30, right: 20),
                  child: Align(
                    alignment: Alignment.topRight,
                    child: Image.asset("assets/images/tusas_logo_vector.png",
                        width: 50),
                  ),
                ),
                SizedBox(height: 150),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      margin: EdgeInsets.all(5),
                      padding: EdgeInsets.all(20),
                      //height: 320,
                      width: 350,
                      decoration: BoxDecoration(
                        color: Colors.white70,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        children: [
                          RoundedInputField(
                            controller: emailController,
                            isEmail: true,
                            isPassword: false,
                            hintText: "E-posta",
                            icon: Icons.mail,
                            onChange: (value) {},
                          ),
                          RoundedInputField(
                            controller: passwordController,
                            isEmail: false,
                            isPassword: true,
                            hintText: "Şifre",
                            icon: Icons.lock,
                            onChange: (value) {},
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ForgotPasswordScreen(),
                                ),
                              );
                            },
                            child: Text(
                              "Şifremi Unuttum ? ",
                              style: AppTextStyle.MINI_BOLD_DESCRIPION_TEXT,
                            ),
                          ),
                          RoundedButton(
                            text: "GİRİŞ YAP",
                            press: _login,
                            color: Color(0xFF3F3056),
                          ),
                          SizedBox(height: 5),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Henüz bir hesabınız yok mu ?"),
                              GestureDetector(
                                onTap: () {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const RegisterScreen(),
                                    ),
                                  );
                                },
                                child: Text(
                                  "Kayıt Ol",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 100),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

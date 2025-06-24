import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mobil_app/components/rounded_button.dart';
import 'package:mobil_app/components/rounded_input_field.dart';
import 'package:mobil_app/screens/login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void _register() async {
    String name = nameController.text.trim();
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    if (name.isEmpty || email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Lütfen tüm alanları doldurun.")),
      );
      return;
    }

    try {
      // 1. Firebase Authentication ile kullanıcı oluştur
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      String uid = userCredential.user!.uid;

      // 2. Firestore'da users koleksiyonuna ekle
      await FirebaseFirestore.instance.collection('users').doc(uid).set({
        'name': name,
        'email': email,
        'createdAt': Timestamp.now(),
      });

      // 3. Başarılı kayıt sonrası login ekranına yönlendir
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    } catch (e) {
      print("Register error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Kayıt başarısız: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
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
                      height: 400,
                      width: 350,
                      decoration: BoxDecoration(
                        color: Colors.white70,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        children: [
                          RoundedInputField(
                            controller: nameController,
                            isEmail: false,
                            isPassword: false,
                            hintText: "Ad Soyad",
                            icon: Icons.person,
                            onChange: (value) {},
                          ),
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
                          RoundedButton(
                            text: "KAYIT OL",
                            press: _register,
                            color: Color(0xFF3F3056),
                          ),
                          SizedBox(height: 5),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Zaten bir hesabınız var mı? "),
                              GestureDetector(
                                onTap: () {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const LoginScreen(),
                                    ),
                                  );
                                },
                                child: Text(
                                  "Giriş Yap",
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

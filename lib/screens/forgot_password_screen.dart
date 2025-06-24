import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ForgotPasswordScreen extends StatelessWidget {
  ForgotPasswordScreen({super.key});

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();

  void resetPassword(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      try {
        await FirebaseAuth.instance.sendPasswordResetEmail(
          email: _emailController.text.trim(),
        );
        Fluttertoast.showToast(
          msg: "Şifre sıfırlama bağlantısı e-posta adresinize gönderildi.",
        );
        Navigator.pop(context);
      } catch (e) {
        Fluttertoast.showToast(msg: "Hata oluştu: ${e.toString()}");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery
        .of(context)
        .size;

    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          // 🎨 Arka plan (gradient + görsel)
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFF8F4FF), Color(0xFFEDE4FF)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Opacity(
              opacity: 0.4,
              child: Image.asset(
                "assets/images/sky.jpg", // arka plan görselin
                fit: BoxFit.cover,
              ),
            ),
          ),

          // 🧱 İçerik
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 30),

                      // Başlık ve ikon
                      const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.lock_outline, color: Colors.black87),
                          SizedBox(width: 8),
                          Text(
                            "Şifremi Unuttum",
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),

                      const Text(
                        "E-posta adresinizi girin,\nşifre sıfırlama bağlantısı gönderilecektir.",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black87,
                        ),
                        textAlign: TextAlign.center,
                      ),

                      const SizedBox(height: 30),

                      // Form
                      Form(
                        key: _formKey,
                        child: TextFormField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Lütfen e-posta adresinizi giriniz.";
                            }
                            if (!value.contains("@") || !value.contains(".")) {
                              return "Geçerli bir e-posta adresi giriniz (örn. ornek@mail.com).";
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            labelText: "E-posta",
                            hintText: "ornek@eposta.com",
                            labelStyle: const TextStyle(color: Colors.black87),
                            hintStyle: const TextStyle(color: Colors.black38),
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      ElevatedButton(
                        onPressed: () => resetPassword(context),
                        style: ElevatedButton.styleFrom(
                          elevation: 4,
                          backgroundColor: const Color(0xFF3F3056),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        child: const Text(
                          "Şifreyi Sıfırla",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),

                      const SizedBox(height: 10),

                      TextButton.icon(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.arrow_back, size: 16),
                        label: const Text("Giriş Ekranına Dön"),
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.black54,
                        ),
                      ),

                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

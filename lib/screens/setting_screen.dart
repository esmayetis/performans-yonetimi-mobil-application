import 'package:flutter/material.dart';
import 'package:mobil_app/screens/register_screen.dart';

import 'edit_profil_screen.dart';
import 'login_screen.dart';

class SettingsScreen extends StatelessWidget {
  final String userId;

  const SettingsScreen({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    // Kullanıcı girişli mi? Örneğin true/false ile yönetebilirsin
    bool isLoggedIn = false; // Burayı state'e bağlayabilirsin

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            const SizedBox(height: 20),
            // Profil Bilgisi Örneği
            ListTile(
              leading: const CircleAvatar(child: Icon(Icons.person)),
              title: const Text("Kullanıcı Adı"),
              subtitle: const Text("kullanici@ornek.com"),
              trailing: TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditProfileScreen(),
                    ),
                  );
                },
                child: const Text("Düzenle"),
              ),
            ),
            const Divider(height: 36),

            // Şifre Değiştir
            ListTile(
              leading: const Icon(Icons.lock_outline),
              title: const Text("Şifre Değiştir"),
              onTap: () {
                // Şifre değiştir sayfasına yönlendir
              },
            ),

            // Bildirimler
            SwitchListTile(
              secondary: const Icon(Icons.notifications_outlined),
              title: const Text("Bildirimler"),
              value: true,
              onChanged: (val) {
                // Bildirimleri aç/kapat işlemi
              },
            ),

            // Tema
            SwitchListTile(
              secondary: const Icon(Icons.dark_mode_outlined),
              title: const Text("Koyu Mod"),
              value: false,
              onChanged: (val) {
                // Tema değişikliği işlemi
              },
            ),

            const Divider(height: 36),

            // Girişli ise Çıkış Yap; değilse Kayıt Ol veya Giriş Yap
            isLoggedIn
                ? ListTile(
                    leading: const Icon(Icons.logout, color: Colors.red),
                    title: const Text("Çıkış Yap",
                        style: TextStyle(color: Colors.red)),
                    onTap: () {},
                  )
                : Column(
                    children: [
                      ListTile(
                        leading: const Icon(Icons.person_add_alt_1),
                        title: const Text("Kayıt Ol"),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => RegisterScreen(),
                            ),
                          );
                        },
                      ),
                      ListTile(
                        leading: const Icon(Icons.login),
                        title: const Text("Çıkış Yap"),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LoginScreen(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),

            const Divider(height: 36),

            // Uygulama Hakkında
            ListTile(
              leading: const Icon(Icons.info_outline),
              title: const Text("Uygulama Hakkında"),
              onTap: () {
                showAboutDialog(
                  context: context,
                  applicationName: "Performans Yönetimi",
                  applicationVersion: "v1.0.0",
                  children: [
                    const Text("TUSAŞ için geliştirilen mobil uygulama."),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

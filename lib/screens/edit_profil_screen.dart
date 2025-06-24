import 'package:flutter/material.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final TextEditingController _nameController =
      TextEditingController(text: "Mevcut Kullanıcı Adı");
  final TextEditingController _emailController =
      TextEditingController(text: "kullanici@ornek.com");
  final TextEditingController _passwordController = TextEditingController();

  // Profil fotoğrafı için (seçim yapmadıysa varsayılan)
  String? _profileImageUrl;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Profil Düzenle"),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              // Profil Fotoğrafı
              Stack(
                alignment: Alignment.bottomRight,
                children: [
                  CircleAvatar(
                    radius: 48,
                    backgroundImage: _profileImageUrl != null
                        ? NetworkImage(_profileImageUrl!)
                        : const AssetImage("assets/default_profile.png")
                            as ImageProvider,
                  ),
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.blue),
                    onPressed: () {
                      // Fotoğraf seçme işlemi burada olacak
                    },
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Kullanıcı Adı
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: "Kullanıcı Adı",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
              ),
              const SizedBox(height: 16),

              // E-posta
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: "E-posta",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.email),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),

              // Şifre Güncelle (isteğe bağlı)
              TextField(
                controller: _passwordController,
                decoration: const InputDecoration(
                  labelText: "Yeni Şifre (İsteğe Bağlı)",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.lock_outline),
                ),
                obscureText: true,
              ),
              const SizedBox(height: 32),

              // Kaydet Butonu
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.save),
                  label: const Text("Değişiklikleri Kaydet"),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    textStyle: const TextStyle(fontSize: 18),
                  ),
                  onPressed: () {
                    // Güncelleme işlemi burada yapılacak
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Profil güncellendi!")),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

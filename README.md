#  Performans Yönetimi Mobil Uygulaması

Bu proje, Bitirme Projesi kapsamında, LIFTUP programı çerçevesinde geliştirilmiştir.  
Amacı, kurumsal bir yapıda **çalışanların görev takibini** sağlamak ve yöneticilerin **performans değerlendirmesi** yapabileceği bir mobil uygulama sunmaktır.

---

##  Özellikler

✅ Çalışanlar için görev ekleme, görüntüleme ve güncelleme  
✅ Yöneticiler için çalışan puanlama ve geri bildirim modülü  
✅ Rol tabanlı giriş sistemi (çalışan / yönetici ayrımı)  
✅ Görev takvimi, bildirimler ve kullanıcı dostu arayüz  
✅ Firebase Auth ve Firestore ile bulut tabanlı veri yönetimi  

---

##  Kullanılan Teknolojiler

| Teknoloji       | Açıklama                         |
|----------------|----------------------------------|
| Flutter         | Uygulama arayüzü ve frontend    |
| Dart            | Uygulama programlama dili       |
| Firebase Auth   | Kimlik doğrulama (email-parola) |
| Firestore       | Gerçek zamanlı veritabanı       |
| GetX            | Durum yönetimi ve yönlendirme   |
| Android Studio  | Geliştirme ortamı               |

---


##  Proje Yapısı

lib/
├── screens/ # Giriş, panel, görev ekranları
├── controllers/ # GetX controller dosyaları
├── db/ # Firebase işlemleri
├── models/ # Veri modelleri
└── main.dart # Uygulama başlatıcısı


---

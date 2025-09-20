import 'package:flutter/material.dart';
import 'package:hesaptakip/core/theme/app_theme.dart';
import 'package:url_launcher/url_launcher.dart';

class HelpSupportPage extends StatelessWidget {
  const HelpSupportPage({super.key});

  Future<void> _sendEmail(String email) async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: email,
      query: 'subject=Hesap Takip Desteği&body=Merhaba,',
    );

    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri, mode: LaunchMode.externalApplication);
    } else {
      throw Exception("E-posta açılamadı");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cardCream2,
      appBar: AppBar(
        title: const Text("Yardım ve Destek"),
        backgroundColor: AppColors.cardCream1,
        iconTheme: const IconThemeData(color: AppColors.ink),
        elevation: 0,
      ),
      body: Column(
        children: [
          // 🔹 Üst içerik (scroll edilebilir)
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(12),
              children: [
                const Text(
                  "Sıkça Sorulan Sorular",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.ink,
                  ),
                ),
                const SizedBox(height: 8),

                ExpansionTile(
                  leading: const Icon(Icons.help_outline, color: AppColors.ink),
                  title: const Text("Gelir nasıl eklenir?"),
                  children: const [
                    Padding(
                      padding: EdgeInsets.all(8),
                      child: Text("Ana sayfadaki '+' butonuna basarak gelir ekleyebilirsiniz."),
                    ),
                  ],
                ),
                ExpansionTile(
                  leading: const Icon(Icons.help_outline, color: AppColors.ink),
                  title: const Text("Raporları nasıl görebilirim?"),
                  children: const [
                    Padding(
                      padding: EdgeInsets.all(8),
                      child: Text("Alt menüdeki 'Raporlar' sekmesine giderek raporlarınıza ulaşabilirsiniz."),
                    ),
                  ],
                ),
                ExpansionTile(
                  leading: const Icon(Icons.help_outline, color: AppColors.ink),
                  title: const Text("Verilerimi nasıl yedekleyebilirim?"),
                  children: const [
                    Padding(
                      padding: EdgeInsets.all(8),
                      child: Text("Raporlar sayfasından verilerinizi PDF olarak indirebilirsiniz."),
                    ),
                  ],
                ),

                const Divider(height: 32),

                ListTile(
                  leading: const Icon(Icons.mail_outline, color: AppColors.ink),
                  title: const Text("Destek ile İletişime Geç"),
                  subtitle: const Text("destek@hesaptakip.com"),
                  onTap: () => _sendEmail("destek@hesaptakip.com"),
                ),

                const Divider(height: 32),

                ListTile(
                  leading: const Icon(Icons.feedback_outlined, color: AppColors.ink),
                  title: const Text("Geri Bildirim Gönder"),
                  onTap: () => _sendEmail("feedback@hesaptakip.com"),
                ),
              ],
            ),
          ),

          // 🔹 Alt kısım (logo + hakkında sabit ortalı)
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Logo (giriş ekranında kullandığın ile aynı path)
                SizedBox(
                  height: 50,
                  child: Image.asset("assets/logo/verto_logo.png"),
                ),
                const SizedBox(height: 12),
                const Text(
                  "Verto v1.0.0",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(height: 4),

              ],
            ),
          ),
        ],
      ),
    );
  }
}

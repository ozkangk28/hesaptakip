import 'package:flutter/material.dart';
import 'package:hesaptakip/core/theme/app_theme.dart';
import 'package:hesaptakip/features/auth/presentation/screens/login_screen.dart';
import 'package:hesaptakip/features/profile/presentation/account_settings.dart';
import 'package:hesaptakip/features/profile/presentation/change_password_page.dart';
import 'package:hesaptakip/features/support/presentation/help_support_page.dart';




class ProfileSheet extends StatelessWidget {
  const ProfileSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: AppColors.cardCream2,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          // 🔹 Kullanıcı Kartı
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(

              color: AppColors.cardCream1,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(

                  color: AppColors.cardCream1,
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 32,
                  backgroundColor: AppColors.gold,
                  child: Icon(Icons.person, color: AppColors.ink, size: 30),
                ),
                const SizedBox(width: 14),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      "Seçkin",
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: AppColors.panelOuter,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      "seckin@example.com",
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: AppColors.gold.withOpacity(0.15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {
                    // TODO: Profili düzenle
                  },
                  child: const Text(
                    "Düzenle",
                    style: TextStyle(
                      color: AppColors.ink,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),
          const Divider(height: 32, thickness: 1),

          // 🔹 Menü Butonları

          _buildButton(
            label: "Hesap",
            icon: Icons.account_circle,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AccountSettingsPage()),
              );
            },
          ),

          _buildButton(
            label: "Güvenlik",
            icon: Icons.lock,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ChangePasswordPage()),
              );
            },
          ),
          _buildButton(
            label: "Yardım ve Destek",
            icon: Icons.help_outline,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const HelpSupportPage(),
                ),
              );
            },
          ),

          _buildButton(
            label: "Çıkış Yap",
            icon: Icons.logout,
            color: Colors.red,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const LoginScreen(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  /// 🔹 Ripple efektli sade buton
  Widget _buildButton({
    required String label,
    required IconData icon,
    required VoidCallback onTap,
    Color color = AppColors.ink,
  }) {
    return InkWell(
      onTap: onTap,
      splashColor: AppColors.gold.withOpacity(0.2), // Ripple efekti
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        child: Row(
          children: [
            Icon(icon, color: color),
            const SizedBox(width: 12),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

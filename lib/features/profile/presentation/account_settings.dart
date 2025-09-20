import 'package:flutter/material.dart';
import 'package:hesaptakip/core/theme/app_theme.dart';

class AccountSettingsPage extends StatefulWidget {
  const AccountSettingsPage({super.key});

  @override
  State<AccountSettingsPage> createState() => _AccountSettingsPageState();
}

class _AccountSettingsPageState extends State<AccountSettingsPage> {
  String _currency = "₺";
  String _theme = "Açık";
  String _language = "Türkçe";
  bool _notifications = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cardCream2,
      appBar: AppBar(
        backgroundColor: AppColors.cardCream1,
        title: const Text("Hesap Ayarları",
            style: TextStyle(color: AppColors.ink)),
        iconTheme: const IconThemeData(color: AppColors.ink),
        elevation: 0,
      ),
      body: ListView(
        children: [

          // 🔹 Para Birimi
          ListTile(
            leading: const Icon(Icons.attach_money, color: AppColors.ink),
            title: const Text("Para Birimi"),
            trailing: Text(_currency,
                style: const TextStyle(fontWeight: FontWeight.bold)),
            onTap: () => _showOptions(
              context,
              title: "Para Birimi Seç",
              options: ["₺", "\$", "€", "£"],
              selected: _currency,
              onSelected: (val) {
                setState(() => _currency = val);
              },
            ),
          ),

          // 🔹 Tema
          ListTile(
            leading: const Icon(Icons.brightness_6, color: AppColors.ink),
            title: const Text("Tema"),
            trailing: Text(_theme,
                style: const TextStyle(fontWeight: FontWeight.bold)),
            onTap: () => _showOptions(
              context,
              title: "Tema Seç",
              options: ["Açık", "Koyu", "Sistem"],
              selected: _theme,
              onSelected: (val) {
                setState(() => _theme = val);
              },
            ),
          ),

          // 🔹 Dil
          ListTile(
            leading: const Icon(Icons.language, color: AppColors.ink),
            title: const Text("Dil"),
            trailing: Text(_language,
                style: const TextStyle(fontWeight: FontWeight.bold)),
            onTap: () => _showOptions(
              context,
              title: "Dil Seç",
              options: ["Türkçe", "English"],
              selected: _language,
              onSelected: (val) {
                setState(() => _language = val);
              },
            ),
          ),

          // 🔹 Bildirimler
          SwitchListTile(
            secondary: const Icon(Icons.notifications, color: AppColors.ink),
            title: const Text("Bildirimler"),
            value: _notifications,
            onChanged: (val) {
              setState(() => _notifications = val);
            },
          ),
        ],
      ),
    );
  }

  /// 🔹 Alt seçim menüsü (bottom sheet)
  void _showOptions(BuildContext context,
      {required String title,
        required List<String> options,
        required String selected,
        required ValueChanged<String> onSelected}) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 12),
            Text(title,
                style: const TextStyle(
                    fontSize: 18, fontWeight: FontWeight.bold)),
            const Divider(),
            ...options.map((opt) => ListTile(
              title: Text(opt),
              trailing: opt == selected
                  ? const Icon(Icons.check, color: AppColors.gold)
                  : null,
              onTap: () {
                onSelected(opt);
                Navigator.pop(context);
              },
            )),
            const SizedBox(height: 12),
          ],
        );
      },
    );
  }
}

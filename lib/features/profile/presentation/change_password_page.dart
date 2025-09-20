import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hesaptakip/core/theme/app_theme.dart';
import 'package:hesaptakip/features/auth/presentation/screens/login_screen.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscureOld = true;
  bool _obscureNew = true;
  bool _obscureConfirm = true;

  // Son 3 şifre (örnek, normalde backend’de tutulmalı)
  List<String> _lastPasswords = ["123456", "111111", "222222"];

  void _changePassword() {
    if (_formKey.currentState!.validate()) {
      final oldPassword = _oldPasswordController.text;
      final newPassword = _newPasswordController.text;
      final confirmPassword = _confirmPasswordController.text;

      // Eski şifre doğru mu?
      if (!_lastPasswords.contains(oldPassword)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Eski şifre hatalı!"),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      // Yeni şifre tekrar ile aynı mı?
      if (newPassword != confirmPassword) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Yeni şifreler eşleşmiyor!"),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      // Son 3 şifreyle aynı olamaz
      if (_lastPasswords.contains(newPassword)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Yeni şifre son 3 şifreyle aynı olamaz!"),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      // Başarılı
      setState(() {
        _lastPasswords.insert(0, newPassword);
        if (_lastPasswords.length > 3) {
          _lastPasswords = _lastPasswords.sublist(0, 3);
        }
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Şifre başarıyla değiştirildi"),
          backgroundColor: Colors.green,
        ),
      );

      // 1 saniye bekleyip LoginScreen'e yönlendir
      Future.delayed(const Duration(seconds: 1), () {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const LoginScreen()),
              (route) => false,
        );
      });

      // Alanları temizle
      _oldPasswordController.clear();
      _newPasswordController.clear();
      _confirmPasswordController.clear();
    }
  }

  Widget _buildPasswordField({
    required String label,
    required TextEditingController controller,
    required bool obscure,
    required VoidCallback toggle,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      maxLength: 6, // 🔹 6 haneli
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly], // 🔹 sadece rakam
      decoration: InputDecoration(
        labelText: label,
        counterText: "", // maxLength yazısını gizler
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        suffixIcon: IconButton(
          icon: Icon(obscure ? Icons.visibility_off : Icons.visibility),
          onPressed: toggle,
        ),
      ),
      validator: (val) {
        if (val == null || val.isEmpty) return "Lütfen $label girin";
        if (val.length != 6) return "Şifre 6 haneli olmalı";
        return null;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Şifre Değiştir"),
        backgroundColor: AppColors.cardCream2,
        iconTheme: const IconThemeData(color: AppColors.ink),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildPasswordField(
                label: "Eski Şifre",
                controller: _oldPasswordController,
                obscure: _obscureOld,
                toggle: () => setState(() => _obscureOld = !_obscureOld),
              ),
              const SizedBox(height: 16),
              _buildPasswordField(
                label: "Yeni Şifre",
                controller: _newPasswordController,
                obscure: _obscureNew,
                toggle: () => setState(() => _obscureNew = !_obscureNew),
              ),
              const SizedBox(height: 16),
              _buildPasswordField(
                label: "Yeni Şifre (Tekrar)",
                controller: _confirmPasswordController,
                obscure: _obscureConfirm,
                toggle: () => setState(() => _obscureConfirm = !_obscureConfirm),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _changePassword,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.gold,
                  foregroundColor: AppColors.ink,
                  minimumSize: const Size(double.infinity, 48),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  "Şifreyi Güncelle",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

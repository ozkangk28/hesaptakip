import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hesaptakip/core/theme/app_theme.dart';
import 'package:hesaptakip/features/auth/presentation/screens/login_screen.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class ForgotPasswordManager {
  static void show(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) => const _MethodDialog(),
    );
  }
}

/// İlk pencere: SMS / E-posta seçimi
class _MethodDialog extends StatelessWidget {
  const _MethodDialog();

  @override
  Widget build(BuildContext context) {
    return _DialogWrapper(
      title: "Şifre Yenileme",
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.mail_outline),
            title: const Text("E-posta ile sıfırla"),
            onTap: () {
              Navigator.pop(context);
              showDialog(
                context: context,
                builder: (_) => const _VerificationDialog(isSms: false),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.sms_outlined),
            title: const Text("SMS ile sıfırla"),
            onTap: () {
              Navigator.pop(context);
              showDialog(
                context: context,
                builder: (_) => const _VerificationDialog(isSms: true),
              );
            },
          ),
        ],
      ),
    );
  }
}

/// Doğrulama için giriş (telefon veya e-posta)
class _VerificationDialog extends StatefulWidget {
  final bool isSms;
  const _VerificationDialog({required this.isSms});

  @override
  State<_VerificationDialog> createState() => _VerificationDialogState();
}

class _VerificationDialogState extends State<_VerificationDialog> {
  final TextEditingController _inputCtrl = TextEditingController();

  final phoneFormatter = MaskTextInputFormatter(
    mask: '0 (###) ### ## ##',
    filter: {"#": RegExp(r'[0-9]')},
  );

  @override
  Widget build(BuildContext context) {
    return _DialogWrapper(
      title: widget.isSms ? " Telefon Doğrulama " : " E-posta Doğrulama ",
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _inputCtrl,
            keyboardType:
            widget.isSms ? TextInputType.number : TextInputType.emailAddress,
            inputFormatters: widget.isSms ? [phoneFormatter] : [],
            decoration: InputDecoration(
              hintText: widget.isSms ? " Telefon numaranız " : " E-posta adresiniz ",
            ),
          ),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              showDialog(
                context: context,
                builder: (_) => const _CodeDialog(),
              );
            },
            child: const Text("  Kodu Gönder  "),
          ),
        ],
      ),
    );
  }
}

/// Kod girme ekranı
class _CodeDialog extends StatefulWidget {
  const _CodeDialog();

  @override
  State<_CodeDialog> createState() => _CodeDialogState();
}

class _CodeDialogState extends State<_CodeDialog> {
  final TextEditingController _codeCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return _DialogWrapper(
      title: "Doğrulama Kodu",
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _codeCtrl,
            keyboardType: TextInputType.number,
            maxLength: 6,
            decoration: const InputDecoration(
              hintText: "6 haneli kodu giriniz",
            ),
          ),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: () {
              if (_codeCtrl.text == "123456") {
                Navigator.pop(context);
                showDialog(
                  context: context,
                  builder: (_) => const _ResetPasswordDialog(),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Geçersiz kod! (demo: 123456)")),
                );
              }
            },
            child: const Text("  Onayla  "),
          ),
        ],
      ),
    );
  }
}

/// Şifre yenileme ekranı
class _ResetPasswordDialog extends StatefulWidget {
  const _ResetPasswordDialog();

  @override
  State<_ResetPasswordDialog> createState() => _ResetPasswordDialogState();
}

class _ResetPasswordDialogState extends State<_ResetPasswordDialog> {
  final _formKey = GlobalKey<FormState>();
  final _p1 = TextEditingController();
  final _p2 = TextEditingController();

  bool _obscure1 = true;
  bool _obscure2 = true;

  @override
  Widget build(BuildContext context) {
    return _DialogWrapper(
      title: "Yeni Şifre Belirle",
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Yeni Şifre
            TextFormField(
              controller: _p1,
              obscureText: _obscure1,
              keyboardType: TextInputType.number,
              maxLength: 6,
              decoration: InputDecoration(
                hintText: "Yeni Şifre (6 haneli)",
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscure1 ? Icons.visibility_off : Icons.visibility,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscure1 = !_obscure1;
                    });
                  },
                ),
              ),
              validator: (v) {
                if (v == null || v.isEmpty) return "Şifre gerekli";
                if (v.length != 6) return "6 haneli olmalı";
                return null;
              },
            ),
            // Şifre Tekrar
            TextFormField(
              controller: _p2,
              obscureText: _obscure2,
              keyboardType: TextInputType.number,
              maxLength: 6,
              decoration: InputDecoration(
                hintText: "Şifre Tekrar",
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscure2 ? Icons.visibility_off : Icons.visibility,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscure2 = !_obscure2;
                    });
                  },
                ),
              ),
              validator: (v) {
                if (v != _p1.text) return "Şifreler uyuşmuyor";
                return null;
              },
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState?.validate() ?? false) {
                  Navigator.pop(context); // dialogu kapat
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (_) => const LoginScreen(
                        showPasswordChangedMessage: true, // 🔔 mesaj işareti
                      ),
                    ),
                        (route) => false,
                  );
                }
              },
              child: const Text("  Kaydet  "),
            ),
          ],
        ),
      ),
    );
  }
}

/// Ortak Dialog tasarımı
class _DialogWrapper extends StatelessWidget {
  final String title;
  final Widget child;
  const _DialogWrapper({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(title,
                style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppColors.greenDark)),
            const SizedBox(height: 16),
            child,
          ],
        ),
      ),
    );
  }
}

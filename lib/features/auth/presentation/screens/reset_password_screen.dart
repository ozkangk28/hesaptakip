import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _p1 = TextEditingController();
  final _p2 = TextEditingController();
  bool _ob1 = true, _ob2 = true;

  @override
  void dispose() {
    _p1.dispose();
    _p2.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Şifreyi Yenile')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _p1,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                maxLength: 6,
                obscureText: _ob1,
                decoration: InputDecoration(
                  hintText: 'Yeni şifre (6 hane)',
                  suffixIcon: IconButton(
                    onPressed: () => setState(() => _ob1 = !_ob1),
                    icon: Icon(_ob1 ? Icons.visibility_off : Icons.visibility),
                  ),
                ),
                validator: (v) => RegExp(r'^\d{6}$').hasMatch(v ?? '') ? null : '6 haneli rakam girin',
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _p2,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                maxLength: 6,
                obscureText: _ob2,
                decoration: InputDecoration(
                  hintText: 'Yeni şifre (tekrar)',
                  suffixIcon: IconButton(
                    onPressed: () => setState(() => _ob2 = !_ob2),
                    icon: Icon(_ob2 ? Icons.visibility_off : Icons.visibility),
                  ),
                ),
                validator: (v) {
                  if (!RegExp(r'^\d{6}$').hasMatch(v ?? '')) return '6 haneli rakam girin';
                  if (v != _p2.text && v != _p1.text) return 'Şifreler uyuşmuyor';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _submit,
                  child: const Text('Şifreyi Kaydet'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    // TODO: Sunucuya yeni şifreyi gönder (token/OTP ile eşleştir)
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Şifre yenilendi (demo)')),
    );
    Navigator.of(context).popUntil((r) => r.isFirst);
  }
}

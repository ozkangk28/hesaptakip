import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hesaptakip/core/theme/app_theme.dart';      // AppColors için
import 'package:hesaptakip/core/utils/validators.dart';     // Validators.tc / Validators.pin6 için
import 'package:hesaptakip/features/auth/presentation/screens/register_screen.dart';
import 'package:hesaptakip/features/auth/presentation/widgets/forgot_password_manager.dart';
import 'package:hesaptakip/features/dashboard/presentation/screens/home_screen.dart';
import 'package:hesaptakip/features/dashboard/data/repositories/finance_repository_mock.dart';

class LoginScreen extends StatefulWidget {
  final bool showPasswordChangedMessage; // ✅ yeni parametre

  const LoginScreen({
    super.key,
    this.showPasswordChangedMessage = false,
  });

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController tcController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _obscure = true;

  @override
  void initState() {
    super.initState();

    // ✅ Şifre değiştirme mesajını göster
    if (widget.showPasswordChangedMessage) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Şifreniz başarıyla değiştirilmiştir"),
            duration: Duration(seconds: 2),
          ),
        );
      });
    }
  }

  @override
  void dispose() {
    tcController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo
                  SizedBox(
                    width: 80,
                    height: 80,
                    child: Image.asset(
                      'assets/logo/verto_logo.png',
                      fit: BoxFit.contain,
                    ),
                  ),

                  const SizedBox(height: 20),
                  const Text(
                    'VERTO',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 45,
                      fontWeight: FontWeight.bold,
                      color: AppColors.greenDark,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Geleceğinize yatırım yapın',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontStyle: FontStyle.italic,
                      fontSize: 18,
                      color: AppColors.greenDark,
                    ),
                  ),
                  const SizedBox(height: 40),

                  // TC Kimlik No
                  TextFormField(
                    controller: tcController,
                    keyboardType: TextInputType.number,
                    maxLength: 11,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    decoration: _inputDecoration(
                      hintText: 'TC Kimlik No',
                      prefixIcon: Icons.person_outline,
                    ),
                    validator: Validators.tc,
                  ),
                  const SizedBox(height: 20),

                  // Şifre
                  TextFormField(
                    controller: passwordController,
                    keyboardType: TextInputType.number,
                    maxLength: 6,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    obscureText: _obscure,
                    decoration: _inputDecoration(
                      hintText: 'Şifre',
                      prefixIcon: Icons.lock_outline,
                      suffix: IconButton(
                        onPressed: () => setState(() => _obscure = !_obscure),
                        icon: Icon(_obscure ? Icons.visibility_off : Icons.visibility),
                      ),
                    ),
                    validator: Validators.pin6,
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: _onForgotPassword,
                      child: const Text('Şifremi unuttum?'),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // GİRİŞ YAP
                  _buildFullWidthButton(
                    label: 'Giriş Yap',
                    bg: AppColors.gold,
                    fg: Colors.black,
                    onPressed: _onLogin,
                  ),

                  const SizedBox(height: 16),
                  const Text('Hesabınız yok mu?', textAlign: TextAlign.center),
                  const SizedBox(height: 8),

                  // KAYIT OL
                  _buildFullWidthButton(
                    label: 'Kayıt Ol',
                    bg: AppColors.greenDark,
                    fg: AppColors.gold,
                    onPressed: _onSignUp,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration({
    required String hintText,
    required IconData prefixIcon,
    Widget? suffix,
  }) {
    return InputDecoration(
      hintText: hintText,
      prefixIcon: Icon(prefixIcon, color: AppColors.greenDark),
      suffixIcon: suffix,
    );
  }

  Widget _buildFullWidthButton({
    required String label,
    required Color bg,
    required Color fg,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: bg,
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: fg,
            fontSize: 25,
            fontWeight: FontWeight.w600,
            height: 1,
          ),
        ),
      ),
    );
  }

  Future<void> _onLogin() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    FocusScope.of(context).unfocus();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    try {
      final repo = FinanceRepositoryMock();
      final data = await repo.fetchDashboard();

      if (mounted) {
        Navigator.of(context).pop(); // loading kapat
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => HomeScreen(repository: repo, preloaded: data),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        Navigator.of(context).pop(); // loading kapat
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Giriş sırasında hata: $e')),
        );
      }
    }
  }

  void _onSignUp() {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => const RegisterScreen(),
        transitionsBuilder: (_, animation, __, child) {
          final tween = Tween<Offset>(begin: const Offset(1, 0), end: Offset.zero)
              .chain(CurveTween(curve: Curves.easeOutCubic));
          return SlideTransition(position: animation.drive(tween), child: child);
        },
      ),
    );
  }

  void _onForgotPassword() {
    ForgotPasswordManager.show(context);
  }
}

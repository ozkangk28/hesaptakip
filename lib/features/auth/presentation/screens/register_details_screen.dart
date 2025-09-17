import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:hesaptakip/core/theme/app_theme.dart';
import 'package:hesaptakip/core/utils/validators.dart';
import 'package:hesaptakip/features/auth/presentation/screens/register_success_screen.dart';
import 'package:flutter/services.dart';
import 'package:hesaptakip/core/utils/input_formatters.dart';


class RegisterDetailsScreen extends StatefulWidget {
  final String firstName;
  final String lastName;
  final String email;
  final String country;
  final String city;
  final String address;

  const RegisterDetailsScreen({
    super.key,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.country,
    required this.city,
    required this.address,
  });

  @override
  State<RegisterDetailsScreen> createState() => _RegisterDetailsScreenState();
}

class _RegisterDetailsScreenState extends State<RegisterDetailsScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _tcCtrl    = TextEditingController();
  final TextEditingController _passCtrl  = TextEditingController();
  final TextEditingController _pass2Ctrl = TextEditingController();
  final TextEditingController _phoneCtrl = TextEditingController();
  final _pass2Key = GlobalKey<FormFieldState<String>>();


  bool _ob1 = true;
  bool _ob2 = true;

  bool _kvkkOk = false;
  bool _termsOk = false;

  bool _isValid = false; // Buton aktifliği için

  @override

  @override
  void initState() {
    super.initState();
    _tcCtrl.addListener(_recompute);
    _passCtrl.addListener(() {
      _recompute();
      _pass2Key.currentState?.validate(); // Şifre1 değişince Şifre2’yi anında kontrol et
    });
    _pass2Ctrl.addListener(_recompute);
    _phoneCtrl.addListener(_recompute);
  }



  @override
  void dispose() {
    _tcCtrl.dispose();
    _passCtrl.dispose();
    _pass2Ctrl.dispose();
    _phoneCtrl.dispose();
    super.dispose();
  }

  void _recompute() {
    final okTc    = Validators.tc(_tcCtrl.text) == null;
    final okPass  = Validators.pin6(_passCtrl.text) == null;
    final okPass2 = Validators.pin6(_pass2Ctrl.text) == null && _pass2Ctrl.text == _passCtrl.text;
    final okPhone = Validators.trPhone10(_phoneCtrl.text) == null;
    final all     = okTc && okPass && okPass2 && okPhone && _kvkkOk && _termsOk;

    if (all != _isValid) setState(() => _isValid = all);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.greenDark),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        centerTitle: true,
        title: const Text(
          'Yeni Hesap Oluştur', // siyah
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 8),
            child: Form(
              key: _formKey,
              onChanged: _recompute, // formda değişim oldukça aktiflik güncellensin
              child: Column(
                children: [
                  // Logo
                  SizedBox(
                    width: 64,
                    height: 64,
                    child: Image.asset(
                      'assets/logo/verto_logo.png',
                      fit: BoxFit.contain,
                    ),
                  ),

                  const SizedBox(height: 12),
                  const Text(
                    'VERTO',
                    style: TextStyle(
                      color: AppColors.greenDark,
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Yeni Hesap Oluştur',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black, // istenen renk
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // TC Kimlik

                  TextFormField(
                    controller: _tcCtrl,
                    keyboardType: TextInputType.number,
                    maxLength: 11,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      TcknInputFormatter(),
                    ],
                    decoration: _dec(hint: 'TC Kimlik No', icon: Icons.badge_outlined)
                        .copyWith(counterText: ''), // sayaç yazısını gizle
                    validator: Validators.tc,
                  ),

                  const SizedBox(height: 16),

                  // Şifre1
                  TextFormField(
                    controller: _passCtrl,
                    keyboardType: TextInputType.number,
                    maxLength: 6,
                    obscureText: _ob1,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    decoration: _dec(
                      hint: 'Şifre (6 hane)',
                      icon: Icons.lock_outline,
                      suffix: IconButton(
                        onPressed: () => setState(() => _ob1 = !_ob1),
                        icon: Icon(_ob1 ? Icons.visibility_off : Icons.visibility),
                      ),
                    ),
                    validator: Validators.pin6, // sadece kendi kuralını gösterir
                  ),

// Şifre Tekrar (hata burada gösterilir)
                  TextFormField(
                    key: _pass2Key,
                    controller: _pass2Ctrl,
                    keyboardType: TextInputType.number,
                    maxLength: 6,
                    obscureText: _ob2,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    decoration: _dec(
                      hint: 'Şifre Tekrar',
                      icon: Icons.lock_outline,
                      suffix: IconButton(
                        onPressed: () => setState(() => _ob2 = !_ob2),
                        icon: Icon(_ob2 ? Icons.visibility_off : Icons.visibility),
                      ),
                    ),
                    validator: (v) {
                      final err = Validators.pin6(v);
                      if (err != null) return err;       // önce 6 hane kuralı
                      if (v != _passCtrl.text) return 'Şifreler uyuşmuyor'; // eşleşme kontrolü
                      return null;
                    },
                  ),

                  const SizedBox(height: 16),

                  // Telefon (+90 prefix)
                  TextFormField(
                    controller: _phoneCtrl,
                    keyboardType: TextInputType.phone,
                    maxLength: 13, // 5xx xxx xx xx → 13 karakter (boşluklar dahil)
                    inputFormatters: [
                      TrPhoneMaskInputFormatter(),
                    ],
                    decoration: _dec(
                      hint: 'Telefon Numarası',
                      icon: Icons.phone_outlined,
                      prefixText: '+90 ',
                    ).copyWith(counterText: ''), // sayaç gizle
                    validator: Validators.trPhone10,
                  ),

                  const SizedBox(height: 16),

                  // KVKK onayı (linkli)
                  _linkCheckbox(
                    value: _kvkkOk,
                    onChanged: (v) {
                      setState(() => _kvkkOk = v ?? false);
                      _recompute();
                    },
                    textSpans: [
                      const TextSpan(text: 'KVKK onayını '),
                      TextSpan(
                        text: 'okudum ve kabul ediyorum',
                        style: const TextStyle(
                          color: Colors.blue,
                          decoration: TextDecoration.underline,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () => _openPolicy('KVKK Aydınlatma Metni',
                              'Buraya KVKK metnini ekleyebilirsiniz.'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Kullanım şartları onayı (linkli)
                  _linkCheckbox(
                    value: _termsOk,
                    onChanged: (v) {
                      setState(() => _termsOk = v ?? false);
                      _recompute();
                    },
                    textSpans: [
                      const TextSpan(text: 'Kullanım Şartları\'nı '),
                      TextSpan(
                        text: 'okudum ve kabul ediyorum',
                        style: const TextStyle(
                          color: Colors.blue,
                          decoration: TextDecoration.underline,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () => _openPolicy('Kullanım Şartları',
                              'Buraya kullanım şartları metnini ekleyebilirsiniz.'),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Kayıt Ol — metne tıklama sorunu olmadan, yalnızca tümü geçerliyse aktif
                  SizedBox(
                    width: double.infinity,
                    height: 60,
                    child: ElevatedButton(
                      onPressed: _isValid ? _onRegister : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.greenDark,
                        padding: EdgeInsets.zero,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Kayıt Ol',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppColors.gold,
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          height: 1,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _dec({
    required String hint,
    required IconData icon,
    Widget? suffix,
    String? prefixText,
  }) {
    return InputDecoration(
      hintText: hint,
      prefixIcon: Icon(icon, color: AppColors.greenDark),
      suffixIcon: suffix,
      prefixText: prefixText,
    );
  }

  // Linkli checkbox satırı
  Widget _linkCheckbox({
    required bool value,
    required ValueChanged<bool?> onChanged,
    required List<InlineSpan> textSpans,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Checkbox(
          value: value,
          onChanged: onChanged,
          activeColor: AppColors.greenDark,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: RichText(
            text: TextSpan(
              style: const TextStyle(
                color: AppColors.greenDark,
                fontSize: 14.5,
              ),
              children: textSpans,
            ),
          ),
        ),
      ],
    );
  }

  void _openPolicy(String title, String body) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => Scaffold(
          appBar: AppBar(
            title: Text(title, style: const TextStyle(color: AppColors.greenDark)),
            backgroundColor: AppColors.background,
            iconTheme: const IconThemeData(color: AppColors.greenDark),
            elevation: 0,
          ),
          backgroundColor: AppColors.background,
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              body,
              style: const TextStyle(fontSize: 16, color: AppColors.greenDark),
            ),
          ),
        ),
      ),
    );
  }

  void _onRegister() {


    // Hata mesajlarını göstermek için finalize validate
    if (!(_formKey.currentState?.validate() ?? false)) return;
    if (!_kvkkOk || !_termsOk) return;

    FocusScope.of(context).unfocus();

    // TODO: Gerçek API kaydı burada yapılabilir.
    // Başarılı kabul edip başarı ekranına geçiyoruz:
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const RegisterSuccessScreen()),
    );
  }
}

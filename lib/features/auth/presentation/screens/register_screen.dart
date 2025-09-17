import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hesaptakip/core/theme/app_theme.dart'; // AppColors
import 'package:hesaptakip/core/utils/validators.dart';
import 'package:hesaptakip/features/auth/presentation/screens/register_details_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _firstNameCtrl = TextEditingController();
  final TextEditingController _lastNameCtrl  = TextEditingController();
  final TextEditingController _emailCtrl     = TextEditingController();
  final TextEditingController _addressCtrl   = TextEditingController();

  String _country = 'Türkiye';
  String? _city;

  @override
  void dispose() {
    _firstNameCtrl.dispose();
    _lastNameCtrl.dispose();
    _emailCtrl.dispose();
    _addressCtrl.dispose();
    super.dispose();
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
          'Yeni Hesap Oluştur',
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
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Ad & Soyad
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _firstNameCtrl,
                          textInputAction: TextInputAction.next,
                          textCapitalization: TextCapitalization.words,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                              RegExp(r"[a-zA-ZğüşöçİıĞÜŞÖÇ\s'-]"),
                            ),
                          ],
                          decoration: _dec(hint: 'Ad', icon: Icons.person_outline),
                          validator: Validators.name,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: TextFormField(
                          controller: _lastNameCtrl,
                          textInputAction: TextInputAction.next,
                          textCapitalization: TextCapitalization.words,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                              RegExp(r"[a-zA-ZğüşöçİıĞÜŞÖÇ\s'-]"),
                            ),
                          ],
                          decoration: _dec(hint: 'Soyad', icon: Icons.person_outline),
                          validator: Validators.name,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // E-posta (TR karakter desteği için filter kaldırıldı, serbest metin)
                  TextFormField(
                    controller: _emailCtrl,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.emailAddress,
                    decoration: _dec(hint: 'E-posta', icon: Icons.email_outlined),
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) return 'E-posta gerekli';
                      final ok = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(v.trim());
                      if (!ok) return 'Geçerli bir e-posta girin';
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Ülke
                  DropdownButtonFormField<String>(
                    value: _country,
                    decoration: _dec(hint: 'Ülke', icon: Icons.public),
                    items: const [
                      DropdownMenuItem(value: 'Türkiye', child: Text('Türkiye')),
                    ],
                    onChanged: (v) => setState(() => _country = v ?? 'Türkiye'),
                  ),
                  const SizedBox(height: 16),

                  // Şehir
                  DropdownButtonFormField<String>(
                    value: _city,
                    isExpanded: true,
                    decoration: _dec(hint: 'Şehir', icon: Icons.location_city_outlined),
                    items: _turkeyCities
                        .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                        .toList(),
                    onChanged: (v) => setState(() => _city = v),
                    validator: (v) => v == null ? 'Şehir seçin' : null,
                  ),
                  const SizedBox(height: 16),

                  // Adres (TR karakter desteği için filtre kaldırıldı)
                  TextFormField(
                    controller: _addressCtrl,
                    textInputAction: TextInputAction.newline,
                    minLines: 3,
                    maxLines: 5,
                    decoration: _dec(hint: 'Adres', icon: Icons.home_outlined),
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) return 'Adres gerekli';
                      if (v.trim().length < 10) return 'Daha detaylı adres girin';
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),

                  // Devam Et
                  SizedBox(
                    width: double.infinity,
                    height: 60,
                    child: ElevatedButton(
                      onPressed: _onContinue,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.greenDark,
                        padding: EdgeInsets.zero,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Devam Et',
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

  InputDecoration _dec({required String hint, required IconData icon}) {
    return InputDecoration(
      hintText: hint,
      prefixIcon: Icon(icon, color: AppColors.greenDark),
    );
  }

  void _onContinue() {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    Navigator.of(context).push(PageRouteBuilder(
      pageBuilder: (_, __, ___) => RegisterDetailsScreen(
        firstName: _firstNameCtrl.text.trim(),
        lastName:  _lastNameCtrl.text.trim(),
        email:     _emailCtrl.text.trim(),
        country:   _country,
        city:      _city!,
        address:   _addressCtrl.text.trim(),
      ),
      transitionsBuilder: (_, animation, __, child) {
        final tween = Tween<Offset>(begin: const Offset(1, 0), end: Offset.zero)
            .chain(CurveTween(curve: Curves.easeOutCubic));
        return SlideTransition(position: animation.drive(tween), child: child);
      },
    ));
  }
}

// 81 il
const List<String> _turkeyCities = [
  'Adana','Adıyaman','Afyonkarahisar','Ağrı','Amasya','Ankara','Antalya','Artvin','Aydın',
  'Balıkesir','Bilecik','Bingöl','Bitlis','Bolu','Burdur','Bursa','Çanakkale','Çankırı',
  'Çorum','Denizli','Diyarbakır','Edirne','Elazığ','Erzincan','Erzurum','Eskişehir',
  'Gaziantep','Giresun','Gümüşhane','Hakkâri','Hatay','Isparta','Mersin','İstanbul','İzmir',
  'Kars','Kastamonu','Kayseri','Kırklareli','Kırşehir','Kocaeli','Konya','Kütahya','Malatya',
  'Manisa','Kahramanmaraş','Mardin','Muğla','Muş','Nevşehir','Niğde','Ordu','Rize','Sakarya',
  'Samsun','Siirt','Sinop','Sivas','Tekirdağ','Tokat','Trabzon','Tunceli','Şanlıurfa','Uşak',
  'Van','Yozgat','Zonguldak','Aksaray','Bayburt','Karaman','Kırıkkale','Batman','Şırnak',
  'Bartın','Ardahan','Iğdır','Yalova','Karabük','Kilis','Osmaniye','Düzce'
];

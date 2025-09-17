import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:hesaptakip/core/theme/app_theme.dart';
import 'package:hesaptakip/features/dashboard/domain/models/finance_models.dart';
import 'package:hesaptakip/features/dashboard/domain/repositories/finance_repository.dart';
import 'package:hesaptakip/features/dashboard/data/repositories/finance_repository_mock.dart';

// 🔹 Yeni eklenen importlar
import 'package:hesaptakip/features/dashboard/presentation/widgets/panel_content.dart';
import 'package:hesaptakip/features/dashboard/presentation/widgets/bottom_pill_nav.dart';
import 'package:hesaptakip/features/dashboard/presentation/widgets/add_transaction_dialog.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, this.repository, this.preloaded});
  final FinanceRepository? repository;

  /// (Opsiyonel) Login'den hazır veri verilirse FutureBuilder beklenmez.
  final DashboardData? preloaded;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final FinanceRepository _repo;
  late final NumberFormat _tl;

  @override
  void initState() {
    super.initState();
    _repo = widget.repository ?? FinanceRepositoryMock();
    _tl = NumberFormat.currency(locale: 'tr_TR', symbol: '₺', decimalDigits: 2);
  }

  @override
  Widget build(BuildContext context) {
    final preloaded = widget.preloaded;

    return Scaffold(
      extendBody: true,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.gradientTopBlack, AppColors.gradientBottomDeep],
          ),
        ),
        child: SafeArea(
          bottom: false,
          child: preloaded != null
              ? _buildContent(preloaded)
              : FutureBuilder<DashboardData>(
            future: _repo.fetchDashboard(),
            builder: (context, snap) {
              if (!snap.hasData) {
                return const Center(
                  child: CircularProgressIndicator(color: AppColors.gold),
                );
              }
              return _buildContent(snap.data!);
            },
          ),
        ),
      ),
    );
  }

  Widget _buildContent(DashboardData data) {
    return Stack(
      children: [
        // Büyük, köşeleri yuvarlatılmış koyu panel
        Positioned.fill(
          top: 12,
          left: 12,
          right: 12,
          bottom: 92,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(28),
            child: Container(
              color: Colors.black.withOpacity(0.15),
              child: Padding(
                padding: const EdgeInsets.all(2),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(26),
                  child: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [AppColors.panelOuter, AppColors.panelInner],
                      ),
                    ),
                    child: PanelContent(
                      userName: data.userName,
                      summary: data.summary,
                      transactions: data.lastTransactions,
                      tl: _tl,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),

        // Alt: oval sekme çubuğu
        Positioned(
          left: 16,
          right: 16,
          bottom: 16,
          child: BottomPillNav(
            onTap: (i) {
              if (i == 1) {
                _openAddDialog(); // merkezde seçenek paneli
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                        i == 0 ? 'Ana Sayfa (demo)' : 'Raporlar (demo)'),
                  ),
                );
              }
            },
          ),
        ),
      ],
    );
  }

  // ========= Merkezde açılan "Ekle" paneli =========
  Future<void> _openAddDialog() async {
    await showGeneralDialog(
      context: context,
      barrierLabel: 'Ekle',
      barrierDismissible: true,
      barrierColor: Colors.black54,
      transitionDuration: const Duration(milliseconds: 220),
      pageBuilder: (_, __, ___) {
        return Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 360),
            child: Material(
              color: AppColors.cardCream2,
              borderRadius: BorderRadius.circular(20),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(18, 18, 18, 12),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Başlık + sağ üst çarpı
                    Row(
                      children: [
                        const Expanded(
                          child: Text(
                            'Yeni Kayıt Ekle',
                            style: TextStyle(
                              color: AppColors.ink,
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                        InkWell(
                          borderRadius: BorderRadius.circular(12),
                          onTap: () => Navigator.pop(context),
                          child: const Icon(Icons.close,
                              size: 22, color: Colors.black54),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // 2x2 seçenek grid
                    GridView.count(
                      crossAxisCount: 2,
                      shrinkWrap: true,
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      childAspectRatio: 1.5,
                      children: [
                        _AddTile(
                          icon: Icons.trending_up_rounded,
                          label: 'Gelir',
                          color: AppColors.success,
                          onTap: () {
                            Navigator.pop(context);
                            _openAddForm(TransactionType.income);
                          },
                        ),
                        _AddTile(
                          icon: Icons.trending_down_rounded,
                          label: 'Gider',
                          color: AppColors.danger,
                          onTap: () {
                            Navigator.pop(context);
                            _openAddForm(TransactionType.expense);
                          },
                        ),
                        _AddTile(
                          icon: Icons.call_received_rounded,
                          label: 'Alacak',
                          color: AppColors.gold,
                          onTap: () {
                            Navigator.pop(context);
                            _openAddForm(TransactionType.receivable);
                          },
                        ),
                        _AddTile(
                          icon: Icons.call_made_rounded,
                          label: 'Borç',
                          color: AppColors.neutral600,
                          onTap: () {
                            Navigator.pop(context);
                            _openAddForm(TransactionType.payable);
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
            ),
          ),
        );
      },
      transitionBuilder: (_, anim, __, child) {
        final curved = CurvedAnimation(parent: anim, curve: Curves.easeOutBack);
        return FadeTransition(
          opacity: anim,
          child: ScaleTransition(scale: curved, child: child),
        );
      },
    );
  }

  // ========= İşlem ekleme diyaloğunu çağır =========
  Future<void> _openAddForm(TransactionType type) async {
    await showGeneralDialog(
      context: context,
      barrierLabel: 'İşlem Ekle',
      barrierDismissible: true,
      barrierColor: Colors.black54,
      transitionDuration: const Duration(milliseconds: 220),
      pageBuilder: (_, __, ___) {
        return AddTransactionDialog(
          type: type,
          onSaved: (tx) async {
            await _repo.addTransaction(tx);
            setState(() {});
          },
        );
      },
    );

  }
}

// ---------------- Ekle panelindeki kutucuk ----------------
class _AddTile extends StatelessWidget {
  const _AddTile({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Ink(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(.7),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: color, size: 28),
              const SizedBox(height: 6),
              Text(label,
                  style: const TextStyle(
                      color: AppColors.ink, fontWeight: FontWeight.w700)),
            ],
          ),
        ),
      ),
    );
  }
}

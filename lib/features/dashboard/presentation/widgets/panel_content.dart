import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:hesaptakip/core/theme/app_theme.dart';
import 'package:hesaptakip/features/dashboard/domain/models/finance_models.dart';
import 'package:hesaptakip/features/dashboard/presentation/widgets/transaction_details_dialog.dart';

class PanelContent extends StatelessWidget {
  const PanelContent({
    super.key,
    required this.userName,
    required this.summary,
    required this.transactions,
    required this.tl,
  });

  final String userName;
  final BudgetSummary summary;
  final List<TransactionItem> transactions;
  final NumberFormat tl;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 8),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hoş geldin + avatar
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Hoş geldin',
                        style: TextStyle(
                          color: Colors.white.withOpacity(.9),
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        userName,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 32,
                          fontWeight: FontWeight.w800,
                          height: 1.1,
                        ),
                      ),
                    ],
                  ),
                ),
                CircleAvatar(
                  radius: 22,
                  backgroundColor: Colors.white24,
                  child: const Icon(Icons.person, color: Colors.white),
                ),
              ],
            ),
            const SizedBox(height: 18),

            // Toplam Bütçe (krem kart)
            _softCard(
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.badgeSoftGreen,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.attach_money_rounded,
                        color: AppColors.success, size: 22),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Toplam Bütçe',
                          style: TextStyle(
                              color: AppColors.ink,
                              fontSize: 14,
                              fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          tl.format(summary.totalBudget),
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w900,
                            color: AppColors.ink,
                            letterSpacing: .2,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),

            // 2x2 metrik kartları
            _softCard(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(child: _metric('Gelir', tl.format(summary.income), AppColors.success)),
                      const SizedBox(width: 14),
                      Expanded(child: _metric('Gider', tl.format(summary.expense), AppColors.danger)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(child: _metric('Alacak', tl.format(summary.receivable), AppColors.gold)),
                      const SizedBox(width: 14),
                      Expanded(child: _metric('Borç', tl.format(summary.payable), AppColors.neutral600)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),

            // Son İşlemler
            _softCard(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Son İşlemler',
                    style: TextStyle(
                      color: AppColors.ink,
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ...transactions.map((t) => _txRow(context, t)).toList(),
                ],
              ),
            ),
            const SizedBox(height: 14),
          ],
        ),
      ),
    );
  }

  static Widget _softCard({
    required Widget child,
    EdgeInsetsGeometry padding = const EdgeInsets.all(16),
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardCream1,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Color(0x22000000),
            blurRadius: 10,
            offset: Offset(0, 4),
          )
        ],
      ),
      child: Container(
        margin: const EdgeInsets.all(2),
        padding: padding,
        decoration: BoxDecoration(
          color: AppColors.cardCream2,
          borderRadius: BorderRadius.circular(18),
        ),
        child: child,
      ),
    );
  }

  Widget _metric(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(.6),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: const TextStyle(color: AppColors.ink, fontSize: 14)),
          const SizedBox(height: 6),
          Text(
            value,
            style: TextStyle(
                color: color, fontSize: 18, fontWeight: FontWeight.w800),
          ),
        ],
      ),
    );
  }

  Widget _txRow(BuildContext context, TransactionItem t) {
    final isPos = t.amount >= 0;
    final amountStr = (isPos ? '+' : '') + tl.format(t.amount);

    final accountIcon = switch (t.account) {
      AccountType.cash => Icons.payments_outlined,
      AccountType.bank => Icons.account_balance_outlined,
      AccountType.creditCard => Icons.credit_card_outlined,
      _ => Icons.help_outline,
    };

    return InkWell(
      onTap: () {
        showDialog(
          context: context,
          builder: (_) => TransactionDetailsDialog(tx: t),
        );
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: 6),
        child: Row(
          children: [
            Icon(
              isPos ? Icons.north_east : Icons.south_east,
              size: 18,
              color: isPos ? AppColors.success : AppColors.danger,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Row(
                children: [
                  Text(
                    t.title,
                    style: const TextStyle(
                        color: AppColors.ink, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(width: 6),
                  Icon(accountIcon, size: 16, color: Colors.white70),
                ],
              ),
            ),
            Text(
              amountStr,
              style: TextStyle(
                color: isPos ? AppColors.success : AppColors.danger,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

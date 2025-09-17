import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:hesaptakip/core/theme/app_theme.dart';
import 'package:hesaptakip/features/dashboard/domain/models/finance_models.dart';

class TransactionDetailsDialog extends StatelessWidget {
  const TransactionDetailsDialog({super.key, required this.tx});

  final TransactionItem tx;

  @override
  Widget build(BuildContext context) {
    final tl = NumberFormat.currency(locale: 'tr_TR', symbol: '₺', decimalDigits: 2);

    // İşlem türü belirle
    final isIncome = tx.amount > 0;
    final typeLabel = tx.category;
    final typeColor = isIncome ? AppColors.success : AppColors.danger;

    // Hesap türü
    final accountLabel = switch (tx.account) {
      AccountType.cash => "Nakit",
      AccountType.bank => "Banka",
      AccountType.creditCard => "Kredi Kartı",
      _ => "Bilinmiyor",
    };

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      backgroundColor: AppColors.cardCream2,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Başlık + Kapat
            Row(
              children: [
                Expanded(
                  child: Text(
                    "İşlem Detayı",
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.ink,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.black54),
                  onPressed: () => Navigator.pop(context),
                )
              ],
            ),
            const SizedBox(height: 16),

            // Tür
            Row(
              children: [
                Icon(
                  isIncome ? Icons.trending_up : Icons.trending_down,
                  color: typeColor,
                ),
                const SizedBox(width: 8),
                Text(
                  typeLabel,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: typeColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Tutar
            RichText(
              text: TextSpan(
                children: [
                  const TextSpan(
                    text: "Tutar: ",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  TextSpan(
                    text: tl.format(tx.amount),
                    style: TextStyle(
                      fontSize: 16,

                      color: typeColor,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),

            // Tarih
            RichText(
              text: TextSpan(
                children: [
                  const TextSpan(
                    text: "Tarih: ",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  TextSpan(
                    text: DateFormat('d MMMM yyyy', 'tr_TR').format(tx.date),
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),

            // Hesap
            RichText(
              text: TextSpan(
                children: [
                  const TextSpan(
                    text: "Hesap: ",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  TextSpan(
                    text: accountLabel,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),

            // Açıklama (opsiyonel)
            if (tx.title.isNotEmpty) ...[
              const Text(
                "Açıklama:",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(
                tx.title,
                style: const TextStyle(fontSize: 16, color: Colors.black87),
              ),
              const SizedBox(height: 16),
            ],

            // 🔹 Düzenle Butonu
            const SizedBox(height: 12), // Alttan boşluk ekle
            Align(
              alignment: Alignment.center,
              child: SizedBox(
                width: 120, // daha küçük genişlik
                height: 36, // daha küçük yükseklik
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context); // pencereyi kapat
                    // TODO: burada düzenleme ekranı açılacak
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.gold,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: EdgeInsets.zero,
                  ),
                  child: const Text(
                    "Düzenle",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppColors.ink,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

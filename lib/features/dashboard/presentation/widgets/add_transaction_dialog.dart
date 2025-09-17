import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:hesaptakip/core/theme/app_theme.dart';
import 'package:hesaptakip/features/dashboard/domain/models/finance_models.dart';

enum TransactionType { income, expense, receivable, payable }

class AddTransactionDialog extends StatefulWidget {
  const AddTransactionDialog({
    super.key,
    required this.type,
    required this.onSaved,
    this.existing, // ← düzenleme için mevcut işlem (opsiyonel)
  });

  final TransactionType type;
  final Future<void> Function(TransactionItem) onSaved;
  final TransactionItem? existing;

  @override
  State<AddTransactionDialog> createState() => _AddTransactionDialogState();
}

class _AddTransactionDialogState extends State<AddTransactionDialog> {
  final formKey   = GlobalKey<FormState>();
  final amountCtrl = TextEditingController();
  final noteCtrl   = TextEditingController(); // modelde "note" yoksa da input tutabilir

  DateTime date    = DateTime.now();
  AccountType account = AccountType.cash;
  String? categoryId;

  @override
  void initState() {
    super.initState();
    final tx = widget.existing;
    if (tx != null) {
      // Mevcut verilerle doldur
      amountCtrl.text = tx.amount.abs().toStringAsFixed(2);
      date    = tx.date;
      account = tx.account;
      // categoryId'yi build içinde label eşleşmesiyle set edeceğiz
    }
  }

  @override
  void dispose() {
    amountCtrl.dispose();
    noteCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final type = widget.type;
    final isIncome = type == TransactionType.income;

    final title = switch (type) {
      TransactionType.income     => widget.existing == null ? 'Gelir Ekle'    : 'Gelir Düzenle',
      TransactionType.expense    => widget.existing == null ? 'Gider Ekle'    : 'Gider Düzenle',
      TransactionType.receivable => widget.existing == null ? 'Alacak Ekle'   : 'Alacak Düzenle',
      TransactionType.payable    => widget.existing == null ? 'Borç Ekle'     : 'Borç Düzenle',
    };

    final categories = switch (type) {
      TransactionType.income => <(String,String)>[
        ('salary','Maaş'), ('bonus','Prim'), ('side','Yan Gelir'), ('other','Diğer'),
      ],
      TransactionType.expense => <(String,String)>[
        ('market','Market'), ('bill','Fatura'), ('transport','Ulaşım'), ('rent','Kira'), ('other','Diğer'),
      ],
      _ => <(String,String)>[
        ('general','Genel'), ('other','Diğer'),
      ],
    };

    // Eğer düzenleme modundaysak ve henüz kategoriId set edilmediyse, başlığa göre tahmin et
    if (widget.existing != null && categoryId == null) {
      for (final c in categories) {
        if (c.$2 == widget.existing!.title) {
          categoryId = c.$1;
          break;
        }
      }
    }

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 380),
        child: Material(
          color: AppColors.cardCream2,
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(18, 18, 18, 12),
            child: StatefulBuilder(
              builder: (context, setStateDialog) {
                return Form(
                  key: formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Başlık + sağ üst saydam çarpı
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                title,
                                style: const TextStyle(
                                  color: AppColors.ink,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                            InkWell(
                              borderRadius: BorderRadius.circular(12),
                              onTap: () => Navigator.pop(context),
                              child: const Icon(Icons.close, size: 22, color: Colors.black54),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),

                        // Tutar
                        TextFormField(
                          controller: amountCtrl,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(hintText: 'Tutar (₺)'),
                          validator: (v) {
                            if (v == null || v.trim().isEmpty) return 'Tutar gerekli';
                            final parsed = double.tryParse(v.replaceAll(',', '.'));
                            if (parsed == null || parsed <= 0) return 'Geçerli bir tutar girin';
                            return null;
                          },
                        ),
                        const SizedBox(height: 10),

                        // Tarih
                        InkWell(
                          onTap: () async {
                            final now = DateTime.now();
                            final picked = await showDatePicker(
                              context: context,
                              initialDate: date,
                              firstDate: DateTime(now.year - 5),
                              lastDate: DateTime(now.year + 5),
                            );
                            if (picked != null) setStateDialog(() => date = picked);
                          },
                          child: InputDecorator(
                            decoration: const InputDecoration(hintText: 'Tarih'),
                            child: Text(DateFormat('d MMM yyyy', 'tr_TR').format(date)),
                          ),
                        ),
                        const SizedBox(height: 10),

                        // Hesap seçimi (segmented)
                        Row(
                          children: AccountType.values.map((acc) {
                            final selected = account == acc;
                            final label = switch (acc) {
                              AccountType.cash => 'Nakit',
                              AccountType.bank => 'Banka',
                              AccountType.creditCard => 'K.Kartı',
                            };
                            return Expanded(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 4),
                                child: OutlinedButton(
                                  style: OutlinedButton.styleFrom(
                                    backgroundColor: selected ? Colors.white.withOpacity(.7) : Colors.transparent,
                                    side: BorderSide(color: selected ? AppColors.gold : Colors.white30),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                  ),
                                  onPressed: () => setStateDialog(() => account = acc),
                                  child: Text(
                                    label,
                                    style: TextStyle(
                                      color: selected ? AppColors.ink : Colors.black87,
                                      fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 10),

                        // Kategori chipleri
                        Wrap(
                          spacing: 8, runSpacing: 8,
                          children: categories.map((c) {
                            final selected = categoryId == c.$1;
                            return ChoiceChip(
                              label: Text(c.$2),
                              selected: selected,
                              onSelected: (_) => setStateDialog(() => categoryId = c.$1),
                              selectedColor: Colors.white,
                              labelStyle: TextStyle(
                                color: selected ? AppColors.ink : Colors.black87,
                                fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                              ),
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 10),

                        // Not (opsiyonel girdi – modelde saklamıyorsan sadece kullanıcıya yardım olur)
                        TextFormField(
                          controller: noteCtrl,
                          minLines: 2, maxLines: 4,
                          decoration: const InputDecoration(hintText: 'Not (opsiyonel)'),
                        ),
                        const SizedBox(height: 14),

                        // Kaydet
                        SizedBox(
                          width: double.infinity, height: 52,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.gradientBottomDeep,
                              foregroundColor: AppColors.gold,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            onPressed: () async {
                              if (!(formKey.currentState?.validate() ?? false)) return;
                              if (categoryId == null) {
                                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Kategori seçin')));
                                return;
                              }

                              final parsed = double.tryParse(amountCtrl.text.replaceAll(',', '.')) ?? 0;
                              if (parsed <= 0) {
                                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Geçerli bir tutar girin')));
                                return;
                              }

                              double signed = parsed;
                              if (type == TransactionType.expense || type == TransactionType.payable) {
                                signed = -parsed;
                              }

                              final catLabel = categories.firstWhere((c) => c.$1 == categoryId).$2;

                              final tx = TransactionItem(
                                title: catLabel,
                                category: isIncome ? 'Gelir' : (type == TransactionType.expense ? 'Gider' : catLabel),
                                amount: signed,
                                date: date,
                                account: account,
                                // NOT: Eğer modeline note eklediğinde burada ilet:
                                // note: noteCtrl.text.trim().isEmpty ? null : noteCtrl.text.trim(),
                              );

                              await widget.onSaved(tx);

                              if (mounted) {
                                Navigator.pop(context);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(widget.existing == null ? 'Eklendi' : 'Güncellendi')),
                                );
                              }
                            },
                            child: Text(
                              widget.existing == null ? 'Kaydet' : 'Kaydet (Güncelle)',
                              style: const TextStyle(fontWeight: FontWeight.w800),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

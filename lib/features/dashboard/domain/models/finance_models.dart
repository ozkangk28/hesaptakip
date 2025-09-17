// lib/features/dashboard/domain/models/finance_models.dart
import 'package:flutter/foundation.dart';

/// Hesap tipi (domain seviyesinde)
enum AccountType { cash, bank, creditCard }

class TransactionItem {
  final String title;        // örn: "Market", "Maaş"
  final String category;     // örn: "Gider", "Gelir" veya "Market", "Prim"
  final double amount;       // Gelir: +; Gider: - (işarete göre özet yapılır)
  final DateTime date;
  final AccountType account; // ✅ Nakit/Banka/K.Kartı
  final String? note;

  TransactionItem({
    required this.title,
    required this.category,
    required this.amount,
    required this.date,
    required this.account,
    this.note,
  });
}

class BudgetSummary {
  final double totalBudget;
  final double income;
  final double expense;
  final double receivable;
  final double payable;

  const BudgetSummary({
    required this.totalBudget,
    required this.income,
    required this.expense,
    required this.receivable,
    required this.payable,
  });
}

class DashboardData {
  final String userName;
  final BudgetSummary summary;
  final List<TransactionItem> lastTransactions;

  const DashboardData({
    required this.userName,
    required this.summary,
    required this.lastTransactions,
  });
}

// lib/features/dashboard/data/repositories/finance_repository_mock.dart
import 'dart:math';
import 'package:hesaptakip/features/dashboard/domain/models/finance_models.dart';
import 'package:hesaptakip/features/dashboard/domain/repositories/finance_repository.dart';

class FinanceRepositoryMock implements FinanceRepository {
  // Başlangıç bakiyesi (demoda bütçeyi buradan hesaplayacağız)
  double _baseBudget = 22450.50;

  // Mock işlem listesi (en güncel en başta)
  final List<TransactionItem> _tx = [
    TransactionItem(
      title: 'Market',
      category: 'Gider',
      amount: -240.0,
      date: DateTime.now(),
      account: AccountType.cash,
    ),
    TransactionItem(
      title: 'Maaş',
      category: 'Gelir',
      amount: 8200.0,
      date: DateTime.now().subtract(const Duration(days: 1)),
      account: AccountType.bank,
    ),
    TransactionItem(
      title: 'Elektrik',
      category: 'Fatura',
      amount: -430.0,
      date: DateTime.now().subtract(const Duration(days: 2)),
      account: AccountType.bank,
    ),
    TransactionItem(
      title: 'Prim',
      category: 'Gelir',
      amount: 750.0,
      date: DateTime.now().subtract(const Duration(days: 3)),
      account: AccountType.bank,
    ),
    TransactionItem(
      title: 'Kira',
      category: 'Gider',
      amount: -4000.0,
      date: DateTime.now().subtract(const Duration(days: 4)),
      account: AccountType.cash,
    ),
  ];

  @override
  Future<DashboardData> fetchDashboard() async {
    // İstersen mini gecikme (UI donmasın diye şimdilik kapalı)
    // await Future.delayed(const Duration(milliseconds: 120));

    final income  = _tx.where((t) => t.amount > 0).fold<double>(0.0, (s, t) => s + t.amount);
    final expense = _tx.where((t) => t.amount < 0).fold<double>(0.0, (s, t) => s + t.amount.abs());

    // Bu demoda alacak/borç hesaplamıyoruz (ileride TransactionKind ekleyebiliriz)
    final receivable = 2000.0;
    final payable    = 12300.0;

    final totalBudget = _baseBudget + _tx.fold<double>(0.0, (s, t) => s + t.amount);

    final summary = BudgetSummary(
      totalBudget: totalBudget,
      income: income,
      expense: expense,
      receivable: receivable,
      payable: payable,
    );

    return DashboardData(
      userName: 'Seçkin',
      summary: summary,
      lastTransactions: List.unmodifiable(_tx),
    );
  }

  @override
  Future<void> addTransaction(TransactionItem tx) async {
    // En başa ekle (son işlem olarak görünsün)
    _tx.insert(0, tx);
    // Gerçek dünyada burada persist işlemi olurdu.
  }
}

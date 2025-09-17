// lib/features/dashboard/domain/repositories/finance_repository.dart
import 'package:hesaptakip/features/dashboard/domain/models/finance_models.dart';

abstract class FinanceRepository {
  Future<DashboardData> fetchDashboard();

  /// Yeni işlem ekleme (Gelir/Gider/Alacak/Borç)
  Future<void> addTransaction(TransactionItem tx);
}

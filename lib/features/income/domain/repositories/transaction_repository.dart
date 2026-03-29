import '../entities/transaction.dart';

abstract class TransactionRepository {
  Stream<List<Transaction>> getTransactions(String type);
  Future<void> addTransaction(String type, Transaction transaction);
  Future<void> updateTransaction(String type, Transaction transaction);
  Future<void> deleteTransaction(String type, String transactionId);
  Future<void> toggleTransactionStatus(String type, String transactionId, bool isActive);
}

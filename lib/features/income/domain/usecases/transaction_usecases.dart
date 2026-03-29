import '../entities/transaction.dart';
import '../repositories/transaction_repository.dart';

class GetTransactions {
  final TransactionRepository repository;

  GetTransactions(this.repository);

  Stream<List<Transaction>> call(String type) {
    return repository.getTransactions(type);
  }
}

class AddTransaction {
  final TransactionRepository repository;

  AddTransaction(this.repository);

  Future<void> call(String type, Transaction transaction) {
    return repository.addTransaction(type, transaction);
  }
}

class ToggleTransactionStatus {
  final TransactionRepository repository;

  ToggleTransactionStatus(this.repository);

  Future<void> call(String type, String transactionId, bool isActive) {
    return repository.toggleTransactionStatus(type, transactionId, isActive);
  }
}

class UpdateTransaction {
  final TransactionRepository repository;

  UpdateTransaction(this.repository);

  Future<void> call(String type, Transaction transaction) {
    return repository.updateTransaction(type, transaction);
  }
}

class DeleteTransaction {
  final TransactionRepository repository;

  DeleteTransaction(this.repository);

  Future<void> call(String type, String transactionId) {
    return repository.deleteTransaction(type, transactionId);
  }
}

import 'package:cloud_firestore/cloud_firestore.dart' hide Transaction;
import '../models/transaction_model.dart';
import '../../domain/entities/transaction.dart';

abstract class TransactionRemoteDataSource {
  Stream<List<TransactionModel>> getTransactions(String userId, String type);
  Future<void> addTransaction(String userId, String type, Transaction transaction);
  Future<void> updateTransaction(String userId, String type, Transaction transaction);
  Future<void> deleteTransaction(String userId, String type, String transactionId);
  Future<void> toggleTransactionStatus(String userId, String type, String transactionId, bool isActive);
}

class TransactionRemoteDataSourceImpl implements TransactionRemoteDataSource {
  final FirebaseFirestore firestore;

  TransactionRemoteDataSourceImpl({required this.firestore});

  @override
  Stream<List<TransactionModel>> getTransactions(String userId, String type) {
    return firestore
        .collection('users')
        .doc(userId)
        .collection(type) // 'income' or 'expense'
        .orderBy('date', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => TransactionModel.fromFirestore(doc))
            .toList());
  }

  @override
  Future<void> addTransaction(String userId, String type, Transaction transaction) async {
    final model = TransactionModel(
      id: transaction.id,
      title: transaction.title,
      amount: transaction.amount,
      date: transaction.date,
      isActive: transaction.isActive,
    );
    await firestore
        .collection('users')
        .doc(userId)
        .collection(type)
        .doc(transaction.id)
        .set(model.toFirestore());
  }

  @override
  Future<void> updateTransaction(String userId, String type, Transaction transaction) async {
    final model = TransactionModel(
      id: transaction.id,
      title: transaction.title,
      amount: transaction.amount,
      date: transaction.date,
      isActive: transaction.isActive,
    );
    await firestore
        .collection('users')
        .doc(userId)
        .collection(type)
        .doc(transaction.id)
        .update(model.toFirestore());
  }

  @override
  Future<void> deleteTransaction(String userId, String type, String transactionId) async {
    await firestore
        .collection('users')
        .doc(userId)
        .collection(type)
        .doc(transactionId)
        .delete();
  }

  @override
  Future<void> toggleTransactionStatus(String userId, String type, String transactionId, bool isActive) async {
    await firestore
        .collection('users')
        .doc(userId)
        .collection(type)
        .doc(transactionId)
        .update({'isActive': isActive});
  }
}

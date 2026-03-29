import 'package:firebase_auth/firebase_auth.dart';
import '../../domain/entities/transaction.dart';
import '../../domain/repositories/transaction_repository.dart';
import '../datasources/transaction_remote_data_source.dart';

class TransactionRepositoryImpl implements TransactionRepository {
  final TransactionRemoteDataSource remoteDataSource;
  final FirebaseAuth firebaseAuth;

  TransactionRepositoryImpl({
    required this.remoteDataSource,
    required this.firebaseAuth,
  });

  String get _userId {
    final user = firebaseAuth.currentUser;
    if (user == null) {
      throw Exception("User is not authenticated");
    }
    return user.uid;
  }

  @override
  Stream<List<Transaction>> getTransactions(String type) {
    return remoteDataSource.getTransactions(_userId, type).map(
      (models) => models.map((model) => model as Transaction).toList()
    );
  }

  @override
  Future<void> addTransaction(String type, Transaction transaction) async {
    await remoteDataSource.addTransaction(_userId, type, transaction);
  }

  @override
  Future<void> toggleTransactionStatus(String type, String transactionId, bool isActive) async {
    await remoteDataSource.toggleTransactionStatus(_userId, type, transactionId, isActive);
  }
}

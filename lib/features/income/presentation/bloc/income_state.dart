part of 'income_bloc.dart';

abstract class IncomeState extends Equatable {
  const IncomeState();

  @override
  List<Object?> get props => [];
}

class IncomeInitial extends IncomeState {
  const IncomeInitial();
}

class IncomeLoading extends IncomeState {
  const IncomeLoading();
}

class IncomeLoaded extends IncomeState {
  final List<Transaction> transactions;

  const IncomeLoaded({required this.transactions});

  @override
  List<Object?> get props => [transactions];
}

class IncomeError extends IncomeState {
  final String message;

  const IncomeError({required this.message});

  @override
  List<Object?> get props => [message];
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:pocket_plan/core/presentation/widgets/add_transaction_bottom_sheet.dart';
import 'package:pocket_plan/core/presentation/widgets/transaction_tile.dart';
import 'package:pocket_plan/features/income/domain/entities/transaction.dart';
import 'package:pocket_plan/features/income/presentation/bloc/income_bloc.dart';

/// IncomeScreen does NOT own its Scaffold — it is embedded inside BaseLayout
/// via MainNavigation. The BlocProvider is injected from MainNavigation.
class IncomeScreen extends StatelessWidget {
  const IncomeScreen({super.key});

  void _showAddSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => BlocProvider.value(
        value: context.read<IncomeBloc>(),
        child: AddTransactionBottomSheet(
          label: 'Source',
          onAdd: (title, amount, date) {
            context.read<IncomeBloc>().add(
                  AddIncomeTransaction(
                    transaction: Transaction(
                      id: 'inc_${DateTime.now().millisecondsSinceEpoch}',
                      title: title,
                      amount: amount,
                      date: date,
                    ),
                  ),
                );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<IncomeBloc, IncomeState>(
      builder: (context, state) {
        if (state is IncomeLoading || state is IncomeInitial) {
          return const Center(
            child: CircularProgressIndicator(color: Color(0xFF006B5F)),
          );
        }

        if (state is IncomeError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, color: Colors.red, size: 48),
                const SizedBox(height: 12),
                Text(state.message,
                    style: const TextStyle(color: Colors.red)),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => context
                      .read<IncomeBloc>()
                      .add(const LoadIncomeTransactions()),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF006B5F),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        if (state is IncomeLoaded) {
          final transactions = state.transactions;
          return Column(
            children: [
              Expanded(
                child: transactions.isEmpty
                    ? const Center(
                        child: Text(
                          'No income transactions yet.\nTap + to add one.',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.grey),
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        itemCount: transactions.length,
                        itemBuilder: (context, index) {
                          final t = transactions[index];
                          final formattedDate =
                              DateFormat('dd MMM yyyy').format(t.date);
                          return TransactionTile(
                            title: t.title,
                            date: formattedDate,
                            amount: t.amount,
                            isActive: t.isActive,
                            onToggle: (val) {
                              context.read<IncomeBloc>().add(
                                    ToggleIncomeTransactionStatus(
                                        id: t.id, value: val),
                                  );
                            },
                          );
                        },
                      ),
              ),
              // Bottom action bar: Load More + FAB
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: () => context
                          .read<IncomeBloc>()
                          .add(const LoadMoreIncomeTransactions()),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF006B5F),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 14),
                      ),
                      child: const Text('Load More'),
                    ),
                    FloatingActionButton(
                      heroTag: 'income_fab',
                      onPressed: () => _showAddSheet(context),
                      backgroundColor: const Color(0xFF006B5F),
                      foregroundColor: Colors.white,
                      child: const Icon(Icons.add),
                    ),
                  ],
                ),
              ),
            ],
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}

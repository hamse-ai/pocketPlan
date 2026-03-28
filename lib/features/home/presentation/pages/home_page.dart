import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pocket_plan/features/budget/presentation/bloc/expense_bloc.dart';
import 'package:pocket_plan/features/income/presentation/bloc/income_bloc.dart';
import 'package:intl/intl.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<IncomeBloc, IncomeState>(
      builder: (context, incomeState) {
        return BlocBuilder<ExpenseBloc, ExpenseState>(
          builder: (context, expenseState) {
            double totalIncome = 0;
            if (incomeState is IncomeLoaded) {
              totalIncome = incomeState.transactions.fold(
                  0, (sum, item) => sum + item.amount);
            }

            double totalExpense = 0;
            if (expenseState is ExpenseLoaded) {
              totalExpense = expenseState.transactions.fold(
                  0, (sum, item) => sum + item.amount);
            }

            double currentBalance = totalIncome - totalExpense;

            final now = DateTime.now();
            final lastDayOfMonth = DateTime(now.year, now.month + 1, 0);
            final daysLeft = lastDayOfMonth.day - now.day + 1;
            
            // Assume 20% of income should be saved, or safe to spend is 80% of current balance
            double safeToSpend = currentBalance > 0 ? (currentBalance * 0.8) : 0;

            // Lean period logic: if average daily budget left is less than 3000 RWF
            double dailyBudget = daysLeft > 0 ? currentBalance / daysLeft : 0;
            bool isLeanPeriod = dailyBudget > 0 && dailyBudget < 3000;
            if (currentBalance <= 0) {
              isLeanPeriod = true;
            }

            final currentMonth = DateFormat('MMMM').format(now);

            return Scaffold(
               backgroundColor: const Color(0xFFF2F4F3),
              body: Column(
                children: [
                  _buildHeader(),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          _buildBalanceCard(currentBalance),
                          const SizedBox(height: 12),
                          _buildSafeToSpendCard(safeToSpend, currentMonth),
                          const SizedBox(height: 12),
                          if (isLeanPeriod) ...[
                            _buildWarningBanner(daysLeft),
                            const SizedBox(height: 12),
                          ],
                          _buildEmergencySavingCard(),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(24, 56, 24, 28),
      decoration: const BoxDecoration(
        color: Color(0xFF1B3A3A),
      ),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: const BoxDecoration(
              color: Color(0xFF4CAF50),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.chevron_right,
              color: Colors.white,
              size: 30,
            ),
          ),
          const SizedBox(width: 14),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                'Pocketplan',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
              Text(
                'Master Your Money',
                style: TextStyle(
                  color: Color(0xFFB2DFDB),
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBalanceCard(double balance) {
    final currencyFormatter = NumberFormat.currency(symbol: 'RWF ', decimalDigits: 0);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1B3A3A),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Current Balance',
            style: TextStyle(
              color: Color(0xFFB2DFDB),
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            currencyFormatter.format(balance),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          GestureDetector(
            onTap: () {},
            child: const Text(
              'See Details',
              style: TextStyle(
                color: Color(0xFF4CAF50),
                fontSize: 13,
                decoration: TextDecoration.underline,
                decorationColor: Color(0xFF4CAF50),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSafeToSpendCard(double safeAmount, String monthName) {
    final currencyFormatter = NumberFormat.currency(symbol: 'RWF ', decimalDigits: 0);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Safe to Spend',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1B3A3A),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'For $monthName',
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
          Text(
            currencyFormatter.format(safeAmount),
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1B3A3A),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWarningBanner(int daysLeft) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFEBEE),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFFFCDD2)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.warning_amber_rounded,
            color: Color(0xFFE53935),
            size: 22,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Lean Period Ahead',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFB71C1C),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Try to reduce spending for the next $daysLeft days',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFFE53935),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmergencySavingCard() {
    const double savedPercent = 0.80;
    final currencyFormatter = NumberFormat.currency(symbol: 'RWF ', decimalDigits: 0);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Current Emergency Saving',
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey,
                ),
              ),
              Text(
                currencyFormatter.format(400000), // Adjusted relative to 500k target
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1B3A3A),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          const Text(
            'Emergency Buffer',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1B3A3A),
            ),
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: const LinearProgressIndicator(
              value: savedPercent,
              minHeight: 10,
              backgroundColor: Color(0xFFE0E0E0),
              valueColor: AlwaysStoppedAnimation<Color>(
                Color(0xFF4CAF50),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Saved: 80%',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
              Text(
                'Target: ${currencyFormatter.format(500000)}',
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
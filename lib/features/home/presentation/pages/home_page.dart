import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pocket_plan/features/budget/presentation/bloc/expense_bloc.dart';
import 'package:pocket_plan/features/income/presentation/bloc/income_bloc.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  double _savingPercentage = 20.0; // Default 20%

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

            double rawBalance = totalIncome - totalExpense;

            // Calculations based on slider
            double savedAmount = rawBalance > 0 ? rawBalance * (_savingPercentage / 100) : 0;
            double safeToSpend = rawBalance > 0 ? rawBalance - savedAmount : 0;
            double baseEmergencySaving = 400000;
            double totalEmergencySaving = baseEmergencySaving + savedAmount;

            final now = DateTime.now();
            final lastDayOfMonth = DateTime(now.year, now.month + 1, 0);
            final daysLeft = lastDayOfMonth.day - now.day + 1;

            // Lean period logic based on Safe To Spend instead of raw balance
            double dailyBudget = daysLeft > 0 ? safeToSpend / daysLeft : 0;
            bool isLeanPeriod = dailyBudget > 0 && dailyBudget < 3000;
            if (safeToSpend <= 0 && rawBalance > 0) {
              isLeanPeriod = true;
            } else if (rawBalance <= 0) {
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
                          _buildSavingsUI(),
                          const SizedBox(height: 12),
                          _buildSafeToSpendCard(safeToSpend, currentMonth),
                          const SizedBox(height: 12),
                          if (isLeanPeriod) ...[
                            _buildWarningBanner(daysLeft),
                            const SizedBox(height: 12),
                          ],
                          _buildEmergencySavingCard(totalEmergencySaving),
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

  Widget _buildSavingsUI() {
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Savings Allocation',
                style: TextStyle(
                  color: Color(0xFFB2DFDB),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                '${_savingPercentage.toInt()}%',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: const Color(0xFF4CAF50),
              inactiveTrackColor: Colors.white24,
              thumbColor: Colors.white,
              overlayColor: const Color(0xFF4CAF50).withAlpha(50), // Replaced withAlpha for compatibility
              trackHeight: 6.0,
            ),
            child: Slider(
              value: _savingPercentage,
              min: 0,
              max: 100,
              divisions: 20,
              onChanged: (value) {
                setState(() {
                  _savingPercentage = value;
                });
              },
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Adjust how much of your balance goes to Emergency Savings.',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 12,
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

  Widget _buildEmergencySavingCard(double totalEmergencySaving) {
    double target = 500000;
    double savedPercent = (totalEmergencySaving / target).clamp(0.0, 1.0);
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
                currencyFormatter.format(totalEmergencySaving),
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
            child: LinearProgressIndicator(
              value: savedPercent,
              minHeight: 10,
              backgroundColor: const Color(0xFFE0E0E0),
              valueColor: const AlwaysStoppedAnimation<Color>(
                Color(0xFF4CAF50),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Saved: ${(savedPercent * 100).toStringAsFixed(0)}%',
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
              Text(
                'Target: ${currencyFormatter.format(target)}',
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
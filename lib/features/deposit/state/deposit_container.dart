import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../model/deposit_account.dart';
import '../screens/deposit_list_screen.dart';
import 'deposit_cubit.dart';

class DepositContainer extends StatelessWidget {
  final int initialAmount;
  final ValueChanged<int> onAmountChanged;

  const DepositContainer({
    super.key,
    required this.initialAmount,
    required this.onAmountChanged,
  });

  Future<void> _navigateToAddDeposit(BuildContext context) async {
    final result = await context.push<Map<String, double>>('/deposits/add');

    if (result != null && context.mounted) {
      final amount = result['amount']!;
      final percent = result['percent']!;
      context.read<DepositCubit>().addDeposit(
            DepositAccount(amount: amount, annualPercent: percent),
          );
    }
  }

  String get _explanation =>
      'Выплаты по вкладу происходят раз в год, поэтому годовой доход '
          'рассчитывается автоматически и отображается отдельно. Сумму вклада и '
          'годовой процент вводите вручную — годовой доход вычисляет приложение.';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => DepositCubit(initialAmount: initialAmount),
      child: BlocListener<DepositCubit, DepositState>(
        listener: (context, state) {
          onAmountChanged(state.totalAmountRounded);
        },
        child: Scaffold(
          appBar: AppBar(title: const Text('Вклады')),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: BlocBuilder<DepositCubit, DepositState>(
              builder: (context, state) {
                return DepositListScreen(
                  explanation: _explanation,
                  deposits: state.deposits,
                  totalAmount: state.totalAmount,
                  totalAnnualIncome: state.totalAnnualIncome,
                  onAddTap: () => _navigateToAddDeposit(context),
                  onRemoveAt: (index) {
                    context.read<DepositCubit>().removeDepositAt(index);
                  },
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

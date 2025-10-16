// deposit_container.dart
import 'package:flutter/material.dart';
import '../../../shared/uikit/finance_widgets.dart';
import '../model/deposit_account.dart';
import '../screens/deposit_list_screen.dart';
import '../screens/deposit_add_screen.dart';

enum DepositScreenState { list, adding }

class DepositContainer extends StatefulWidget {
  final int initialAmount;
  final ValueChanged<int> onAmountChanged;

  const DepositContainer({
    super.key,
    required this.initialAmount,
    required this.onAmountChanged,
  });

  @override
  State<DepositContainer> createState() => _DepositContainerState();
}

class _DepositContainerState extends State<DepositContainer> {
  final List<DepositAccount> _depositAccounts = [];
  DepositScreenState _currentState = DepositScreenState.list;

  @override
  void initState() {
    super.initState();
    if (widget.initialAmount != 0) {
      _depositAccounts.add(
        DepositAccount(
          amount: widget.initialAmount.toDouble(),
          annualPercent: 0.0,
        ),
      );
    }
  }

  @override
  void dispose() {
    widget.onAmountChanged(_totalAmountRounded());
    super.dispose();
  }

  double _totalAmount() => _depositAccounts.fold(0.0, (s, d) => s + d.amount);

  int _totalAmountRounded() => _totalAmount().round();

  double _totalAnnualIncome() =>
      _depositAccounts.fold(0.0, (s, d) => s + d.annualIncome);

  void _startAdding() {
    setState(() {
      _currentState = DepositScreenState.adding;
    });
  }

  void _applyAdd(double amount, double percent) {
    setState(() {
      _depositAccounts.add(
        DepositAccount(amount: amount, annualPercent: percent),
      );
      _currentState = DepositScreenState.list;
    });
  }

  void _removeAt(int index) {
    setState(() {
      if (index >= 0 && index < _depositAccounts.length) {
        _depositAccounts.removeAt(index);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final explanation =
        'Выплаты по вкладу происходят раз в год, поэтому годовой доход '
        'рассчитывается автоматически и отображается отдельно. Сумму вклада и '
        'годовой процент вводите вручную — годовой доход вычисляет приложение.';

    return Scaffold(
      appBar: AppBar(title: const Text('Вклады')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _currentState == DepositScreenState.list
            ? DepositListScreen(
                explanation: explanation,
                deposits: List.unmodifiable(_depositAccounts),
                totalAmount: _totalAmount(),
                totalAnnualIncome: _totalAnnualIncome(),
                onAddTap: _startAdding,
                onRemoveAt: _removeAt,
              )
            : DepositAddScreen(explanation: explanation, onApply: _applyAdd),
      ),
    );
  }
}

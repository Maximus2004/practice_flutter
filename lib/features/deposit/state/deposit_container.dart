import 'package:flutter/material.dart';
import '../model/deposit_account.dart';
import '../screens/deposit_list_screen.dart';
import '../screens/deposit_add_screen.dart';

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

  void _removeAt(int index) {
    setState(() {
      if (index >= 0 && index < _depositAccounts.length) {
        _depositAccounts.removeAt(index);
      }
    });
  }

  void _navigateToAddDeposit() async {
    final result = await Navigator.push<Map<String, double>>(
      context,
      MaterialPageRoute(
        builder: (_) => DepositAddScreen(
          explanation: _explanation,
        ),
      ),
    );

    if (result != null) {
      final amount = result['amount']!;
      final percent = result['percent']!;
      setState(() {
        _depositAccounts.add(
          DepositAccount(amount: amount, annualPercent: percent),
        );
      });
    }
  }

  String get _explanation =>
      'Выплаты по вкладу происходят раз в год, поэтому годовой доход '
          'рассчитывается автоматически и отображается отдельно. Сумму вклада и '
          'годовой процент вводите вручную — годовой доход вычисляет приложение.';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Вклады')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: DepositListScreen(
          explanation: _explanation,
          deposits: List.unmodifiable(_depositAccounts),
          totalAmount: _totalAmount(),
          totalAnnualIncome: _totalAnnualIncome(),
          onAddTap: _navigateToAddDeposit,
          onRemoveAt: _removeAt,
        ),
      ),
    );
  }
}

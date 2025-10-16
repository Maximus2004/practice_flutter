import 'package:flutter/material.dart';
import '../../../shared/uikit/finance_widgets.dart';
import '../model/checking_account.dart';

class AmountCheckingScreen extends StatefulWidget {
  final int initialAmount;
  final ValueChanged<int> onAmountChanged;

  const AmountCheckingScreen({
    super.key,
    required this.initialAmount,
    required this.onAmountChanged,
  });

  @override
  State<AmountCheckingScreen> createState() =>
      _ModifyAmountCheckingScreen();
}

class _ModifyAmountCheckingScreen extends State<AmountCheckingScreen> {
  final List<CheckingAccount> _checkingAccounts = [];

  @override
  void initState() {
    super.initState();
    if (widget.initialAmount != 0) {
      _checkingAccounts.add(CheckingAccount(
        amount: widget.initialAmount.toDouble(),
        annualPercent: 0.0,
      ));
    }
  }

  @override
  void dispose() {
    widget.onAmountChanged(_totalAmountRounded());
    super.dispose();
  }

  double _totalAmount() =>
      _checkingAccounts.fold(0.0, (s, a) => s + a.amount);

  int _totalAmountRounded() => _totalAmount().round();

  double _totalDailyIncome() =>
      _checkingAccounts.fold(0.0, (s, a) => s + a.dailyIncome);

  void _addAccount(double amount, double percent) {
    setState(() {
      _checkingAccounts.add(CheckingAccount(
        amount: amount,
        annualPercent: percent,
      ));
    });
  }

  void _removeAt(int index) {
    setState(() {
      _checkingAccounts.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    final explanation =
        'Расчётный счёт предполагает ежедневный доход, поэтому ежедневный доход '
        'рассчитывается автоматически и отображается отдельно. Сумму и годовой '
        'процент вводите вручную — доход вычисляет приложение.';
    final items = List<AccountDisplay>.generate(
      _checkingAccounts.length,
          (i) {
        final acc = _checkingAccounts[i];
        return AccountDisplay(
          amount: acc.amount,
          percent: acc.annualPercent,
          income: acc.dailyIncome,
          onDelete: () => _removeAt(i),
        );
      },
    );

    return Scaffold(
      appBar: AppBar(title: const Text("Добавить расчётный счёт")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ExplanationText(explanation),
            const SizedBox(height: 16),
            Text(
              'Общая сумма на расчётных счетах: ${formatMoney(_totalAmount())}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Суммарный ежедневный доход: ${formatMoney(_totalDailyIncome())}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            AmountPercentInput(
              amountLabel: 'Сумма (₽)',
              percentLabel: 'Годовой %',
              buttonText: 'Добавить',
              onAdd: _addAccount,
            ),
            const SizedBox(height: 12),
            const Text(
              'Список расчётных счетов (нажмите на счёт, чтобы удалить):',
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: AccountList(
                items: items,
                emptyMessage: 'Счётов пока нет',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

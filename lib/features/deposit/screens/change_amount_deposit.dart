import 'package:flutter/material.dart';
import '../../../shared/uikit/finance_widgets.dart';
import '../model/deposit_account.dart';

class AmountDepositScreen extends StatefulWidget {
  final int initialAmount;
  final ValueChanged<int> onAmountChanged;

  const AmountDepositScreen({
    super.key,
    required this.initialAmount,
    required this.onAmountChanged,
  });

  @override
  State<AmountDepositScreen> createState() =>
      _ModifyAmountDepositScreen();
}

class _ModifyAmountDepositScreen extends State<AmountDepositScreen> {
  final List<DepositAccount> _depositAccounts = [];

  @override
  void initState() {
    super.initState();
    if (widget.initialAmount != 0) {
      _depositAccounts.add(DepositAccount(
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

  double _totalAmount() => _depositAccounts.fold(0.0, (s, d) => s + d.amount);
  int _totalAmountRounded() => _totalAmount().round();
  double _totalAnnualIncome() =>
      _depositAccounts.fold(0.0, (s, d) => s + d.annualIncome);

  void _addDeposit(double amount, double percent) {
    setState(() {
      _depositAccounts.add(DepositAccount(
        amount: amount,
        annualPercent: percent,
      ));
    });
  }

  void _removeAt(int index) {
    setState(() {
      _depositAccounts.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    final explanation =
        'Выплаты по вкладу происходят раз в год, поэтому годовой доход '
        'рассчитывается автоматически и отображается отдельно. Сумму вклада и '
        'годовой процент вводите вручную — годовой доход вычисляет приложение.';

    final items = List<AccountDisplay>.generate(
      _depositAccounts.length,
          (i) {
        final d = _depositAccounts[i];
        return AccountDisplay(
          amount: d.amount,
          percent: d.annualPercent,
          income: d.annualIncome,
          onDelete: () => _removeAt(i),
        );
      },
    );

    return Scaffold(
      appBar: AppBar(title: const Text("Вклады")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ExplanationText(explanation),
            const SizedBox(height: 16),
            Text(
              'Общая сумма на вкладах: ${formatMoney(_totalAmount())}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Суммарный годовой доход: ${formatMoney(_totalAnnualIncome())}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            AmountPercentInput(
              amountLabel: 'Сумма вклада (₽)',
              percentLabel: 'Годовой %',
              buttonText: 'Добавить',
              onAdd: _addDeposit,
              computePreview: (a, p) => a * (p / 100.0),
            ),
            const SizedBox(height: 12),
            const Text(
              'Список вкладов (нажмите на вклад, чтобы удалить):',
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: AccountList(
                items: items,
                emptyMessage: 'Вкладов пока нет',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

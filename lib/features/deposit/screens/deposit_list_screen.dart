import 'package:flutter/material.dart';
import '../../../shared/uikit/finance_widgets.dart';
import '../model/deposit_account.dart';

class DepositListScreen extends StatelessWidget {
  final String explanation;
  final List<DepositAccount> deposits;
  final double totalAmount;
  final double totalAnnualIncome;
  final VoidCallback onAddTap;
  final ValueChanged<int> onRemoveAt;

  const DepositListScreen({
    super.key,
    required this.explanation,
    required this.deposits,
    required this.totalAmount,
    required this.totalAnnualIncome,
    required this.onAddTap,
    required this.onRemoveAt,
  });

  @override
  Widget build(BuildContext context) {
    final items = List<AccountDisplay>.generate(
      deposits.length,
          (i) {
        final d = deposits[i];
        return AccountDisplay(
          amount: d.amount,
          percent: d.annualPercent,
          income: d.annualIncome,
          onDelete: () => onRemoveAt(i),
        );
      },
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ExplanationText(explanation),
        const SizedBox(height: 16),
        Text(
          'Общая сумма на вкладах: ${formatMoney(totalAmount)}',
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          'Суммарный годовой доход: ${formatMoney(totalAnnualIncome)}',
          style: const TextStyle(fontSize: 16),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            ElevatedButton.icon(
              onPressed: onAddTap,
              icon: const Icon(Icons.add),
              label: const Text('Добавить вклад'),
            ),
            const SizedBox(width: 12),
          ],
        ),
        const SizedBox(height: 12),
        const Text(
          'Список вкладов (нажмите на вклад или на иконку удаления, чтобы удалить):',
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
    );
  }
}

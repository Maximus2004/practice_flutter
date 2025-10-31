import 'package:cached_network_image/cached_network_image.dart';
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
    const String imageUrl = "https://cdn-icons-png.flaticon.com/512/125/125513.png";
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
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CachedNetworkImage(
          imageUrl: imageUrl,
          height: 300,
          width: 300,
          imageBuilder: (context, imageProvider) => CircleAvatar(
            backgroundImage: imageProvider,
            radius: 100,
          ),
          progressIndicatorBuilder: (context, url, progress) =>
          const CircularProgressIndicator(),
          errorWidget: (context, url, error) => const Icon(
              Icons.error,
              color: Colors.red,
              size: 60
          ),
        ),
        const SizedBox(height: 16, width: double.infinity),
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

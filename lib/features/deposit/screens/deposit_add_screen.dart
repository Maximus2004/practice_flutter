import 'package:flutter/material.dart';
import '../../../shared/uikit/finance_widgets.dart';

class DepositAddScreen extends StatelessWidget {
  final String explanation;
  final void Function(double amount, double percent) onApply;

  const DepositAddScreen({
    super.key,
    required this.explanation,
    required this.onApply,
  });

  @override
  Widget build(BuildContext context) {
    // показываем только форму добавления (AmountPercentInput)
    // кнопка "Применить" передаёт значения в onApply
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ExplanationText('Добавление вклада. $explanation'),
        const SizedBox(height: 16),
        AmountPercentInput(
          amountLabel: 'Сумма вклада (₽)',
          percentLabel: 'Годовой %',
          buttonText: 'Применить',
          onAdd: onApply,
        ),
        const SizedBox(height: 12),
      ],
    );
  }
}

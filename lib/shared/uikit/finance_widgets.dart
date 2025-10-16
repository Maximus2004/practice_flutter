import 'package:flutter/material.dart';

typedef OnAddAccount = void Function(double amount, double percent);

String formatMoney(double value) {
  return '${value.toStringAsFixed(2)} р.';
}

class ExplanationText extends StatelessWidget {
  final String text;
  const ExplanationText(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(fontSize: 14),
    );
  }
}

class AmountPercentInput extends StatefulWidget {
  final String amountLabel;
  final String percentLabel;
  final String buttonText;
  final OnAddAccount onAdd;

  const AmountPercentInput({
    super.key,
    required this.amountLabel,
    required this.percentLabel,
    required this.buttonText,
    required this.onAdd,
  });

  @override
  State<AmountPercentInput> createState() => _AmountPercentInputState();
}

class _AmountPercentInputState extends State<AmountPercentInput> {
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _percentController = TextEditingController();

  @override
  void dispose() {
    _amountController.dispose();
    _percentController.dispose();
    super.dispose();
  }

  void _onAddPressed() {
    final textAmount = _amountController.text.trim().replaceAll(',', '.');
    final textPercent = _percentController.text.trim().replaceAll(',', '.');

    final amount = double.tryParse(textAmount);
    final percent = double.tryParse(textPercent);

    if (amount == null || percent == null) return;

    widget.onAdd(amount, percent);
    _amountController.clear();
    _percentController.clear();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final aText = _amountController.text.trim().replaceAll(',', '.');
    final pText = _percentController.text.trim().replaceAll(',', '.');
    final a = double.tryParse(aText);
    final p = double.tryParse(pText);

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              flex: 2,
              child: TextField(
                controller: _amountController,
                keyboardType:
                const TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  labelText: widget.amountLabel,
                  hintText: 'Введите сумму',
                  border: const OutlineInputBorder(),
                ),
                onSubmitted: (_) => _onAddPressed(),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              flex: 1,
              child: TextField(
                controller: _percentController,
                keyboardType:
                const TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  labelText: widget.percentLabel,
                  hintText: 'Напр. 5.5',
                  border: const OutlineInputBorder(),
                ),
                onSubmitted: (_) => _onAddPressed(),
              ),
            ),
            const SizedBox(width: 8),
            ElevatedButton(
              onPressed: _onAddPressed,
              child: Text(widget.buttonText),
            ),
          ],
        ),
      ],
    );
  }
}

/// Класс для передачи данных в список
class AccountDisplay {
  final double amount;
  final double percent;
  final double income; // вычисленный доход (daily/annual в зависимости от экрана)
  final VoidCallback onDelete;

  AccountDisplay({
    required this.amount,
    required this.percent,
    required this.income,
    required this.onDelete,
  });
}

class AccountList extends StatelessWidget {
  final List<AccountDisplay> items;
  final String emptyMessage;

  const AccountList({
    super.key,
    required this.items,
    this.emptyMessage = 'Пусто',
  });

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return Center(child: Text(emptyMessage));
    }
    return ListView.separated(
      itemCount: items.length,
      separatorBuilder: (_, __) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final acc = items[index];
        return ListTile(
          title: Text(formatMoney(acc.amount)),
          subtitle: Text(
            'Годовой: ${acc.percent.toStringAsFixed(2)}% · Доход: ${formatMoney(acc.income)}',
          ),
          trailing: IconButton(
            icon: const Icon(Icons.delete),
            onPressed: acc.onDelete,
          ),
          onTap: acc.onDelete,
        );
      },
    );
  }
}

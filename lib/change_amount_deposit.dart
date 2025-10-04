import 'package:flutter/material.dart';

class ModifyAmountDepositScreen extends StatefulWidget {
  final int initialAmount;
  final int step;
  final ValueChanged<int> onAmountChanged;

  const ModifyAmountDepositScreen({
    super.key,
    required this.initialAmount,
    required this.step,
    required this.onAmountChanged,
  });

  @override
  State<ModifyAmountDepositScreen> createState() => _ModifyAmountDepositScreenState();
}

class _ModifyAmountDepositScreenState extends State<ModifyAmountDepositScreen> {
  late int amount;

  @override
  void initState() {
    super.initState();
    amount = widget.initialAmount;
  }

  @override
  void dispose() {
    widget.onAmountChanged(amount);
    super.dispose();
  }

  void increase() {
    setState(() {
      amount += widget.step;
    });
  }

  void decrease() {
    setState(() {
      amount -= widget.step;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Сумма на вкладе"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Текущая сумма: ${formatRub(amount)}',
                style: const TextStyle(fontSize: 20)),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: increase,
              child: const Text('Увеличить сумму'),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: decrease,
              child: const Text('Уменьшить сумму'),
            ),
          ],
        ),
      ),
    );
  }
}

String formatRub(int amount) {
  return '$amount р.';
}

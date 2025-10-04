import 'package:flutter/material.dart';

class ModifyAmountCheckingScreen extends StatefulWidget {
  final int initialAmount;
  final int step;
  final ValueChanged<int> onAmountChanged;

  const ModifyAmountCheckingScreen({
    super.key,
    required this.initialAmount,
    required this.step,
    required this.onAmountChanged,
  });

  @override
  State<ModifyAmountCheckingScreen> createState() => _ModifyAmountCheckingScreen();
}

class _ModifyAmountCheckingScreen extends State<ModifyAmountCheckingScreen> {
  late int amount;

  @override
  void initState() {
    super.initState();
    amount = widget.initialAmount;
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
  void dispose() {
    widget.onAmountChanged(amount);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Сумма на расчетном счете"),
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
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Готово'),
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

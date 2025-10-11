import 'package:flutter/material.dart';

class ModifyAmountCheckingScreen extends StatefulWidget {
  final int initialAmount;
  final ValueChanged<int> onAmountChanged;

  const ModifyAmountCheckingScreen({
    super.key,
    required this.initialAmount,
    required this.onAmountChanged,
  });

  @override
  State<ModifyAmountCheckingScreen> createState() =>
      _ModifyAmountCheckingScreen();
}

class _ModifyAmountCheckingScreen extends State<ModifyAmountCheckingScreen> {
  late List<int> checkingAccounts;
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    checkingAccounts = <int>[];
    if (widget.initialAmount != 0) {
      checkingAccounts.add(widget.initialAmount);
    }
  }

  @override
  void dispose() {
    widget.onAmountChanged(_totalAmount());
    _controller.dispose();
    super.dispose();
  }

  int _totalAmount() {
    return checkingAccounts.fold(0, (sum, item) => sum + item);
  }

  void _openCheckingAccount() {
    final text = _controller.text.trim();
    final value = int.tryParse(text);

    if (value == null) return;

    setState(() {
      checkingAccounts.add(value);
      _controller.clear();
    });
  }

  void _removeAccountAt(int index) {
    setState(() {
      checkingAccounts.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Сумма на расчетном счете")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Общая сумма: ${formatRub(_totalAmount())}',
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Сумма расчетного счёта',
                      hintText: 'Введите сумму (только цифры)',
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (_) => _openCheckingAccount(),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _openCheckingAccount,
                  child: const Text(
                    'Открыть\nрасчетный счёт',
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            Expanded(
              child: ListView.builder(
                itemCount: checkingAccounts.length,
                itemBuilder: (context, index) {
                  final value = checkingAccounts[index];
                  return Column(
                    children: [
                      ListTile(
                        title: Text(formatRub(value)),
                        onTap: () => _removeAccountAt(index),
                        subtitle: const Text('Нажмите, чтобы удалить счёт'),
                      ),
                      const Divider(height: 1),
                    ],
                  );
                },
              ),
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

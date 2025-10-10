import 'package:flutter/material.dart';

class ModifyAmountDepositScreen extends StatefulWidget {
  final int initialAmount;
  final int step; // оставлено для совместимости
  final ValueChanged<int> onAmountChanged;

  const ModifyAmountDepositScreen({
    super.key,
    required this.initialAmount,
    required this.step,
    required this.onAmountChanged,
  });

  @override
  State<ModifyAmountDepositScreen> createState() =>
      _ModifyAmountDepositScreen();
}

class _ModifyAmountDepositScreen extends State<ModifyAmountDepositScreen> {
  late List<int> depositAccounts;
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    depositAccounts = <int>[];
    if (widget.initialAmount != 0) {
      depositAccounts.add(widget.initialAmount);
    }
  }

  @override
  void dispose() {
    widget.onAmountChanged(_totalAmount());
    _controller.dispose();
    super.dispose();
  }

  int _totalAmount() {
    return depositAccounts.fold(0, (sum, item) => sum + item);
  }

  void _opendepositAccount() {
    final text = _controller.text.trim();
    if (text.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Введите сумму')));
      return;
    }

    final value = int.tryParse(text.replaceAll(' ', ''));
    if (value == null) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Неверный формат суммы')));
      return;
    }

    setState(() {
      depositAccounts.add(value);
      _controller.clear();
    });
  }

  void _removeAccountAt(int index) {
    if (index < 0 || index >= depositAccounts.length) return;
    setState(() {
      depositAccounts.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Сумма на вкладе"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          // Внешняя колонка располагает header, input + button и область для списка
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Общая сумма: ${formatRub(_totalAmount())}',
                style: const TextStyle(fontSize: 20)),
            const SizedBox(height: 24),

            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Сумма вклада',
                      hintText: 'Введите сумму (только цифры)',
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (_) => _opendepositAccount(),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _opendepositAccount,
                  child: const Text('Открыть\nвклад',
                      textAlign: TextAlign.center),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Область для списка — используем Expanded + SingleChildScrollView + Column
            Expanded(
              child: depositAccounts.isEmpty
                  ? const Center(
                  child:
                  Text('Пока нет открытых вкладов. Добавьте один.'))
                  : SingleChildScrollView(
                child: Column(
                  children: List<Widget>.generate(
                    depositAccounts.length * 2 - 1,
                        (i) {
                      // чётные индексы — элементы, нечётные — разделители
                      if (i.isOdd) {
                        return const Divider(height: 1);
                      }
                      final index = i ~/ 2;
                      final value = depositAccounts[index];
                      return ListTile(
                        title: Text(formatRub(value)),
                        subtitle:
                        const Text('Нажмите, чтобы удалить вклад'),
                        onTap: () => _removeAccountAt(index),
                        // визуально выделяем выбранный элемент (опционально)
                        // selected: false,
                      );
                    },
                  ),
                ),
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

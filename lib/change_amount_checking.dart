import 'package:flutter/material.dart';

class ModifyAmountCheckingScreen extends StatefulWidget {
  final int initialAmount;
  final int step; // теперь не используется, но оставил для обратной совместимости
  final ValueChanged<int> onAmountChanged;

  const ModifyAmountCheckingScreen({
    super.key,
    required this.initialAmount,
    required this.step,
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
    // Инициализируем список: если initialAmount != 0 — добавляем как начальный счет
    checkingAccounts = <int>[];
    if (widget.initialAmount != 0) {
      checkingAccounts.add(widget.initialAmount);
    }
  }

  @override
  void dispose() {
    // При выходе возвращаем общую сумму всех расчетных счетов
    widget.onAmountChanged(_totalAmount());
    _controller.dispose();
    super.dispose();
  }

  int _totalAmount() {
    return checkingAccounts.fold(0, (sum, item) => sum + item);
  }

  void _openCheckingAccount() {
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
      checkingAccounts.add(value);
      _controller.clear();
    });
  }

  void _removeAccountAt(int index) {
    if (index < 0 || index >= checkingAccounts.length) return;
    setState(() {
      checkingAccounts.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Сумма на расчетном счете"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Общая сумма: ${formatRub(_totalAmount())}',
                style: const TextStyle(fontSize: 20)),
            const SizedBox(height: 24),

            // Поле ввода и кнопка "Открыть расчетный счет"
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
                  child: const Text('Открыть\nрасчетный счёт',
                      textAlign: TextAlign.center),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Список счетов — реализован через ListView.builder
            Expanded(
              child: checkingAccounts.isEmpty
                  ? const Center(
                  child:
                  Text('Пока нет открытых расчетных счетов. Добавьте один.'))
                  : ListView.builder(
                itemCount: checkingAccounts.length,
                itemBuilder: (context, index) {
                  final value = checkingAccounts[index];
                  return Column(
                    children: [
                      ListTile(
                        title: Text(formatRub(value)),
                        // при клике — удаляем элемент
                        onTap: () => _removeAccountAt(index),
                        // добавим подсказку для доступности
                        subtitle:
                        const Text('Нажмите, чтобы удалить счёт'),
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

import 'package:flutter/material.dart';

class BankSelectionScreen extends StatefulWidget {
  final List<String> banks;
  final int initialIndex;

  const BankSelectionScreen({
    super.key,
    required this.banks,
    required this.initialIndex,
  });

  @override
  State<BankSelectionScreen> createState() => _BankSelectionScreenState();
}

class _BankSelectionScreenState extends State<BankSelectionScreen> {
  late int currentIndex;
  late List<String> banksList;
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    // копируем, чтобы можно было изменять локально
    banksList = List<String>.from(widget.banks);
    // защитимся от выхода за границы
    currentIndex = banksList.isNotEmpty
        ? (widget.initialIndex.clamp(0, banksList.length - 1))
        : 0;
  }

  void nextBank() {
    if (banksList.isEmpty) return;
    setState(() {
      currentIndex = (currentIndex + 1) % banksList.length;
    });
  }

  void _addBank() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    setState(() {
      banksList.add(text);
      // если список был пуст — выбираем добавленный элемент
      if (banksList.length == 1) currentIndex = 0;
      _controller.clear();
    });
  }

  void _removeBankAt(int index) {
    if (index < 0 || index >= banksList.length) return;
    setState(() {
      banksList.removeAt(index);
      if (banksList.isEmpty) {
        currentIndex = 0;
      } else {
        // скорректируем currentIndex чтобы он указывал на корректный элемент
        if (index < currentIndex) {
          currentIndex = currentIndex - 1;
        } else if (index == currentIndex) {
          // оставляем текущий индекс, но если он вышел за границы — возвращаем в диапазон
          if (currentIndex >= banksList.length) {
            currentIndex = banksList.length - 1;
          }
        }
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentBankText =
    banksList.isNotEmpty ? banksList[currentIndex] : 'Список пуст';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Выбор банка'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Текущий банк: $currentBankText',
                style: const TextStyle(fontSize: 20)),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: banksList.isEmpty ? null : nextBank,
              child: const Text('Следующий банк'),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () {
                // если список пуст, вернём -1
                final result = banksList.isEmpty ? -1 : currentIndex;
                Navigator.pop(context, result);
              },
              child: const Text('Подтвердить выбор'),
            ),
            const SizedBox(height: 16),

            // Поле ввода + кнопка добавления
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      labelText: 'Добавить банк',
                      hintText: 'Название банка',
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (_) => _addBank(),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _addBank,
                  child: const Text('Добавить'),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Список банков — занимает оставшееся место
            Expanded(
              child: banksList.isEmpty
                  ? const Center(child: Text('Банков пока нет. Добавьте один.'))
                  : ListView.separated(
                itemCount: banksList.length,
                separatorBuilder: (context, index) =>
                const Divider(height: 1),
                itemBuilder: (context, index) {
                  final bankName = banksList[index];
                  final isSelected =
                  (banksList.isNotEmpty && index == currentIndex);
                  return ListTile(
                    title: Text(bankName),
                    trailing: isSelected
                        ? const Icon(Icons.check, semanticLabel: 'Выбран')
                        : null,
                    // При клике элемент удаляется
                    onTap: () => _removeBankAt(index),
                    // Чтобы было визуально заметно что элемент кликабельный
                    hoverColor: Theme.of(context).hoverColor,
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


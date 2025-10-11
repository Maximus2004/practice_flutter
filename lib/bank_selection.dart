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
    banksList = List<String>.from(widget.banks);
    currentIndex = widget.initialIndex.clamp(0, banksList.length - 1);
  }

  void nextBank() {
    setState(() {
      currentIndex = (currentIndex + 1) % banksList.length;
    });
  }

  void _addBank() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    setState(() {
      banksList.add(text);
      _controller.clear();
    });
  }

  void _removeBankAt(int index) {
    setState(() {
      banksList.removeAt(index);
      if (banksList.isEmpty) {
        currentIndex = 0;
      } else {
        if (index < currentIndex) {
          currentIndex = currentIndex - 1;
        } else if (index == currentIndex) {
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
    final currentBankText = banksList[currentIndex];

    return Scaffold(
      appBar: AppBar(title: const Text('Выбор банка')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Текущий банк: $currentBankText',
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: nextBank,
              child: const Text('Следующий банк'),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () {
                final result = currentIndex;
                Navigator.pop(context, result);
              },
              child: const Text('Подтвердить выбор'),
            ),
            const SizedBox(height: 16),

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

            Expanded(
              child: ListView.separated(
                itemCount: banksList.length,
                separatorBuilder: (context, index) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final bankName = banksList[index];
                  return ListTile(
                    title: Text(bankName),
                    onTap: () => _removeBankAt(index),
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

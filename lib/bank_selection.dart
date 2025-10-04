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

  @override
  void initState() {
    super.initState();
    currentIndex = widget.initialIndex;
  }

  void nextBank() {
    setState(() {
      currentIndex = (currentIndex + 1) % widget.banks.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Выбор банка'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Текущий банк: ${widget.banks[currentIndex]}',
                style: const TextStyle(fontSize: 20)),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: nextBank,
              child: const Text('Следующий банк'),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context, currentIndex);
              },
              child: const Text('Подтвердить выбор'),
            ),
          ],
        ),
      ),
    );
  }
}

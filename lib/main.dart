import 'package:flutter/material.dart';
import 'package:practice/features/profile/screens/profile_info.dart';

import 'features/bank/screens/bank_selection.dart';
import 'features/checking/screens/change_amount_checking.dart';
import 'features/deposit/state/deposit_container.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Простобанк',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<String> banks = ['МКБ', 'Сбер', 'Т-банк', 'Альфа'];
  final items = List.generate(100, (index) => 'Item ${index + 1}');
  int selectedBankIndex = 0;
  int checkingAmount = 0;
  int depositAmount = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Банковское приложение')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
              onPressed: _navigateToBankSelection,
              child: const Text('Выбрать банк'),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _navigateToModifyChecking,
              child: const Text('Изменить сумму на расчетном счёту'),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _navigateToModifyDeposit,
              child: const Text('Изменить сумму на вкладе'),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _navigateToProfile,
              child: const Text('Личный кабинет'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _navigateToBankSelection() async {
    final result = await Navigator.push<int>(
      context,
      MaterialPageRoute(
        builder: (context) =>
            BankSelectionScreen(banks: banks, initialIndex: selectedBankIndex),
      ),
    );

    if (result != null) {
      setState(() {
        selectedBankIndex = result;
      });
    }
  }

  void _navigateToModifyChecking() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AmountCheckingScreen(
          initialAmount: checkingAmount,
          onAmountChanged: (newAmount) {
            setState(() {
              checkingAmount = newAmount;
            });
          },
        ),
      ),
    );
  }

  void _navigateToModifyDeposit() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DepositContainer(
          initialAmount: depositAmount,
          onAmountChanged: (newAmount) {
            setState(() {
              depositAmount = newAmount;
            });
          },
        ),
      ),
    );
  }

  void _navigateToProfile() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProfileScreen(
          bankName: banks[selectedBankIndex],
          checkingAmount: checkingAmount,
          depositAmount: depositAmount,
        ),
      ),
    );
  }
}

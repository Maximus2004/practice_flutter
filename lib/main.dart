import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'features/bank/screens/bank_selection.dart';
import 'features/checking/screens/change_amount_checking.dart';
import 'features/deposit/state/deposit_container.dart';
import 'features/profile/screens/profile_info.dart';

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

  int selectedBankIndex = 0;
  int checkingAmount = 0;
  int depositAmount = 0;

  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final List<Widget> screens = [
      AmountCheckingScreen(
        initialAmount: checkingAmount,
        onAmountChanged: (newAmount) {
          setState(() {
            checkingAmount = newAmount;
          });
        },
      ),

      DepositContainer(
        initialAmount: depositAmount,
        onAmountChanged: (newAmount) {
          setState(() {
            depositAmount = newAmount;
          });
        },
      ),

      ProfileScreen(
        bankName: banks[selectedBankIndex],
        checkingAmount: checkingAmount,
        depositAmount: depositAmount,
        onSelectBankTap: _navigateToBankSelection,
      ),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Банковское приложение')),
      body: screens[_selectedIndex],

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.account_balance_wallet),
            label: 'Накопления',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.savings),
            label: 'Вклады',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Профиль',
          ),
        ],
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
}
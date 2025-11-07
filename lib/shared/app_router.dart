import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../features/checking/screens/change_amount_checking.dart';
import '../features/deposit/state/deposit_container.dart';
import '../features/deposit/screens/deposit_add_screen.dart';
import '../features/profile/screens/profile_info.dart';
import '../features/bank/screens/bank_selection.dart';

class AppState extends ChangeNotifier {
  int checkingAmount = 0;
  int depositAmount = 0;
  int selectedBankIndex = 0;
  List<String> banks = ['МКБ', 'Сбер', 'Т-банк', 'Альфа'];

  void setChecking(int v) {
    checkingAmount = v;
    notifyListeners();
  }

  void setDeposit(int v) {
    depositAmount = v;
    notifyListeners();
  }

  void setBank(int i) {
    selectedBankIndex = i;
    notifyListeners();
  }
}

final appState = AppState();

final router = GoRouter(
  initialLocation: '/checking',

  routes: [
    GoRoute(
      path: '/checking',
      builder: (context, state) {
        return Scaffold(
          body: AmountCheckingScreen(
            initialAmount: appState.checkingAmount,
            onAmountChanged: appState.setChecking,
          ),
          bottomNavigationBar: _BottomNavBar(currentIndex: 0),
        );
      },
    ),
    GoRoute(
      path: '/deposit',
      builder: (context, state) {
        return Scaffold(
          body: DepositContainer(
            initialAmount: appState.depositAmount,
            onAmountChanged: appState.setDeposit,
          ),
          bottomNavigationBar: _BottomNavBar(currentIndex: 1),
        );
      },
      routes: [
        GoRoute(
          path: 'form',
          builder: (context, state) {
            return DepositAddScreen(
              explanation: 'Добавить вклад',
            );
          },
        ),
      ],
    ),
    GoRoute(
      path: '/profile',
      builder: (context, state) {
        return Scaffold(
          body: ProfileScreen(
            bankName: appState.banks[appState.selectedBankIndex],
            checkingAmount: appState.checkingAmount,
            depositAmount: appState.depositAmount,
            onSelectBankTap: () {
              context.push('/profile/bank');
            },
          ),
          bottomNavigationBar: _BottomNavBar(currentIndex: 2),
        );
      },
      routes: [
        GoRoute(
          path: 'bank',
          builder: (context, state) {
            return BankSelectionScreen(
              banks: appState.banks,
              initialIndex: appState.selectedBankIndex,
              onSelect: appState.setBank,
            );
          },
        ),
      ],
    ),
  ],
);
class _BottomNavBar extends StatelessWidget {
  final int currentIndex;
  const _BottomNavBar({required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: (i) {
        switch (i) {
          case 0:
            context.go('/checking');
            break;
          case 1:
            context.go('/deposit');
            break;
          case 2:
            context.go('/profile');
            break;
        }
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
    );
  }
}

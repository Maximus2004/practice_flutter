import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../features/checking/screens/change_amount_checking.dart';
import '../features/deposit/screens/deposit_add_screen.dart';
import '../features/deposit/state/deposit_container.dart';
import '../features/profile/screens/profile_info.dart';
import '../features/bank/screens/bank_selection.dart';

class AppStateContainer extends StatefulWidget {
  final Widget child;
  const AppStateContainer({super.key, required this.child});

  @override
  State<AppStateContainer> createState() => _AppStateContainerState();

  static _AppStateContainerState of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<_InheritedAppState>()!
        .state;
  }
}

class _AppStateContainerState extends State<AppStateContainer> {
  int checkingAmount = 0;
  int depositAmount = 0;
  int selectedBankIndex = 0;
  List<String> banks = ['МКБ', 'Сбер', 'Т-банк', 'Альфа'];

  void setChecking(int v) => setState(() => checkingAmount = v);
  void setDeposit(int v) => setState(() => depositAmount = v);
  void setBank(int i) => setState(() => selectedBankIndex = i);

  @override
  Widget build(BuildContext context) {
    return _InheritedAppState(
      state: this,
      child: widget.child,
    );
  }
}

class _InheritedAppState extends InheritedWidget {
  final _AppStateContainerState state;
  const _InheritedAppState({required super.child, required this.state});

  @override
  bool updateShouldNotify(_) => true;
}

final router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (_, __) => const HomeScreen(),
      routes: [
        GoRoute(
          path: 'deposit/form',
          builder: (context, state) =>
          const DepositAddScreen(explanation: 'Добавить вклад'),
        ),
        GoRoute(
          path: 'profile/bank',
          builder: (context, state) {
            final app = AppStateContainer.of(context);
            return BankSelectionScreen(
              banks: app.banks,
              initialIndex: app.selectedBankIndex,
              onSelect: app.setBank,
            );
          },
        ),
      ],
    ),
  ],
);

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int pageIndex = 0;

  @override
  Widget build(BuildContext context) {
    final app = AppStateContainer.of(context);

    final pages = [
      AmountCheckingScreen(
        initialAmount: app.checkingAmount,
        onAmountChanged: app.setChecking,
      ),

      DepositContainer(
        initialAmount: app.depositAmount,
        onAmountChanged: app.setDeposit,
      ),

      ProfileScreen(
        bankName: app.banks[app.selectedBankIndex],
        checkingAmount: app.checkingAmount,
        depositAmount: app.depositAmount,
        onSelectBankTap: () => context.push('/profile/bank'),
      ),
    ];

    return Scaffold(
      body: IndexedStack(
        index: pageIndex,
        children: pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: pageIndex,
        onTap: (i) {
          setState(() => pageIndex = i);
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
}

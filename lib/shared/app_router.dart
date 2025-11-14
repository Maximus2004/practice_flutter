import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:practice/shared/service_locator.dart';
import '../features/checking/screens/change_amount_checking.dart';
import '../features/deposit/screens/deposit_add_screen.dart';
import '../features/deposit/state/deposit_container.dart';
import '../features/profile/screens/profile_info.dart';
import '../features/bank/screens/bank_selection.dart';

final router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (_, __) => const HomeScreen(),
      routes: [
        GoRoute(
          path: 'deposit/form',
          builder: (_, __) =>
          const DepositAddScreen(explanation: 'Добавить вклад'),
        ),

        GoRoute(
          path: 'profile/bank',
          builder: (context, state) {
            final app = locator.isRegistered<AppState>() ? locator<AppState>() : null;

            if (app == null) {
              return const Scaffold(
                body: Center(child: Text('AppState не инициализирован')),
              );
            }

            return BankSelectionScreen(
              banks: app.banks,
              initialIndex: app.selectedBankIndex,
              onSelect: (i) {
                app.setBank(i);
                context.pop();
              },
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
    final app = locator.get<AppState>();

    final pages = [
      AmountCheckingScreen(
        initialAmount: app.checkingAmount,
        onAmountChanged: (v) {
          setState(() {
            app.setChecking(v);
          });
        },
      ),

      DepositContainer(
        initialAmount: app.depositAmount,
        onAmountChanged: (v) {
          setState(() {
            app.setDeposit(v);
          });
        },
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
        onTap: (i) => setState(() => pageIndex = i),
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

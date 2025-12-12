import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../features/auth/screens/auth_screen.dart';
import '../features/deposit/screens/deposit_add_screen.dart';
import '../features/bank/screens/bank_selection.dart';
import '../features/checking/screens/change_amount_checking.dart';
import '../features/deposit/state/deposit_container.dart';
import '../features/transactions/screens/transactions_screen.dart';
import '../features/notifications/screens/notifications_screen.dart';
import '../features/profile/screens/profile_info.dart';
import 'app_cubit.dart';

int _getSelectedIndex(String location) {
  if (location == '/checking') return 0;
  if (location.startsWith('/deposits')) return 1;
  if (location.startsWith('/transactions')) return 2;
  if (location.startsWith('/notifications')) return 3;
  if (location.startsWith('/profile')) return 4;
  return 0;
}

final router = GoRouter(
  initialLocation: '/checking',
  routes: [
    ShellRoute(
      builder: (context, state, child) {
        return Scaffold(
          body: child,
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: _getSelectedIndex(state.uri.path),
            onTap: (index) {
              switch (index) {
                case 0:
                  context.go('/checking');
                  break;
                case 1:
                  context.go('/deposits');
                  break;
                case 2:
                  context.go('/transactions');
                  break;
                case 3:
                  context.go('/notifications');
                  break;
                case 4:
                  context.go('/profile');
                  break;
              }
            },
            type: BottomNavigationBarType.fixed,
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
                icon: Icon(Icons.receipt_long),
                label: 'Транзакции',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.notifications),
                label: 'Уведомления',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'Профиль',
              ),
            ],
          ),
        );
      },
      routes: [
        GoRoute(
          path: '/checking',
          builder: (context, state) => BlocBuilder<BillCubit, BillState>(
            builder: (context, app) => AmountCheckingScreen(
              initialAmount: app.checkingAmount,
              onAmountChanged: (v) {
                context.read<BillCubit>().setChecking(v);
              },
            ),
          ),
        ),
        GoRoute(
          path: '/deposits',
          builder: (context, state) => BlocBuilder<BillCubit, BillState>(
            builder: (context, app) => DepositContainer(
              initialAmount: app.depositAmount,
              onAmountChanged: (v) {
                context.read<BillCubit>().setDeposit(v);
              },
            ),
          ),
          routes: [
            GoRoute(
              path: 'add',
              builder: (_, __) =>
                  const DepositAddScreen(explanation: 'Добавить вклад'),
            ),
          ],
        ),
        GoRoute(
          path: '/transactions',
          builder: (_, __) => const TransactionsScreen(),
        ),
        GoRoute(
          path: '/notifications',
          builder: (_, __) => const NotificationsScreen(),
        ),
        GoRoute(
          path: '/profile',
          builder: (context, state) => BlocBuilder<BillCubit, BillState>(
            builder: (context, app) => ProfileScreen(
              bankName: app.banks[app.selectedBankIndex],
              checkingAmount: app.checkingAmount,
              depositAmount: app.depositAmount,
              onSelectBankTap: () => context.push('/profile/select-bank'),
            ),
          ),
          routes: [
            GoRoute(
              path: 'select-bank',
              builder: (context, state) {
                final app = context.read<BillCubit>().state;

                return BankSelectionScreen(
                  banks: app.banks,
                  initialIndex: app.selectedBankIndex,
                  onSelect: (i) {
                    context.read<BillCubit>().setBank(i);
                    context.pop();
                  },
                );
              },
            ),
            GoRoute(
              path: 'login',
              builder: (_, __) => const LoginScreen(),
            ),
          ],
        ),
      ],
    ),
  ],
);

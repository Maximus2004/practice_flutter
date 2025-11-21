import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../features/auth/screens/auth_screen.dart';
import '../features/deposit/screens/deposit_add_screen.dart';
import '../features/bank/screens/bank_selection.dart';
import 'app_cubit.dart';
import 'home_screen.dart';

final router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (_, __) => const HomeScreen(),
      routes: [
        GoRoute(
          path: 'auth',
          builder: (_, __) => const LoginScreen(),
        ),

        GoRoute(
          path: 'deposit/form',
          builder: (_, __) =>
          const DepositAddScreen(explanation: 'Добавить вклад'),
        ),

        GoRoute(
          path: 'profile/bank',
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
      ],
    ),
  ],
);

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../features/checking/screens/change_amount_checking.dart';
import '../features/deposit/state/deposit_container.dart';
import '../features/profile/screens/profile_info.dart';
import 'app_cubit.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int pageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BillCubit, BillState>(
      builder: (context, app) {
        final pages = [
          AmountCheckingScreen(
            initialAmount: app.checkingAmount,
            onAmountChanged: (v) {
              context.read<BillCubit>().setChecking(v);
            },
          ),

          DepositContainer(
            initialAmount: app.depositAmount,
            onAmountChanged: (v) {
              context.read<BillCubit>().setDeposit(v);
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
      },
    );
  }
}

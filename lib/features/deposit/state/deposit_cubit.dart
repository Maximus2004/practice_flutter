import 'package:flutter_bloc/flutter_bloc.dart';
import '../model/deposit_account.dart';

class DepositState {
  final List<DepositAccount> deposits;

  const DepositState({
    this.deposits = const [],
  });

  DepositState copyWith({
    List<DepositAccount>? deposits,
  }) {
    return DepositState(
      deposits: deposits ?? this.deposits,
    );
  }

  double get totalAmount {
    return deposits.fold(0.0, (sum, d) => sum + d.amount);
  }

  double get totalAnnualIncome {
    return deposits.fold(0.0, (sum, d) => sum + d.annualIncome);
  }

  int get totalAmountRounded {
    return totalAmount.round();
  }
}

class DepositCubit extends Cubit<DepositState> {
  DepositCubit({int initialAmount = 0}) : super(const DepositState()) {
    if (initialAmount != 0) {
      addDeposit(
        DepositAccount(
          amount: initialAmount.toDouble(),
          annualPercent: 0.0,
        ),
      );
    }
  }

  void addDeposit(DepositAccount deposit) {
    final updatedDeposits = [...state.deposits, deposit];
    emit(state.copyWith(deposits: updatedDeposits));
  }

  void removeDepositAt(int index) {
    if (index >= 0 && index < state.deposits.length) {
      final updatedDeposits = List<DepositAccount>.from(state.deposits);
      updatedDeposits.removeAt(index);
      emit(state.copyWith(deposits: updatedDeposits));
    }
  }
}

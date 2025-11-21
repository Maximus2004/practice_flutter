import 'package:flutter_bloc/flutter_bloc.dart';

class BillState {
  final int checkingAmount;
  final int depositAmount;
  final List<String> banks;
  final int selectedBankIndex;

  const BillState({
    this.checkingAmount = 0,
    this.depositAmount = 0,
    this.banks = const ["Tinkoff", "Sber", "VTB"],
    this.selectedBankIndex = 0,
  });

  BillState copyWith({
    int? checkingAmount,
    int? depositAmount,
    List<String>? banks,
    int? selectedBankIndex,
  }) {
    return BillState(
      checkingAmount: checkingAmount ?? this.checkingAmount,
      depositAmount: depositAmount ?? this.depositAmount,
      banks: banks ?? this.banks,
      selectedBankIndex: selectedBankIndex ?? this.selectedBankIndex,
    );
  }
}

class BillCubit extends Cubit<BillState> {
  BillCubit() : super(const BillState());

  void setChecking(int value) =>
      emit(state.copyWith(checkingAmount: value));

  void setDeposit(int value) =>
      emit(state.copyWith(depositAmount: value));

  void setBank(int index) =>
      emit(state.copyWith(selectedBankIndex: index));
}
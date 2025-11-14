import 'package:get_it/get_it.dart';

final GetIt locator = GetIt.instance;

class AppState {
  int checkingAmount = 0;
  int depositAmount = 0;
  int selectedBankIndex = 0;
  List<String> banks = ['МКБ', 'Сбер', 'Т-банк', 'Альфа'];

  void setChecking(int v) => checkingAmount = v;
  void setDeposit(int v) => depositAmount = v;
  void setBank(int i) => selectedBankIndex = i;
}

void setupLocator() {
  locator.registerSingleton<AppState>(AppState());
}

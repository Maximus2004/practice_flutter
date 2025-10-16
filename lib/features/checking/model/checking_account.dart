class CheckingAccount {
  final double amount;
  final double annualPercent;

  CheckingAccount({
    required this.amount,
    required this.annualPercent,
  });

  double get dailyIncome => amount * (annualPercent / 100.0) / 365.0;
}
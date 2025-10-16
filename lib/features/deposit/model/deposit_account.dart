class DepositAccount {
  final double amount;
  final double annualPercent;

  DepositAccount({
    required this.amount,
    required this.annualPercent,
  });

  double get annualIncome => amount * (annualPercent / 100.0);
}
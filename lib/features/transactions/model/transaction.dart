enum TransactionType {
  income,
  expense,
  transfer,
}

class Transaction {
  final String id;
  final String title;
  final double amount;
  final TransactionType type;
  final DateTime date;
  final String? category;

  Transaction({
    required this.id,
    required this.title,
    required this.amount,
    required this.type,
    required this.date,
    this.category,
  });

  String get formattedAmount {
    final sign = type == TransactionType.income ? '+' : '-';
    return '$sign${amount.toStringAsFixed(2)} ₽';
  }

  String get typeLabel {
    switch (type) {
      case TransactionType.income:
        return 'Пополнение';
      case TransactionType.expense:
        return 'Списание';
      case TransactionType.transfer:
        return 'Перевод';
    }
  }
}

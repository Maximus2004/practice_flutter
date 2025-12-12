import 'package:flutter_bloc/flutter_bloc.dart';
import '../model/transaction.dart';

class TransactionsState {
  final List<Transaction> transactions;
  final String? filter;

  const TransactionsState({
    this.transactions = const [],
    this.filter,
  });

  TransactionsState copyWith({
    List<Transaction>? transactions,
    String? filter,
  }) {
    return TransactionsState(
      transactions: transactions ?? this.transactions,
      filter: filter ?? this.filter,
    );
  }

  List<Transaction> get filteredTransactions {
    if (filter == null || filter!.isEmpty) {
      return transactions;
    }
    return transactions
        .where((t) =>
            t.title.toLowerCase().contains(filter!.toLowerCase()) ||
            t.category?.toLowerCase().contains(filter!.toLowerCase()) == true)
        .toList();
  }

  double get totalIncome {
    return transactions
        .where((t) => t.type == TransactionType.income)
        .fold(0.0, (sum, t) => sum + t.amount);
  }

  double get totalExpense {
    return transactions
        .where((t) => t.type == TransactionType.expense)
        .fold(0.0, (sum, t) => sum + t.amount);
  }

  double get balance {
    return totalIncome - totalExpense;
  }
}

class TransactionsCubit extends Cubit<TransactionsState> {
  TransactionsCubit() : super(const TransactionsState()) {
    _initializeSampleData();
  }

  void _initializeSampleData() {
    final now = DateTime.now();
    final sampleTransactions = [
      Transaction(
        id: '1',
        title: 'Зарплата',
        amount: 85000.0,
        type: TransactionType.income,
        date: now.subtract(const Duration(days: 5)),
        category: 'Доход',
      ),
      Transaction(
        id: '2',
        title: 'Продукты',
        amount: 3500.0,
        type: TransactionType.expense,
        date: now.subtract(const Duration(days: 3)),
        category: 'Еда',
      ),
      Transaction(
        id: '3',
        title: 'Транспорт',
        amount: 1200.0,
        type: TransactionType.expense,
        date: now.subtract(const Duration(days: 2)),
        category: 'Транспорт',
      ),
      Transaction(
        id: '4',
        title: 'Фриланс',
        amount: 15000.0,
        type: TransactionType.income,
        date: now.subtract(const Duration(days: 1)),
        category: 'Доход',
      ),
      Transaction(
        id: '5',
        title: 'Коммунальные услуги',
        amount: 4500.0,
        type: TransactionType.expense,
        date: now,
        category: 'Счета',
      ),
    ];

    emit(state.copyWith(transactions: sampleTransactions));
  }

  void addTransaction(Transaction transaction) {
    final updatedTransactions = [transaction, ...state.transactions];
    emit(state.copyWith(transactions: updatedTransactions));
  }

  void removeTransaction(String id) {
    final updatedTransactions =
        state.transactions.where((t) => t.id != id).toList();
    emit(state.copyWith(transactions: updatedTransactions));
  }

  void setFilter(String? filter) {
    emit(state.copyWith(filter: filter));
  }

  void clearFilter() {
    emit(state.copyWith(filter: null));
  }
}

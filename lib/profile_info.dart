import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  final String bankName;
  final int checkingAmount;
  final int depositAmount;

  const ProfileScreen({
    super.key,
    required this.bankName,
    required this.checkingAmount,
    required this.depositAmount,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Личный кабинет'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Банк: $bankName', style: const TextStyle(fontSize: 20)),
            const SizedBox(height: 12),
            Text('Сумма на расчетном счёте: ${formatRub(checkingAmount)}'),
            const SizedBox(height: 8),
            Text('Сумма на вкладе: ${formatRub(depositAmount)}'),
          ],
        ),
      ),
    );
  }
}

String formatRub(int amount) {
  return '$amount р.';
}

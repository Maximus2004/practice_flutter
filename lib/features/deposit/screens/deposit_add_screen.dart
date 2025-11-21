import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../shared/app_cubit.dart';
import '../../../shared/uikit/finance_widgets.dart';

class DepositAddScreen extends StatelessWidget {
  final String explanation;

  const DepositAddScreen({
    super.key,
    required this.explanation,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Добавление вклада")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ExplanationText('Добавление вклада. $explanation'),
            const SizedBox(height: 16),

            AmountPercentInput(
              amountLabel: 'Сумма вклада (₽)',
              percentLabel: 'Годовой %',
              buttonText: 'Применить',
              onAdd: (amount, percent) {
                context.read<BillCubit>().setDeposit(amount.round());
                Navigator.pop(context);
              },
            ),

            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../auth/auth_cubit.dart';

class ProfileScreen extends StatelessWidget {
  final String bankName;
  final int checkingAmount;
  final int depositAmount;
  final VoidCallback? onSelectBankTap;

  const ProfileScreen({
    super.key,
    required this.bankName,
    required this.checkingAmount,
    required this.depositAmount,
    required this.onSelectBankTap
  });

  @override
  Widget build(BuildContext context) {
    const String imageUrl = "https://upload.wikimedia.org/wikipedia/commons/9/99/Sample_User_Icon.png";
    return Scaffold(
      appBar: AppBar(
        title: const Text('Личный кабинет'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CachedNetworkImage(
              imageUrl: imageUrl,
              height: 300,
              width: 300,
              imageBuilder: (context, imageProvider) => CircleAvatar(
                backgroundImage: imageProvider,
                radius: 100,
              ),
              progressIndicatorBuilder: (context, url, progress) =>
              const CircularProgressIndicator(),
              errorWidget: (context, url, error) => const Icon(
                  Icons.error,
                  color: Colors.red,
                  size: 60
              ),
            ),
            const SizedBox(height: 12, width: double.infinity),
            Text('Банк: $bankName', style: const TextStyle(fontSize: 20)),
            const SizedBox(height: 12),
            Text('Сумма на расчетном счёте: ${formatRub(checkingAmount)}'),
            const SizedBox(height: 8),
            Text('Сумма на вкладе: ${formatRub(depositAmount)}'),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: onSelectBankTap,
              child: const Text("Выбрать банк"),
            ),
            const SizedBox(height: 12),
            BlocBuilder<AuthCubit, AuthState>(
              builder: (context, state) {
                if (!state.isAuthorized) {
                  return ElevatedButton(
                    onPressed: () => context.push('/auth'),
                    child: const Text('Войти'),
                  );
                }

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Вы вошли как: ${state.login}"),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: () => context.read<AuthCubit>().logout(),
                      child: const Text("Выйти"),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

String formatRub(int amount) {
  return '$amount р.';
}

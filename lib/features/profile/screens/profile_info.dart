import 'package:cached_network_image/cached_network_image.dart';
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
          ],
        ),
      ),
    );
  }
}

String formatRub(int amount) {
  return '$amount р.';
}

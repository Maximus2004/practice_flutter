import 'package:flutter/material.dart';
import 'package:practice/shared/app_router.dart';

void main() {
  runApp(
    AppStateContainer(
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Простобанк',
      routerConfig: router,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
    );
  }
}

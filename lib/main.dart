import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:practice/shared/app_router.dart';
import 'package:practice/shared/service_locator.dart';
import 'bloc_observer.dart';
import 'features/auth/auth_cubit.dart';

void main() {
  Bloc.observer = AppBlocObserver();
  setupLocator();
  runApp(
    BlocProvider(
      create: (context) => AuthCubit(),
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

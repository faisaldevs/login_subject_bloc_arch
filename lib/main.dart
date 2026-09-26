import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:login_subject_demo_bloc_arch/core/bloc/app_bloc_observer.dart';
import 'package:login_subject_demo_bloc_arch/core/routes/app_routes.dart';
import 'package:login_subject_demo_bloc_arch/di.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kDebugMode) Bloc.observer = const AppBlocObserver();
  await init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(routerConfig: router);
  }
}

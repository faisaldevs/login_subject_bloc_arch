import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:login_subject_demo_bloc_arch/core/routes/app_routes.dart';
import 'package:login_subject_demo_bloc_arch/core/storage/secure_stroage.dart';
import 'package:login_subject_demo_bloc_arch/di.dart';

class Loading extends StatefulWidget {
  const Loading({super.key});

  @override
  State<Loading> createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  @override
  void initState() {
    super.initState();
    _initial();
  }

  void _initial() async {
    await Future.delayed(const Duration(seconds: 3));

    final token = sl<SecureStroage>();

    final acc = await token.getAcessToken();
    final ref = await token.getRefreshToken();

    if (acc != null && ref != null) {
      Future.microtask(() {
        context.go(AppRoutes.home);
      });
    }else {
      Future.microtask(() {
        context.go(AppRoutes.login);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.amberAccent,
        width: double.infinity,
        height: double.infinity,
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:login_subject_demo_bloc_arch/features/auth/presentation/pages/login_screen.dart';
import 'package:login_subject_demo_bloc_arch/features/home/presentation/home_screen.dart';
import 'package:login_subject_demo_bloc_arch/features/start/loading.dart';
import 'package:login_subject_demo_bloc_arch/features/subject/presentation/page/subject_page.dart';

abstract class AppRoutes {
  static const String initial = "/";
  static const String login = "/login";
  static const String home = "/home";
  static const String subject = "/subject";
}

final GoRouter router = GoRouter(
  routes: <RouteBase>[
    GoRoute(
      path: AppRoutes.initial,
      builder: (BuildContext context, GoRouterState state) {
        return const Loading();
      },
    ),
    GoRoute(
      path: AppRoutes.login,
      builder: (BuildContext context, GoRouterState state) {
        return const LoginScreen();
      },
    ),

    GoRoute(
      path: AppRoutes.home,
      builder: (BuildContext context, GoRouterState state) {
        return const HomeScreen();
      },
    ),
    GoRoute(
      path: AppRoutes.subject,
      builder: (BuildContext context, GoRouterState state) {
        return const SubjectPage();
      },
    ),
  ],
);

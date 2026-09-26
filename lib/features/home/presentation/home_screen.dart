import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:login_subject_demo_bloc_arch/core/routes/app_routes.dart';
import 'package:login_subject_demo_bloc_arch/di.dart';
import 'package:login_subject_demo_bloc_arch/features/auth/domain/entities/user.dart';
import 'package:login_subject_demo_bloc_arch/features/home/presentation/bloc/profile_bloc.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<ProfileBloc>()..add(const ProfileRequested()),
      child: const _HomeView(),
    );
  }
}

class _HomeView extends StatelessWidget {
  const _HomeView();

  Future<void> _refresh(BuildContext context) async {
    final bloc = context.read<ProfileBloc>()..add(const ProfileRequested());
    // RefreshIndicator needs a Future that completes when the fetch ends.
    await bloc.stream.firstWhere((s) => s.status != ProfileStatus.loading);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: BlocConsumer<ProfileBloc, ProfileState>(
        listenWhen: (prev, curr) => prev.status != curr.status,
        listener: (context, state) {
          if (state.status == ProfileStatus.unauthenticated) {
            context.go(AppRoutes.login);
          } else if (state.status == ProfileStatus.failure &&
              state.user != null) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(content: Text(state.errorMessage ?? 'Refresh failed')),
              );
          }
        },
        builder: (context, state) {
          final user = state.user;
          if (user != null) {
            return RefreshIndicator(
              onRefresh: () => _refresh(context),
              child: _ProfileView(user: user),
            );
          }
          if (state.status == ProfileStatus.failure) {
            return _ErrorView(
              message: state.errorMessage ?? 'Something went wrong',
              onRetry: () =>
                  context.read<ProfileBloc>().add(const ProfileRequested()),
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}

class _ProfileView extends StatelessWidget {
  const _ProfileView({required this.user});

  final User user;

  @override
  Widget build(BuildContext context) {
    final photo = user.photo;

    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        Center(
          child: CircleAvatar(
            radius: 48,
            backgroundImage: photo != null
                ? CachedNetworkImageProvider(photo)
                : null,
            child: photo == null ? const Icon(Icons.person, size: 48) : null,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          user.name,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 24),
        _InfoTile(icon: Icons.phone, label: 'Mobile', value: user.mobile),
        _InfoTile(icon: Icons.email, label: 'Email', value: user.email),
        _InfoTile(
          icon: Icons.cake,
          label: 'Birthday',
          value: user.birthday?.toIso8601String().split('T').first,
        ),
        _InfoTile(
          icon: Icons.work,
          label: 'Profession',
          value: user.profession,
        ),
        _InfoTile(
          icon: Icons.school,
          label: 'Education',
          value: user.education,
        ),
        _InfoTile(
          icon: Icons.account_balance,
          label: 'Institution',
          value: user.institution,
        ),
        _InfoTile(icon: Icons.home, label: 'Address', value: user.address),
      ],
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            FilledButton(onPressed: onRetry, child: const Text('Retry')),
          ],
        ),
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  const _InfoTile({required this.icon, required this.label, this.value});

  final IconData icon;
  final String label;
  final String? value;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon),
      title: Text(label),
      subtitle: Text(value ?? '-'),
    );
  }
}

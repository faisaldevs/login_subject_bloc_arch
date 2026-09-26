import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:login_subject_demo_bloc_arch/di.dart';
import 'package:login_subject_demo_bloc_arch/features/subject/presentation/bloc/subjects_bloc.dart';

class SubjectPage extends StatelessWidget {
  const SubjectPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<SubjectsBloc>()..add(const GetSubjectEvent()),
      child: const SubjectPageView(),
    );
  }
}

class SubjectPageView extends StatelessWidget {
  const SubjectPageView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Subject Page'), centerTitle: true),
      body: BlocBuilder<SubjectsBloc, SubjectsState>(
        builder: (context, state) {
          switch (state.status) {
            case SubjectsStatus.initial:
            case SubjectsStatus.loading:
              return const Center(child: CircularProgressIndicator());
            case SubjectsStatus.failure:
              return Center(
                child: Text(state.errorMessage ?? 'Something went wrong'),
              );
            case SubjectsStatus.success:
              final subjects = state.subjectProgress!.subjects;
              return ListView.builder(
                itemCount: subjects.length,
                itemBuilder: (context, index) {
                  final subject = subjects[index];
                  return ListTile(
                    leading: subject.image != null
                        ? CircleAvatar(
                            backgroundImage: NetworkImage(subject.image!),
                          )
                        : const CircleAvatar(child: Icon(Icons.book)),
                    title: Text(subject.name),
                    subtitle: Text(
                      '${subject.practicedQuestions}/${subject.totalQuestions} practiced',
                    ),
                    trailing: Text(
                      '${subject.completionPercent.toStringAsFixed(0)}%',
                    ),
                  );
                },
              );
          }
        },
      ),
    );
  }
}

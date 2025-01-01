import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'myBloc.dart';

void main() {
  runApp(
    BlocProvider(
      create: (context) {
        List<Question> listQ = [Question(questionText: 'Le Flutter est développé par Google.', isCorrect: true),
          Question(questionText: 'Dart est un langage de programmation compilé en natif.', isCorrect: true),
          Question(questionText: 'Flutter est utilisé pour les applications web uniquement.', isCorrect: false)];
        return QuizBloc(listQ); },
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: QuizWidget(),
    );
  }
}


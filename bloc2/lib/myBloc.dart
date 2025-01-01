import 'package:bloc2/state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'events.dart';

class QuizWidget extends StatelessWidget {
  const QuizWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("BLoC Quiz")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            BlocBuilder<QuizBloc, QuizState>(
              builder: (context, state) {
                if (state is QuizValue) {
                  return Text(
                    state.getNextQuestions(),
                    style: const TextStyle(fontSize: 32),
                  );
                }
                return const CircularProgressIndicator();
              },
            ),
            ElevatedButton(
              onPressed: () {
                context.read<QuizBloc>().add(YesEvent());
              },
              child: const Text('True'),
            ),
            ElevatedButton(
              onPressed: () {
                context.read<QuizBloc>().add(NoEvent());
              },
              child: const Text('False'),
            ),
          ],
        ),
      ),
    );
  }
}





// Création du BLoC
class QuizBloc extends Bloc<QuizEvent, QuizState> {
  QuizBloc(List<Question> list) : super(QuizInitial()) {

    on<YesEvent>((event, emit) {
      final currentState = state;
      if (currentState is QuizValue) {
        emit(currentState.next(currentState, true));
      } else { // CounterInitiale
        QuizValue counterValue = QuizValue(0,list);
        emit(counterValue);
      }
    });

    on<NoEvent>((event, emit) {
      final currentState = state;
      if (currentState is QuizValue) {
        emit(currentState.next(currentState, false));
      } else { // CounterInitiale
        QuizValue counterValue = QuizValue(0,list);
        emit(counterValue);
      }
    });
  }
}

class Question {
  String questionText;
  bool isCorrect;
  Question({required this.questionText, required this.isCorrect});
}

import 'package:flutter/material.dart';

import 'myBloc.dart';

// Définition des états
abstract class QuizState {}

class QuizInitial extends QuizState {}

class QuizValue extends QuizState {
  int counter;
  List<Question> questions;
  late List<bool> answer;
  QuizValue(this.counter, this.questions) {
    answer = [];
  }


  @override
  String toString() {
    return 'CounterValue{counter: $counter, questions: $questions, answer: $answer}';
  }

  QuizValue next(QuizValue oldValue, bool answer) {
    QuizValue nextValue =
      QuizValue(oldValue.counter+1, oldValue.questions);
    nextValue.answer=oldValue.answer;

    if (oldValue.counter < oldValue.questions.length) {
      nextValue.answer.add(answer);
    }
    return nextValue;
  }

  String getNextQuestions() {
    if (counter < questions.length) {
      return "Q: ${questions[counter].questionText}";
    }
    int i = 0, accu = 0;
    for (final q in questions) {
      if (q.isCorrect == answer[i]) {
        accu++;
      }
      i++;
    } return "No more questions; score=$accu";
  }
}
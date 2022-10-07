import 'dart:math';

import '../model/word.dart';

class QuizService {
  final List<Word> questions;
  late List<int> _questionOrder;
  final List<int> _knownQuestions = [];
  late List<int> _maybeKnownQuestions;
  final List<int> _unknownQuestions = [];

  int correctAnswers = 0;
  int wrongAnswers = 0;

  int _currentIndex = -1;

  QuizService(this.questions) {
    _questionOrder = List<int>.generate(questions.length, (index) => index);
    _questionOrder.shuffle();
    _maybeKnownQuestions = List.of(_questionOrder);
  }

  Word nextQuestion() {
    if (_questionOrder.isEmpty) {
      _fillQuestions();
    }
    _currentIndex = _questionOrder.removeAt(0);
    return questions[_currentIndex];
  }

  bool checkAnswer(String answer) {
    if (_currentIndex < 0) {
      throw StateError(
          'None of the questions is selected. Call `nextQuestion()` first');
    }
    bool isCorrect = false;
    // good answer
    if (questions[_currentIndex].latin.toLowerCase() == answer.toLowerCase()) {
      if (!_knownQuestions.contains(_currentIndex)) {
        if (_unknownQuestions.remove(_currentIndex)) {
          _maybeKnownQuestions.add(_currentIndex);
        } else {
          _maybeKnownQuestions.remove(_currentIndex);
          _knownQuestions.add(_currentIndex);
        }
      }
      correctAnswers++;
      isCorrect = true;
    } else {
      if (!_unknownQuestions.contains(_currentIndex)) {
        _knownQuestions.remove(_currentIndex);
        _maybeKnownQuestions.remove(_currentIndex);
        _unknownQuestions.add(_currentIndex);
      }
      wrongAnswers++;
    }
    _currentIndex = -1;
    return isCorrect;
  }

  void _fillQuestions() {
    if (_unknownQuestions.isEmpty && _maybeKnownQuestions.isEmpty) {
      _questionOrder.addAll(_knownQuestions);
      _questionOrder.shuffle();
      return;
    }
    _questionOrder.addAll(_unknownQuestions);
    _questionOrder.addAll(_maybeKnownQuestions);
    _questionOrder.shuffle();
  }

  double getScorePercent() {
    if (correctAnswers + wrongAnswers == 0) return 0.0;

    return correctAnswers /
        max(correctAnswers + wrongAnswers, questions.length);
  }

  double getKnowledgePercent() {
    return _knownQuestions.length / questions.length;
  }
}

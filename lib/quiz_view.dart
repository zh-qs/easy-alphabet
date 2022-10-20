import 'package:easy_alphabet/backend/quiz_service.dart';
import 'package:easy_alphabet/model/word.dart';
import 'package:easy_alphabet/storage/word_storage.dart';
import 'package:flutter/material.dart';

class QuizView extends StatefulWidget {
  final QuizType quizType;
  final WordStorage storage;
  final String name;
  final int index;

  const QuizView(
      {super.key,
      required this.name,
      required this.storage,
      required this.index,
      required this.quizType});

  @override
  State<QuizView> createState() {
    return _QuizViewState();
  }
}

class _QuizViewState extends State<QuizView> {
  late QuizService _service;
  late Word _currentWord;
  String answerStatus = '';

  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    _service = QuizService(
        widget.storage.getWordBank(widget.name, widget.index), widget.quizType);
    _currentWord = _service.nextQuestion();
    super.initState();
  }

  void getNextQuestion() {
    setState(() {
      _currentWord = _service.nextQuestion();
    });
  }

  void checkAnswer(String answer) {
    setState(() {
      if (_service.checkAnswer(answer)) {
        answerStatus = 'Good!';
      } else {
        answerStatus =
            'Wrong! Correct answer: ${_currentWord.answer(widget.quizType)}';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Quiz'),
            leading: IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                Navigator.pop(context, _service.getScorePercent());
              },
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(children: [
              Expanded(
                  flex: 1,
                  child: Center(
                    child: Text(
                        'Score: ${(_service.getScorePercent() * 10000).roundToDouble() / 100}%, Knowledge: ${(_service.getKnowledgePercent() * 10000).roundToDouble() / 100}%'),
                  )),
              Expanded(
                flex: 5,
                child: Center(
                    child: Text(
                  _currentWord.question(widget.quizType),
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 24),
                )),
              ),
              Expanded(
                flex: 2,
                child: Row(children: [
                  Expanded(
                    flex: 7,
                    child: TextField(
                      controller: _controller,
                    ),
                  ),
                  Expanded(
                      flex: 1,
                      child: IconButton(
                        icon: answerStatus == ''
                            ? const Icon(Icons.done)
                            : const Icon(Icons.arrow_right),
                        onPressed: () {
                          if (answerStatus == '') {
                            checkAnswer(_controller.text);
                          } else {
                            answerStatus = '';
                            _controller.text = '';
                            getNextQuestion();
                          }
                        },
                      ))
                ]),
              ),
              Expanded(
                flex: 3,
                child: Text(answerStatus),
              )
            ]),
          ),
        ),
        onWillPop: () async {
          Navigator.pop(context, _service.getScorePercent());
          return false;
        });
  }
}

import 'package:easy_alphabet/quiz_view.dart';
import 'package:easy_alphabet/storage/word_storage.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

import 'model/points.dart';

class AlphabetDashboard extends StatefulWidget {
  final String name;
  final WordStorage storage;
  const AlphabetDashboard(
      {super.key, required this.name, required this.storage});

  @override
  State<AlphabetDashboard> createState() {
    return _AlphabetDashboardState();
  }
}

class _AlphabetDashboardState extends State<AlphabetDashboard> {
  static const int _alphabetIndex = 0;
  static const int _practiceIndex = 1;

  double _alphabetScore = 0;
  double _practiceScore = 0;

  @override
  void initState() {
    super.initState();
    var points = widget.storage.getPoints(widget.name);
    _alphabetScore = points.alphabetPercent;
    _practiceScore = points.practicePercent;
  }

  Color getProgressColor(double progress) {
    if (progress < 0.3) {
      return Colors.red.shade900;
    }
    if (progress < 0.5) {
      return Colors.amber.shade800;
    }
    if (progress < 0.7) {
      return Colors.yellow.shade700;
    }
    if (progress < 0.9) {
      return Colors.lime.shade800;
    }
    return Colors.green;
  }

  Color getTextColor(double progress) {
    return progress < 1 ? Colors.black : Colors.green.shade800;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(widget.name),
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back),
          )),
      body: ListView(padding: const EdgeInsets.all(8), children: [
        ListTile(
            title: Row(
          children: [
            Expanded(
              child: CircularPercentIndicator(
                percent: _alphabetScore,
                header: const Padding(
                  padding: EdgeInsets.all(10),
                  child: Text(
                    'Alphabet score',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                center: Text(
                  '${(_alphabetScore * 10000).roundToDouble() / 100}%',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                    color: getTextColor(_alphabetScore),
                  ),
                ),
                animation: true,
                radius: 70,
                lineWidth: 10,
                progressColor: getProgressColor(_alphabetScore),
              ),
            ),
            Expanded(
              child: CircularPercentIndicator(
                percent: _practiceScore,
                header: const Padding(
                  padding: EdgeInsets.all(10),
                  child: Text(
                    'Practice score',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                center: Text(
                  '${(_practiceScore * 10000).roundToDouble() / 100}%',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                      color: getTextColor(_practiceScore)),
                ),
                animation: true,
                radius: 70,
                lineWidth: 10,
                progressColor: getProgressColor(_practiceScore),
              ),
            ),
          ],
        )),
        ListTile(
            title: Row(children: [
          Expanded(
              child: TextButton.icon(
                  onPressed: () {
                    startQuiz(context, widget.name, _alphabetIndex);
                  },
                  icon: const Icon(Icons.abc),
                  label: const Text('Learn alphabet'))),
          Expanded(
              child: TextButton.icon(
                  onPressed: () {
                    startQuiz(context, widget.name, _practiceIndex);
                  },
                  icon: const Icon(Icons.question_answer),
                  label: const Text('Practice')))
        ])),
      ]),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog<bool>(
              context: context,
              builder: (context) => AlertDialog(
                    title: const Text('Delete'),
                    content: const Text(
                        'Do you really want to remove this script? You will lose all your progress.'),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(context, true),
                        child: const Text('OK'),
                      ),
                    ],
                  )).then(
            (value) {
              if (value != null && value) {
                widget.storage.removeWordBank(widget.name);
                Navigator.pop(context);
              }
            },
          );
        },
        backgroundColor: Colors.red,
        child: const Icon(Icons.close),
      ),
    );
  }

  void startQuiz(BuildContext context, String name, int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            QuizView(name: name, storage: widget.storage, index: index),
      ),
    ).then(
      (value) {
        setState(() {
          if (value > _alphabetScore) {
            _alphabetScore = value;
            widget.storage.savePoints(name, Points(value, _practiceScore));
          }
        });
      },
    );
  }
}

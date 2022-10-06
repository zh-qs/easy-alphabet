import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

class AlphabetDashboard extends StatelessWidget {
  final String name;
  final double _alphabetScore = 0.2137;
  final double _practiceScore = 1;

  const AlphabetDashboard(this.name, {super.key});

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
            title: Text(name),
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
                  radius: 100,
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
                  radius: 100,
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
                    onPressed: () {},
                    icon: const Icon(Icons.abc),
                    label: const Text('Learn alphabet'))),
            Expanded(
                child: TextButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.question_answer),
                    label: const Text('Practice')))
          ])),
        ]));
  }
}
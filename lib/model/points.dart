import 'package:hive/hive.dart';

part 'points.g.dart';

@HiveType(typeId: 1)
class Points {
  static final Points empty = Points(0, 0, 0, 0);

  @HiveField(0)
  double alphabetReadPercent;

  @HiveField(1)
  double practiceReadPercent;

  @HiveField(2)
  double alphabetWritePercent;

  @HiveField(3)
  double practiceWritePercent;

  Points(this.alphabetReadPercent, this.practiceReadPercent,
      this.alphabetWritePercent, this.practiceWritePercent);

  Points modified(void Function(Points) mapFunction) {
    var p = Points(alphabetReadPercent, practiceReadPercent,
        alphabetWritePercent, practiceWritePercent);
    mapFunction(p);
    return p;
  }

  double getAverageAlphabetPercent() =>
      (alphabetReadPercent + alphabetWritePercent) / 2;

  double getAveragePracticePercent() =>
      (practiceReadPercent + practiceWritePercent) / 2;
}

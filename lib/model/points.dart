import 'package:hive/hive.dart';

part 'points.g.dart';

@HiveType(typeId: 1)
class Points {
  @HiveField(0)
  double alphabetPercent;

  @HiveField(1)
  double practicePercent;

  Points(this.alphabetPercent, this.practicePercent);
}

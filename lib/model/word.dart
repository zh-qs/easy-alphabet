import 'package:hive/hive.dart';

part 'word.g.dart';

@HiveType(typeId: 0)
class Word {
  @HiveField(0)
  String latin;

  @HiveField(1)
  String foreign;

  Word(this.latin, this.foreign);
}

import 'package:hive/hive.dart';

part 'word.g.dart';

enum QuizType { latinToForeign, foreignToLatin }

@HiveType(typeId: 0)
class Word {
  @HiveField(0)
  String latin;

  @HiveField(1)
  String foreign;

  Word(this.latin, this.foreign);

  String question(QuizType type) =>
      type == QuizType.latinToForeign ? latin : foreign;

  String answer(QuizType type) =>
      type == QuizType.foreignToLatin ? latin : foreign;
}

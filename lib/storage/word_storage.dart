import 'package:easy_alphabet/model/points.dart';

import '../model/word.dart';
import 'package:hive/hive.dart';

abstract class WordStorage {
  List<String> listWordBanks();
  List<Word> getWordBank(String name);
  void addWordBank(String name, List<Word> contents);
  void savePoints(String name, Points points);
  Points getPoints(String name);
}

class DummyWordStorage implements WordStorage {
  Map<String, List<Word>> storage = {
    'Cyryllic': [Word('pożałujsta', 'Пожалуйста'), Word('da', 'Да')]
  };

  Map<String, Points> pointsStorage = {'Cyryllic': Points(0.67, 0.32)};

  @override
  void addWordBank(String name, List<Word> contents) {
    if (storage.containsKey(name)) {
      throw ArgumentError('Word Bank `$name` already exists');
    }

    storage.putIfAbsent(name, () => contents);
  }

  @override
  List<Word> getWordBank(String name) {
    if (!storage.containsKey(name)) {
      throw ArgumentError('Word Bank `$name` doesn\'t exist');
    }

    return storage[name]!;
  }

  @override
  List<String> listWordBanks() {
    return List.from(storage.keys);
  }

  @override
  Points getPoints(String name) {
    if (!pointsStorage.containsKey(name)) {
      throw ArgumentError('Record `$name` doesn\'t exist');
    }

    return pointsStorage[name]!;
  }

  @override
  void savePoints(String name, Points points) {
    pointsStorage[name] = points;
  }
}

class LocalWordStorage implements WordStorage {
  static const storageName = 'wordLists';
  static const pointStorageName = 'points';

  @override
  void addWordBank(String name, List<Word> contents) {
    var box = Hive.box(storageName);

    if (box.containsKey(name)) {
      throw ArgumentError('Word Bank `$name` already exists');
    }

    box.put(name, contents);
  }

  @override
  List<Word> getWordBank(String name) {
    var box = Hive.box(storageName);

    if (!box.containsKey(name)) {
      throw ArgumentError('Word Bank `$name` doesn\'t exist');
    }

    return box.get(name);
  }

  @override
  List<String> listWordBanks() {
    var box = Hive.box(storageName);
    return List.from(box.keys);
  }

  @override
  Points getPoints(String name) {
    var box = Hive.box(pointStorageName);

    if (box.containsKey(name)) {
      throw ArgumentError('Record `$name` doesn\'t exist');
    }

    return box.get(name);
  }

  @override
  void savePoints(String name, Points points) {
    var box = Hive.box(pointStorageName);
    box.put(name, points);
  }
}

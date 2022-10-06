import '../model/word.dart';
import 'package:hive/hive.dart';

abstract class WordStorage {
  List<String> listWordBanks();
  List<Word> getWordBank(String name);
  void addWordBank(String name, List<Word> contents);
}

class DummyWordStorage implements WordStorage {
  Map<String, List<Word>> storage = {
    'Cyryllic': [Word('pożałujsta', 'Пожалуйста'), Word('da', 'Да')]
  };

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
}

class LocalWordStorage implements WordStorage {
  static const storageName = 'wordLists';

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
}

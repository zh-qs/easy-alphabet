import 'package:easy_alphabet/model/script_links.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../model/word.dart';

class ApiService {
  static final Uri apiUrl = Uri.https('drive.google.com', 'uc', {
    'export': 'download',
    'id': '1O229Qjw0MZkGSl_glh2XiBm2xClrw0I1'
  }); //Uri.directory(
  //  r'E:\DANE\Visual Basic\Flutter\EasyAlphabet\easy_alphabet\api_files',
  //  windows: true,
  //);
  static const String scriptListId = '1O229Qjw0MZkGSl_glh2XiBm2xClrw0I1';
  //static final Uri scriptListApiUrl = apiUrl.resolve('scripts.json');

  Uri _makeJsonFileUri(String fileId) =>
      Uri.https('drive.google.com', 'uc', {'export': 'download', 'id': fileId});

  Future<List<ScriptLinks>> getScriptList() async {
    final response = await http.get(_makeJsonFileUri(scriptListId));
    var list = <ScriptLinks>[];
    if (response.statusCode == 200) {
      final data = jsonDecode(utf8.decode(response.bodyBytes));
      for (var entry in data.entries) {
        final innerData = entry.value;
        list.add(ScriptLinks(
            entry.key, innerData['alphabet'], innerData['practice']));
      }
      return list;
    }
    throw StateError(response.body);
  }

  Future<List<List<Word>>> getWordBanksFrom(ScriptLinks links) async {
    return [
      await _getWordBankFrom(links.alphabetApiId),
      await _getWordBankFrom(links.practiceApiId)
    ];
  }

  Future<List<Word>> _getWordBankFrom(String fileId) async {
    final response = await http.get(_makeJsonFileUri(fileId));
    if (response.statusCode != 200) {
      throw StateError(response.body);
    }

    var list = <Word>[];

    final data = jsonDecode(utf8.decode(response.bodyBytes));
    for (var entry in data.entries) {
      list.add(Word(entry.value, entry.key));
    }

    return list;
  }
}

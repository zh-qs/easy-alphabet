import 'package:easy_alphabet/model/points.dart';
import 'package:easy_alphabet/model/script_links.dart';
import 'package:easy_alphabet/web/api_service.dart';
import 'package:easy_alphabet/widgets/static_listtile_card.dart';
import 'package:easy_alphabet/widgets/tappable_listtile_card.dart';
import 'package:flutter/material.dart';
import 'storage/word_storage.dart';

class WebAlphabetsView extends StatefulWidget {
  final WordStorage storage;

  const WebAlphabetsView({super.key, required this.storage});

  @override
  State<WebAlphabetsView> createState() {
    return _WebAlphabetsViewState();
  }
}

class _WebAlphabetsViewState extends State<WebAlphabetsView> {
  final _service = ApiService();
  final _storedBanks = <String>[];

  final List<ScriptLinks> _links = [];
  bool _loading = true;

  void setScriptLinks(List<ScriptLinks> newList) {
    setState(() {
      _links.clear();
      _links.addAll(newList);
      _links.sort((a, b) => a.name.compareTo(b.name));

      _links.sort((a, b) =>
          (_storedBanks.contains(a.name) ? 1 : 0) -
          (_storedBanks.contains(b.name) ? 1 : 0));
      _loading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _storedBanks.addAll(widget.storage.listWordBanks());
    _service.getScriptList().then((list) => setScriptLinks(list));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('More scripts')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: _links.length,
              itemBuilder: (context, index) {
                return _storedBanks.contains(_links[index].name)
                    ? StaticListTileCard(
                        child: Text(
                          '${_links[index].name} (installed)',
                          style: const TextStyle(color: Colors.grey),
                        ),
                      )
                    : TappableListTileCard(
                        child: Text(_links[index].name),
                        onTap: () {
                          showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                  title: const Text('Installing'),
                                  content: Row(
                                    children: const [
                                      CircularProgressIndicator(),
                                      Text('     Please wait')
                                    ],
                                  )));
                          _service
                              .getWordBanksFrom(_links[index])
                              .then((value) {
                            widget.storage
                              ..addWordBank(
                                  _links[index].name, value[0], value[1])
                              ..savePoints(_links[index].name, Points.empty);
                            Navigator.pop(context);
                            Navigator.pop(context);
                          });
                        });
              }),
    );
  }
}

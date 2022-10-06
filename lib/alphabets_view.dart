import 'package:easy_alphabet/alphabet_dashboard.dart';
import 'package:easy_alphabet/widgets/tappable_listtile_card.dart';
import 'package:flutter/material.dart';
import 'storage/word_storage.dart';

class AlphabetsView extends StatelessWidget {
  final WordStorage _storage = DummyWordStorage();

  AlphabetsView({super.key});

  @override
  Widget build(BuildContext context) {
    var items = _storage.listWordBanks();
    return Scaffold(
        appBar: AppBar(title: const Text('Easy Alphabet')),
        body: ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: items.length,
            itemBuilder: (context, index) {
              return TappableListTileCard(
                  child: Text(items[index]),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                AlphabetDashboard(items[index])));
                  });
            }));
  }
}

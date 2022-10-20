import 'package:easy_alphabet/alphabet_dashboard.dart';
import 'package:easy_alphabet/web_alphabets_view.dart';
import 'package:easy_alphabet/widgets/tappable_listtile_card.dart';
import 'package:flutter/material.dart';
import 'storage/word_storage.dart';

class AlphabetsView extends StatefulWidget {
  const AlphabetsView({super.key});

  @override
  State<AlphabetsView> createState() {
    return _AlphabetsViewState();
  }
}

class _AlphabetsViewState extends State<AlphabetsView> {
  final WordStorage _storage = WordStorage.create();

  final List<String> items = [];

  void setWordBanks(List<String> newList) {
    setState(() {
      items.clear();
      items.addAll(newList);
    });
  }

  @override
  void initState() {
    super.initState();
    items.addAll(_storage.listWordBanks());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Easy Alphabet')),
      body: items.isEmpty
          ? const Center(child: Text('No items here. Try to add some!'))
          : ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: items.length,
              itemBuilder: (context, index) {
                return TappableListTileCard(
                    child: Text(items[index]),
                    onTap: () {
                      Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AlphabetDashboard(
                                        name: items[index],
                                        storage: _storage,
                                      )))
                          .then((_) => setWordBanks(_storage.listWordBanks()));
                    });
              }),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: ((context) =>
                          WebAlphabetsView(storage: _storage))))
              .then((_) => setWordBanks(_storage.listWordBanks()));
        },
      ),
    );
  }
}

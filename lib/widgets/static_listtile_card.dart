import 'package:flutter/material.dart';

class StaticListTileCard extends StatelessWidget {
  final Widget? child;

  const StaticListTileCard({super.key, this.child});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: child,
      ),
    );
  }
}

import 'package:flutter/material.dart';

class TappableListTileCard extends StatelessWidget {
  final Widget? child;
  final GestureTapCallback? onTap;

  const TappableListTileCard({super.key, this.child, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        child: ListTile(
          title: child,
        ),
      ),
    );
  }
}

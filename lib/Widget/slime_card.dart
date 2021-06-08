import 'package:flutter/material.dart';
import 'package:slime_farm/Model/slime_model.dart';

class SlimeCard extends StatelessWidget {
  final Slime slime;

  SlimeCard({
    Key? key,
    required this.slime,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.center,

        child: Icon(
          Icons.android,
          color: getColor(slime.colorGeneA),
        )
    );
  }

  Color getColor(int i) {
    switch (i) {
      case 0:
        return Colors.lightGreenAccent;
      case 1:
        return Colors.lightBlueAccent;
      case 2:
        return Colors.pinkAccent;
      default:
        return Colors.lightGreenAccent;
    }
  }
}

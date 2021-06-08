import 'package:flutter/material.dart';
import 'package:slime_farm/Model/slime_model.dart';

Container slimeCard(Slime slime) {
  return Container(
    alignment: Alignment.center,
    child: ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Container(
        color: Colors.purple.shade100,
        child: Center(
          child: slimeWidget(slime),
        ),
      ),
    ),
  );
}

Container cardWidget() {
  return Container(
    alignment: Alignment.center,
    child: ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Container(
        color: Colors.purple.shade100,
      ),
    ),
  );
}

Image slimeWidget(Slime slime) {
  return Image(
    image: AssetImage(
        slime.colorGeneA == 2
            ? 'assets/slime_pink.png'
            : slime.colorGeneA == 1
            ? 'assets/slime_blue.png'
            : 'assets/slime_green.png'
    ),
  );
}
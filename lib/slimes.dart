import 'package:flutter/material.dart';
import 'dart:math';

class SlimesView extends StatefulWidget {
  @override
  _SlimesViewState createState() => _SlimesViewState();
}

class _SlimesViewState extends State<SlimesView> with SingleTickerProviderStateMixin {
  List<Slime> list = <Slime>[];

  Random random = Random();
  List<Color> colors = <Color>[
    Colors.lightGreenAccent,
    Colors.lightBlueAccent,
    Colors.pinkAccent,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: list.isEmpty ? Center(child: Text('No Slimes')) : _buildList(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          addItem(Slime(color: Colors.green));
        },
      ),
    );
  }

  Widget _buildList() {
    return ListView.builder(
      itemCount: list.length,
        itemBuilder: (context, index) {
          return _buildItem(list[index], index);
        }
    );
  }

  Widget _buildItem(Slime item, index) {
    return ListTile(
      title: Text('${item.hashCode}'),
      trailing: Icon(
        Icons.android,
        color: item.color,
      ),
    );
  }

  void addItem(Slime item) {
    int index = random.nextInt(3);
    Slime randomSlime = Slime(color: colors[index]);

    setState(() {
      list.insert(0, randomSlime);
    });
  }
}

class Slime {
  Color color;

  Slime({
    required this.color,
  });
}

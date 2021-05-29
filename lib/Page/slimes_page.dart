import 'package:flutter/material.dart';
import 'dart:math';
import 'package:slime_farm/Model/slime_model.dart';

class SlimesPage extends StatefulWidget {
  @override
  _SlimesPageState createState() => _SlimesPageState();
}

class _SlimesPageState extends State<SlimesPage> {
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
          addItem();
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
        color: colors[item.colorGeneA],
      ),
    );
  }

  void addItem() {
    Slime randomSlime = Slime(colorGeneA: random.nextInt(3), colorGeneB: 0, timestamp: DateTime.now());

    setState(() {
      list.insert(0, randomSlime);
    });
  }
}

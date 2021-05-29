import 'package:flutter/material.dart';
import 'package:slime_farm/Database/slimes_database.dart';
import 'package:slime_farm/Model/slime_model.dart';
import 'dart:math';

class SlimesPage extends StatefulWidget {
  @override
  _SlimesPageState createState() => _SlimesPageState();
}

class _SlimesPageState extends State<SlimesPage> {
  late List<Slime> slimes = <Slime>[];
  bool isLoading = false;

  List<Color> colors = <Color>[
    Colors.lightGreenAccent,
    Colors.lightBlueAccent,
    Colors.pinkAccent,
  ];

  @override
  void initState() {
    super.initState();
    refreshSlimes();
  }

  @override
  void dispose() {
    SlimesDatabase.instance.close();
    super.dispose();
  }

  Future refreshSlimes() async {
    //setState(() => isLoading = true);
    this.slimes = await SlimesDatabase.instance.readAllSlimes();
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? Center(child: CircularProgressIndicator(),)
          : slimes.isEmpty
          ? Center(child: Text('No Slimes'))
          : _buildList(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          addSlime();
        },
      ),
    );
  }

  Widget _buildList() {
    return ListView.builder(
        itemCount: slimes.length,
        itemBuilder: (context, index) {
          return _buildItem(slimes[index], index);
        }
    );
  }

  Widget _buildItem(Slime slime, index) {
    return ListTile(
      title: Text('${slime.hashCode}'),
      trailing: Icon(
        Icons.android,
        color: colors[slime.colorGeneA],
      ),
    );
  }

  void addSlime() {
    Random random = Random();
    Slime randomSlime = Slime(colorGeneA: random.nextInt(3), colorGeneB: 0, timestamp: DateTime.now());

    setState(() {
      slimes.insert(0, randomSlime);
    });
  }
}

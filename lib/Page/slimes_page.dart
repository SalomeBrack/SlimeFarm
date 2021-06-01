import 'package:flutter/material.dart';
import 'package:slime_farm/Database/slimes_database.dart';
import 'package:slime_farm/Model/slime_model.dart';
import 'package:slime_farm/Widget/slime_card.dart';
import 'dart:math';

class SlimesPage extends StatefulWidget {
  @override
  _SlimesPageState createState() => _SlimesPageState();
}

class _SlimesPageState extends State<SlimesPage> {
  late List<Slime> slimes;
  bool isLoading = false;
  double _gridSpacing = 10;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : slimes.isEmpty
          ? Center(child: Text('No Slimes'))
          : GridView.extent(
              maxCrossAxisExtent: 200,
              mainAxisSpacing: _gridSpacing,
              crossAxisSpacing: _gridSpacing,
              padding: EdgeInsets.all(_gridSpacing),

              children: List.generate(slimes.length, (index) => Stack(
                children: [SlimeCard(slime: slimes[index])],
              )),
          ),

      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        tooltip: 'Buy',
        onPressed: () { addSlime(); },
      ),
    );
  }

  void addSlime() async {
    Random random = Random();

    final slime = Slime(
        timestamp: DateTime.now(),
        colorGeneA: random.nextInt(3),
        colorGeneB: 0
    );

    await SlimesDatabase.instance.create(slime);

    refreshSlimes();
  }

  Future refreshSlimes() async {
    setState(() => isLoading = true);
    this.slimes = await SlimesDatabase.instance.readAllSlimes();
    setState(() => isLoading = false);
  }
}

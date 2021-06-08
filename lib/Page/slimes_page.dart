import 'package:flutter/material.dart';
import 'package:slime_farm/Shared/money.dart';
import 'package:slime_farm/Database/slimes_database.dart';
import 'package:slime_farm/Model/slime_model.dart';
import 'package:slime_farm/Shared/navigation.dart';
import 'package:slime_farm/Widget/slime.dart';
import 'dart:math';

class SlimesPage extends StatefulWidget {
  @override
  SlimesPageState createState() => SlimesPageState();
}

class SlimesPageState extends State<SlimesPage> {
  MoneyNotifier moneyNotifier = MoneyNotifier();
  NavigationNotifier navigation = NavigationNotifier();
  late List<Slime> slimes;
  bool isLoading = false;
  double _gridSpacing = 10;
  bool _dragMode = false;

  Slime? slimeA;
  Slime? slimeB;

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
    return Column(
      children: [
        Container(color: Colors.purple, width: double.infinity),

        /// Slimes Fenster
        Expanded(
          child: Scaffold(
            body: isLoading
                ? Center(child: CircularProgressIndicator())
                : slimes.isEmpty
                ? Center(child: Text('Buy Slimes'))
                : Stack(children: [

                  /// Liste mit Slimes und Pfeil
                  GridView.extent(
                    maxCrossAxisExtent: 220,
                    mainAxisSpacing: _gridSpacing,
                    crossAxisSpacing: _gridSpacing,
                    padding: EdgeInsets.all(_gridSpacing),
                    children: List.generate(slimes.length, (index) => _dragMode

                      /// Dragbare Items
                      ? Draggable<Slime>(
                        child: slimeCard(slimes[index]),
                        childWhenDragging: cardWidget(),
                        feedback: Container(
                          width: 150,
                          child: slimeWidget(slimes[index]),
                        ),
                        data: slimes[index],
                      )

                      /// Klickbare Items
                      : GestureDetector(
                        child: slimeCard(slimes[index]),
                        onTap: () {
                          Navigator.of(context).pushNamed('/slime', arguments: slimes[index].id);
                        },
                      ),
                    ),
                  ),

                  /// Pfeil zum Drag-Menü öffnen
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: TextButton(
                      onPressed: () { setState(() { _dragMode = !_dragMode; }); },
                      child: Icon(_dragMode ? Icons.keyboard_arrow_down : Icons.keyboard_arrow_up),
                    ),
                  ),
                ]),

            /// Add Slime Button
            floatingActionButton: FloatingActionButton(
              child: Icon(Icons.add),
              tooltip: 'Buy Random',
              onPressed: () {
                buyRandomSlime();
              },
            ),
          ),
        ),

        /// Breeding Fenster
        AnimatedContainer(
          duration: Duration(milliseconds: 600),
          width: double.infinity,
          height: _dragMode ? 200 : 0,
          color: Colors.purple.shade300,
          curve: Curves.linearToEaseOut,
          child: Column(
            children: [
              Spacer(),

              Row(
                children: [
                  Spacer(),

                  /// Slime A
                  DragTarget<Slime>(
                    builder: (
                        BuildContext context,
                        List<dynamic> accepted,
                        List<dynamic> rejected,
                        ) {
                      return Container(
                        height: 100,
                        width: 100,
                        child:  slimeA == null ? cardWidget() : slimeCard(slimeA!),
                      );
                    },
                    onAccept: (Slime data) {
                      setState(() {
                        slimeA = data;
                      });
                    },
                  ),

                  /// Breeting Button
                  Padding(
                    padding: EdgeInsets.only(left: 10, right: 10),
                    child: ElevatedButton(
                      child: Icon(Icons.favorite),
                      onPressed: () {
                        if (slimeA != null && slimeB != null) {
                          breedSlime(slimeA!.colorIndex, slimeB!.colorIndex);
                        }
                      },
                    ),
                  ),

                  /// Slime B
                  DragTarget<Slime>(
                    builder: (
                        BuildContext context,
                        List<dynamic> accepted,
                        List<dynamic> rejected,
                        ) {
                      return Container(
                        height: 100,
                        width: 100,
                        child: slimeB == null ? cardWidget() : slimeCard(slimeB!),
                      );
                    },
                    onAccept: (Slime data) {
                      setState(() {
                        slimeB = data;
                      });
                    },
                  ),

                  Spacer(),
                ],
              ),

              Spacer(),
            ],
          ),
        ),
      ],
    );
  }

  void breedSlime(int colorIndexA, int colorIndexB) async {
    Random random = Random();
    int colorIndex;
    if (random.nextInt(2) == 0) {
      colorIndex = colorIndexA;
    } else {
      colorIndex = colorIndexB;
    }

    final slime = Slime(
      timestamp: DateTime.now(),
      colorIndex: colorIndex,
    );

    await SlimesDatabase.instance.create(slime);

    refreshSlimes();
  }

  void buyRandomSlime() async {
    Random random = Random();

    final slime = Slime(
        timestamp: DateTime.now(),
        colorIndex: random.nextInt(3),
    );

    await SlimesDatabase.instance.create(slime);

    moneyNotifier.subtractMoney(5);

    refreshSlimes();
  }

  Future refreshSlimes() async {
    setState(() => isLoading = true);
    this.slimes = await SlimesDatabase.instance.readAllSlimes();
    setState(() => isLoading = false);
  }
}

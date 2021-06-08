import 'package:flutter/material.dart';
import 'package:slime_farm/Shared/colors.dart';
import 'package:slime_farm/Shared/money.dart';
import 'package:slime_farm/Database/slimes_database.dart';
import 'package:slime_farm/Model/slime_model.dart';
import 'package:slime_farm/Shared/prices.dart';
import 'package:slime_farm/Shared/slime.dart';
import 'dart:math';

class SlimesPage extends StatefulWidget {
  @override
  SlimesPageState createState() => SlimesPageState();
}

class SlimesPageState extends State<SlimesPage> {
  MoneyNotifier _moneyNotifier = MoneyNotifier();
  late List<Slime> slimes;
  Slime? _slimeA;
  Slime? _slimeB;
  bool _isLoading = false;
  bool _dragMode = false;
  double _gridSpacing = 10;
  int _priceRandom = 10;
  bool _sellMode = false;
  Slime? _selectedSlime;

  @override
  void initState() {
    super.initState();
    refreshSlimes();
  }

  Future refreshSlimes() async {
    setState(() => _isLoading = true);
    this.slimes = await SlimesDatabase.instance.readAllSlimes();
    setState(() => _isLoading = false);
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
        /// Sell Fenster
        AnimatedContainer(
          duration: Duration(milliseconds: 600),
          width: double.infinity,
          height: _sellMode ? 140 : 0,
          color: Colors.purple.shade300,
          curve: Curves.linearToEaseOut,
          child: Padding(
            padding: EdgeInsets.only(left: _gridSpacing, right: _gridSpacing),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 100,
                  width: 100,
                  child: _selectedSlime == null ? cardWidget() : slimeCard(_selectedSlime!),
                ),
                Spacer(),
                Padding(
                  padding: EdgeInsets.only(right: _gridSpacing),
                  child: ElevatedButton(
                    child: Text('Cancel'),
                    onPressed: () {
                      setState(() { _sellMode = false; });
                    },
                  ),
                ),
                ElevatedButton(
                  child: Text('Sell for ${_selectedSlime == null ? 0 : getPrice(_selectedSlime!.colorIndex)} €'),
                  onPressed: () {
                    if (_selectedSlime != null) {
                      sellSlime();
                    }
                  },
                ),
              ],
            ),
          ),
        ),

        /// Slimes Fenster
        Expanded(
          child: Scaffold(
            body: _isLoading
                ? Center(child: CircularProgressIndicator())
                : slimes.isEmpty
                ? Center(child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Buy Slimes'),
                    TextButton(
                        child: Text('Refresh'),
                        onPressed: () async {
                          refreshSlimes();
                        },
                    ),
                  ],
                ))
                : Stack(children: [

                  /// Liste mit Slimes und Pfeil
                  RefreshIndicator(
                    onRefresh: () async { refreshSlimes(); },
                    child: GridView.extent(
                      //dragStartBehavior: DragStartBehavior.start,
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
                              setState(() { _sellMode = true; });
                              _selectedSlime = slimes[index];
                            },
                          ),
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
              backgroundColor: MoneyNotifier.balance.value >= _priceRandom ? Colors.purple : Colors.grey,
              onPressed: () {
                if (MoneyNotifier.balance.value >= _priceRandom) {
                  buyRandomSlime();
                }
              },
            ),
          ),
        ),

        /// Breeding Fenster
        AnimatedContainer(
          duration: Duration(milliseconds: 600),
          width: double.infinity,
          height: _dragMode ? 140 : 0,
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
                        child: _slimeA == null ? cardWidget() : slimeCard(_slimeA!),
                      );
                    },
                    onAccept: (Slime data) {
                      setState(() {
                        _slimeA = data;
                      });
                    },
                  ),

                  /// Breeting Button
                  Padding(
                    padding: EdgeInsets.only(left: _gridSpacing, right: _gridSpacing),
                    child: ElevatedButton(
                      child: Icon(Icons.favorite),
                      onPressed: () {
                        if (_slimeA != null && _slimeB != null) {
                          breedSlime(_slimeA!.colorIndex, _slimeB!.colorIndex);
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
                        child: _slimeB == null ? cardWidget() : slimeCard(_slimeB!),
                      );
                    },
                    onAccept: (Slime data) {
                      setState(() {
                        _slimeB = data;
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

  void sellSlime() async {
    setState(() { _sellMode = false; });
    _moneyNotifier.addMoney(getPrice(_selectedSlime!.colorIndex));
    await SlimesDatabase.instance.delete(_selectedSlime!.id!);

    refreshSlimes();
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
    final slime = Slime(
      timestamp: DateTime.now(),
      colorIndex: getRandomColor(),
    );

    await SlimesDatabase.instance.create(slime);

    _moneyNotifier.subtractMoney(10);

    refreshSlimes();
  }
}

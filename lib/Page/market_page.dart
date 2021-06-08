import 'dart:async';
import 'package:flutter/material.dart';
import 'package:slime_farm/Model/slime_model.dart';
import 'package:slime_farm/Widget/slime_card.dart';
import 'dart:math';

class MarkedPage extends StatefulWidget {
  @override
  _MarkedPageState createState() => _MarkedPageState();
}

class _MarkedPageState extends State<MarkedPage> {
  var slimes = new List<Slime>.generate(10, (index) =>
      Slime(timestamp: DateTime.now(), colorGeneA: 0, colorGeneB: 0)
  );

  double _gridSpacing = 10;
  bool refreshingEnabled = false;
  DateTime _lastRefreshed = DateTime.now();
  Duration _waitingTime = Duration(minutes: 1);
  late Duration _sinceLastRefreshed;

  @override
  void initState() {
    super.initState();
    Timer.periodic(Duration(milliseconds: 100), (Timer t) => _getTime());
    refreshMarket();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GridView.extent(
        maxCrossAxisExtent: 200,
        mainAxisSpacing: _gridSpacing,
        crossAxisSpacing: _gridSpacing,
        padding: EdgeInsets.all(_gridSpacing),
        children: List.generate(slimes.length, (index) => SlimeCard(slime: slimes[index]),
        ),
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: refreshingEnabled
            ? Colors.purple
            : Colors.grey,
        child: refreshingEnabled
            ? Icon(Icons.replay)
            : CircularProgressIndicator(
              color: Colors.white,
              value: _sinceLastRefreshed.inMilliseconds / _waitingTime.inMilliseconds,
            ),
        tooltip: 'Refresh',
        onPressed: () async {
          if (_sinceLastRefreshed >= _waitingTime) {
            refreshMarket();


          }
        },
      ),
    );
  }

  void refreshMarket() {
    Random _random = Random();

    for (int i = 0; i < slimes.length; i++) {
      slimes[i] = Slime(
          timestamp: DateTime.now(),
          colorGeneA: _random.nextInt(3),
          colorGeneB: _random.nextInt(3),
      );
    }

    _lastRefreshed = DateTime.now();
  }

  void _getTime() {
    final DateTime now = DateTime.now();

    setState(() {
      _sinceLastRefreshed = now.difference(_lastRefreshed);

      if (_sinceLastRefreshed < _waitingTime) {
        refreshingEnabled = false;
      } else {
        refreshingEnabled = true;
      }
    });
  }
}

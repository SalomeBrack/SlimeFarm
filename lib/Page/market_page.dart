import 'dart:async';
import 'package:flutter/material.dart';
import 'package:slime_farm/Database/slimes_database.dart';
import 'package:slime_farm/Model/slime_model.dart';
import 'package:slime_farm/Shared/colors.dart';
import 'package:slime_farm/Shared/money.dart';
import 'package:slime_farm/Shared/prices.dart';
import 'package:slime_farm/Shared/slime.dart';

class MarkedPage extends StatefulWidget {
  @override
  _MarkedPageState createState() => _MarkedPageState();
}

class _MarkedPageState extends State<MarkedPage> {
  var slimes = new List<Slime>.generate(6, (index) =>
      Slime(timestamp: DateTime.now(), colorIndex: 0)
  );

  MoneyNotifier _moneyNotifier = MoneyNotifier();
  double _gridSpacing = 10;
  bool _refreshingEnabled = false;
  DateTime _lastRefreshed = DateTime.now();
  Duration _waitingTime = Duration(seconds: 30);
  late Duration _sinceLastRefreshed;
  bool _buyMode = false;
  Slime? _selectedSlime;

  @override
  void initState() {
    super.initState();
    Timer.periodic(Duration(milliseconds: 100), (Timer t) => _getTime());
    refreshMarket();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          AnimatedContainer(
            duration: Duration(milliseconds: 600),
            width: double.infinity,
            height: _buyMode ? 140 : 0,
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
                        _buyMode = false;
                      },
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        primary: _selectedSlime == null ? Colors.grey
                            : MoneyNotifier.balance.value < getPrice(_selectedSlime!.colorIndex)
                            ? Colors.grey : Colors.purple
                    ),
                    child: Text('Buy for ${_selectedSlime == null ? 0 : getPrice(_selectedSlime!.colorIndex)} €'),
                    onPressed: () {
                      if (_selectedSlime != null) {
                        if (MoneyNotifier.balance.value >= getPrice(_selectedSlime!.colorIndex)) {
                          buySlime();
                        }
                      }
                    },
                  ),
                ],
              ),
            ),
          ),

          Expanded(
            child: GridView.extent(
              maxCrossAxisExtent: 200,
              mainAxisSpacing: _gridSpacing,
              crossAxisSpacing: _gridSpacing,
              padding: EdgeInsets.all(_gridSpacing),
              children: List.generate(slimes.length, (index) =>
                GestureDetector(
                  child: slimeCard(slimes[index]),
                  onTap: () {
                    _buyMode = true;
                    _selectedSlime = slimes[index];
                  },
                ),
              ),
            ),
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: _refreshingEnabled
            ? Colors.purple
            : Colors.grey,
        child: _refreshingEnabled
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
    for (int i = 0; i < slimes.length; i++) {
      slimes[i] = Slime(
        timestamp: DateTime.now(),
        colorIndex: getRandomColor(),
      );
    }

    _lastRefreshed = DateTime.now();
  }

  void _getTime() {
    final DateTime now = DateTime.now();

    setState(() {
      _sinceLastRefreshed = now.difference(_lastRefreshed);

      if (_sinceLastRefreshed < _waitingTime) {
        _refreshingEnabled = false;
      } else {
        _refreshingEnabled = true;
      }
    });
  }

  void buySlime() async {
    _buyMode = false;
    _moneyNotifier.subtractMoney(getPrice(_selectedSlime!.colorIndex));
    await SlimesDatabase.instance.create(_selectedSlime!);
  }
}

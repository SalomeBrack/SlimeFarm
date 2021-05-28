import 'package:flutter/material.dart';
import 'package:slime_farm/farm.dart';
import 'package:slime_farm/money.dart';
import 'package:slime_farm/slimes.dart';
import 'package:slime_farm/store.dart';

class Nav extends StatefulWidget {
  @override
  _NavState createState() => _NavState();
}

class _NavState extends State<Nav> {
  int _selectedIndex = 0;
  List<Widget> _widgetOptions = <Widget>[
    SlimesView(),
    FarmView(), //Farm(),
    StoreView(),
  ];
  List<String> _appbarOptions = <String>[
    'Slimes',
    'Farm',
    'Store',
  ];

  void _onItemTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _appbarOptions.elementAt(_selectedIndex),
        ),
        actions: <Widget>[
          Padding(
            padding: EdgeInsets.only(right: 20),
            child: MoneyView(),
          ),
        ],
      ),
      body: IndexedStack(
        children: _widgetOptions,
        index: _selectedIndex,
      ),
      //_widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.android),
            label: 'Slimes',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.water_damage),
            label: 'Farm',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_business),
            label: 'Store',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTap,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}

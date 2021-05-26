import 'package:flutter/material.dart';
import 'package:slime_farm/farm.dart';
import 'package:slime_farm/slimes.dart';
import 'package:slime_farm/store.dart';

class Nav extends StatefulWidget {
  @override
  _NavState createState() => _NavState();
}

class _NavState extends State<Nav> {
  int _selectedIndex = 0;
  List<Widget> _widgetOptions = <Widget>[
    Farm(),
    Slimes(),
    Store(),
  ];
  List<String> _appbarOptions = <String>[
    'Farm',
    'Slimes',
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
        centerTitle: true,
      ),
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.water_damage),
            label: 'Farm',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.android),
            label: 'Slimes',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_business),
            label: 'Store',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTap,
      ),
    );
  }
}

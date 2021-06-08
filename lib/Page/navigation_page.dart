import 'package:flutter/material.dart';
import 'package:slime_farm/Shared/money.dart';
import 'package:slime_farm/Page/slimes_page.dart';
import 'package:slime_farm/Page/market_page.dart';

class NavigationPage extends StatefulWidget {
  @override
  _NavigationPageState createState() => _NavigationPageState();
}

class _NavigationPageState extends State<NavigationPage> {
  int _selectedIndex = 0;

  List<Widget> _widgetOptions = <Widget>[
    SlimesPage(),
    MarkedPage(),
  ];

  List<String> _appbarOptions = <String>[
    'My Slimes',
    'Market',
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
            child: Center(
              child: ValueListenableBuilder(
                valueListenable: MoneyNotifier.balance,
                builder: (context, value, child) {
                  return Text(
                    '${MoneyNotifier.balance.value} €',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  );
                },
              ),
            ),
          ),
        ],
      ),
      body: IndexedStack(
        children: _widgetOptions,
        index: _selectedIndex,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.android),
            label: 'Slimes',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_business),
            label: 'Market',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTap,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}

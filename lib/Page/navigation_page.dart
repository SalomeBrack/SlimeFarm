import 'package:flutter/material.dart';
import 'package:slime_farm/Shared/money.dart';
import 'package:slime_farm/Page/slimes_page.dart';
import 'package:slime_farm/Page/market_page.dart';
import 'package:slime_farm/Shared/navigation.dart';

class NavigationPage extends StatefulWidget {
  @override
  _NavigationPageState createState() => _NavigationPageState();
}

class _NavigationPageState extends State<NavigationPage> {
  NavigationNotifier navigation = NavigationNotifier();

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
      navigation.changePage(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _appbarOptions.elementAt(NavigationNotifier.page.value),
        ),
        actions: <Widget>[
          Padding(
            padding: EdgeInsets.only(right: 20),
            child: Center(
              child: ValueListenableBuilder(
                valueListenable: MoneyNotifier.balance,
                builder: (context, value, child) {
                  return Text('${MoneyNotifier.balance.value}');
                },
              ),
            ),
          ),
        ],
      ),
      body: IndexedStack(
        children: _widgetOptions,
        index: NavigationNotifier.page.value,
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
        currentIndex: NavigationNotifier.page.value,
        onTap: _onItemTap,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}

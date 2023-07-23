import 'package:convert_lang_app/Widgets/HomeWidget.dart';
import 'package:convert_lang_app/Widgets/ProfileWidget.dart';
import 'package:convert_lang_app/Widgets/SettingsWidget.dart';
import 'package:flutter/material.dart';

class NavigationWidget extends StatefulWidget {
  int _currentIndex;

  NavigationWidget(this._currentIndex);

  @override
  _NavigationBarState createState() => _NavigationBarState();
}

class _NavigationBarState extends State<NavigationWidget> {
  final List<Widget> _screens = [
    HomeWidget(),
    HomeWidget(),
    ProfileWidget(),
    SettingsWidget(),
  ];

  void _onTabTapped(int index) {
    setState(() {
      widget._currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[widget._currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home",backgroundColor: Colors.blue),
          BottomNavigationBarItem(icon: Icon(Icons.explore), label: "Explore",backgroundColor: Colors.blue),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile",backgroundColor: Colors.blue),
          BottomNavigationBarItem(icon: Icon(Icons.settings_rounded), label: "Settings",backgroundColor: Colors.blue)
        ],
        backgroundColor: Colors.blue,
        currentIndex: widget._currentIndex,
        onTap: (index) => _onTabTapped(index),
      ),
    );
  }
}

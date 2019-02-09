import 'package:flutter/material.dart';
import 'package:shop/routes.dart';

class SDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final String actualRoute = ModalRoute.of(context).settings.name;
    return Drawer(
      child: ListView(
        // Important: Remove any padding from the ListView.
        children: <Widget>[
          Container(
            color: _setBackgroundColor(actualRoute, Routes.mensOuterwears),
            child: ListTile(
              title: Text(
                'Men\'s outerwear',
                style: TextStyle(
                  color: _setColor(actualRoute, Routes.mensOuterwears),
                ),
              ),
              onTap: () {
                if (actualRoute == Routes.mensOuterwears) return;
                Navigator.popAndPushNamed(context, Routes.mensOuterwears);
              },
            ),
          ),
          Container(
            color: _setBackgroundColor(actualRoute, Routes.ladiesOuterwears),
            child: ListTile(
              title: Text(
                'Ladies outerwear',
                style: TextStyle(
                  color: _setColor(actualRoute, Routes.ladiesOuterwears),
                ),
              ),
              onTap: () {
                if (actualRoute == Routes.ladiesOuterwears) return;
                Navigator.popAndPushNamed(context, Routes.ladiesOuterwears);
              },
            ),
          ),
          Container(
            color: _setBackgroundColor(actualRoute, Routes.mensTshirts),
            child: ListTile(
              title: Text(
                'Men\'s T-Shirts',
                style: TextStyle(
                  color: _setColor(actualRoute, Routes.mensTshirts),
                ),
              ),
              onTap: () {
                if (actualRoute == Routes.mensTshirts) return;
                Navigator.popAndPushNamed(context, Routes.mensTshirts);
              },
            ),
          ),
          Container(
            color: _setBackgroundColor(actualRoute, Routes.ladiesTshirts),
            child: ListTile(
              title: Text(
                'Ladies T-Shirts',
                style: TextStyle(
                  color: _setColor(actualRoute, Routes.ladiesTshirts)
                ),
              ),
              onTap: () {
                if (actualRoute == Routes.ladiesTshirts) return;
                Navigator.popAndPushNamed(context, Routes.ladiesTshirts);
              },
            ),
          ),
        ],
      ),
    );
  }

  Color _setBackgroundColor(String actualRoute, String route) {
    if (actualRoute == route) {
      return Color.fromRGBO(23, 44, 80, 1);
    }
    return Colors.white10;
  }

  Color _setColor(String actualRoute, String route) {
    if (actualRoute == route) {
      return Colors.white;
    }
    return Colors.black;
  }
}

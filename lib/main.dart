import 'package:flutter/material.dart';
import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;

class ShopCategories {
  final List<Clothe> mensOuterwear;
  final List<Clothe> ladiesOuterwear;

  final List<Clothe> mensTshirts;
  final List<Clothe> ladiesTshirts;

  ShopCategories({
    this.mensOuterwear,
    this.ladiesOuterwear,
    this.mensTshirts,
    this.ladiesTshirts,
  });
}

class AppState {
  final ShopCategories categories;

  AppState(this.categories);

  factory AppState.initial(ShopCategories categories) {
    return AppState(categories);
  }
}

Future<List<Clothe>> loadJSON(String path) async {
  var data = await rootBundle.loadString(path);
  var decodedJSON = jsonDecode(data);
  return decodedJSON.map<Clothe>((clothe) => Clothe.fromJSON(clothe)).toList();
}

AppState reducer(AppState app, dynamic action) {
  return app;
}

void main() async {
  List<Clothe> ladiesOuterwear = await loadJSON('data/ladies_outerwear.json');
  List<Clothe> ladiesTshirts = await loadJSON('data/ladies_tshirts.json');
  List<Clothe> mensOuterwear = await loadJSON('data/mens_outerwear.json');
  List<Clothe> mensTshirts = await loadJSON('data/mens_tshirts.json');

  final store = Store<AppState>(
    reducer,
    initialState: AppState.initial(
      ShopCategories(
        ladiesOuterwear: ladiesOuterwear,
        ladiesTshirts: ladiesTshirts,
        mensOuterwear: mensOuterwear,
        mensTshirts: mensTshirts,
      ),
    ),
  );

  runApp(
    MyApp(store),
  );
}

class Clothe {
  final String name;
  final String title;
  final String category;
  final String description;
  final String image;
  final String largeImage;

  final num price;

  Clothe(this.name, this.title, this.category, this.description, this.image,
      this.largeImage, this.price);

  Clothe.fromJSON(Map<String, dynamic> json)
      : name = json['name'],
        title = json['title'],
        category = json['category'],
        description = json['description'],
        image = json['image'],
        largeImage = json['largeImage'],
        price = json['price'];
}

class MyApp extends StatelessWidget {
  final Store<AppState> store;

  MyApp(this.store);
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return StoreProvider<AppState>(
      store: store,
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          // This is the theme of your application.
          //
          // Try running your application with "flutter run". You'll see the
          // application has a blue toolbar. Then, without quitting the app, try
          // changing the primarySwatch below to Colors.green and then invoke
          // "hot reload" (press "r" in the console where you ran "flutter run",
          // or simply save your changes to "hot reload" in a Flutter IDE).
          // Notice that the counter didn't reset back to zero; the application
          // is not restarted.
          primarySwatch: Colors.blue,
        ),
        home: HomePage(),
      ),
    );
  }
}

abstract class Categories {
  static String ladiesOuterwear = 'ladies_outerwear';
  static String mensOuterwar = 'mens_outerwear';

  static String ladiesTshirt = 'ladies_tshirt';
  static String mensTshirt = 'mens_tshirt';
}

class CategoryData extends StatelessWidget {
  final String name;
  final List<Clothe> clothes;

  CategoryData(this.name, this.clothes);

  @override
  Widget build(BuildContext context) {
    final int count = clothes.length;

    final clothesList = clothes.map((c) {
      return Container(
        width: 200,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              c.image,
              height: 200,
            ),
            Text(
              '${c.title}',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            Text(
              '\$${c.price}',
              style: TextStyle(color: Colors.grey[600]),
            )
          ],
        ),
      );
    }).toList();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.menu,
            color: Colors.black,
          ),
          onPressed: () {},
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add_shopping_cart),
            color: Colors.black,
            onPressed: () => print('add_shopping_cart'),
          )
        ],
        title: Text(
          'S H O P',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: ListView(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(top: 20, bottom: 10),
            child: Center(
              child: Text(
                '$name',
                style: TextStyle(fontSize: 17),
              ),
            ),
          ),
          Container(
            child: Center(
              child: Text(
                '($count items)',
                style: TextStyle(fontSize: 17, color: Colors.grey),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: 20, bottom: 20),
            child: Center(
              child: Wrap(
                spacing: 9.0,
                runSpacing: 20.0,
                children: clothesList,
              ),
            ),
          )
        ],
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.menu,
            color: Colors.black,
          ),
          onPressed: () => print('menu'),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add_shopping_cart),
            color: Colors.black,
            onPressed: () => print('add_shopping_cart'),
          )
        ],
        title: Text(
          'S H O P',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Container(
        child: ListView(
          children: <Widget>[
            StoreConnector<AppState, ShopCategories>(
              converter: (store) => store.state.categories,
              builder: (context, categories) {
                return Outerwear(
                  path: 'images/mens_outerwear.jpg',
                  title: 'Men\'s Outerwear',
                  onPress: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CategoryData(
                              'Men\'s Outerwear',
                              categories.mensOuterwear,
                            ),
                      ),
                    );
                  },
                );
              },
            ),
            StoreConnector<AppState, ShopCategories>(
              converter: (store) => store.state.categories,
              builder: (context, categories) {
                return Outerwear(
                  path: 'images/ladies_outerwear.jpg',
                  title: 'Ladies Outerwear',
                  onPress: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CategoryData(
                              'Ladies Outerwear',
                              categories.ladiesOuterwear,
                            ),
                      ),
                    );
                  },
                );
              },
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: StoreConnector<AppState, ShopCategories>(
                    converter: (store) => store.state.categories,
                    builder: (context, categories) => Tshirt(
                          path: 'images/mens_tshirts.jpg',
                          title: 'Men\'s T-Shirts',
                          onPress: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CategoryData(
                                      'Men\'s T-Shirts',
                                      categories.mensTshirts,
                                    ),
                              ),
                            );
                          },
                        ),
                  ),
                ),
                Expanded(
                  child: StoreConnector<AppState, ShopCategories>(
                    converter: (store) => store.state.categories,
                    builder: (context, categories) => Tshirt(
                          path: 'images/ladies_tshirts.jpg',
                          title: 'Ladies T-Shirts',
                          onPress: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CategoryData(
                                      'Ladies T-Shirts',
                                      categories.ladiesTshirts,
                                    ),
                              ),
                            );
                          },
                        ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class Tshirt extends StatelessWidget {
  final String path;
  final String title;
  final Function onPress;

  Tshirt({this.path, this.title, this.onPress});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Image.asset(
          path,
          height: 240,
          fit: BoxFit.fitHeight,
        ),
        Container(
          padding: EdgeInsets.only(top: 24, bottom: 24),
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 17),
          ),
        ),
        Container(
          alignment: Alignment.center,
          padding: EdgeInsets.only(bottom: 24),
          child: ShopNowButton(onPress),
        ),
      ],
    );
  }
}

class Outerwear extends StatelessWidget {
  final String path;
  final String title;
  final Function onPress;

  Outerwear({this.path, this.title, this.onPress});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Image.asset(
          path,
          height: 240,
          fit: BoxFit.fitHeight,
        ),
        Container(
          padding: EdgeInsets.only(top: 24, bottom: 24),
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 17),
          ),
        ),
        Container(
          alignment: Alignment.center,
          padding: EdgeInsets.only(bottom: 24),
          child: ShopNowButton(onPress),
        ),
      ],
    );
  }
}

class ShopNowButton extends StatelessWidget {
  final Function onPress;

  ShopNowButton(this.onPress);

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Ink(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black, width: 2),
        ),
        child: InkWell(
          splashColor: Colors.transparent,
          onTap: () => onPress(),
          child: Padding(
            padding: EdgeInsets.fromLTRB(20, 8, 20, 8),
            child: Text(
              'SHOP NOW',
              style: TextStyle(fontSize: 15),
            ),
          ),
        ),
      ),
    );
  }
}
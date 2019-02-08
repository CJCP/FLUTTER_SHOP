import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_redux/flutter_redux.dart';

import 'package:redux/redux.dart';

import 'ui/cart_flutter.dart';
import 'redux/middleware.dart';
import 'redux/actions.dart';
import 'redux/models.dart';
import 'redux/reducer.dart';
import 'redux/store.dart';

Future<List<Clothe>> loadJSON(String path) async {
  var data = await rootBundle.loadString(path);
  var decodedJSON = jsonDecode(data);
  return decodedJSON.map<Clothe>((clothe) => Clothe.fromJSON(clothe)).toList();
}

void main() async {
  List<Clothe> ladiesOuterwear = await loadJSON('data/ladies_outerwear.json');
  List<Clothe> ladiesTshirts = await loadJSON('data/ladies_tshirts.json');
  List<Clothe> mensOuterwear = await loadJSON('data/mens_outerwear.json');
  List<Clothe> mensTshirts = await loadJSON('data/mens_tshirts.json');

  final store = Store<AppState>(
    appReducer,
    middleware: [ShopMiddleware()],
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

class ClotheDetails extends StatefulWidget {
  final Clothe clothe;

  ClotheDetails(this.clothe);

  @override
  ClotheDetailsState createState() {
    return new ClotheDetailsState();
  }
}

class ClotheDetailsState extends State<ClotheDetails> {
  String _size = 'M';
  int _quantity = 1;

  void _updateSize(String size) {
    setState(() {
      _size = size;
    });
  }

  void _updateQuantity(int quantity) {
    setState(() {
      _quantity = quantity;
    });
  }

  @override
  Widget build(BuildContext context) {
    final sizes = ['XS', 'S', 'M', 'L', 'XL'];
    final quantities = [1, 2, 3, 4, 5];
    final features = widget.clothe.features
        .map((f) => Text(
              '- $f',
              style: TextStyle(
                color: Color.fromRGBO(117, 117, 117, 1),
              ),
            ))
        .toList();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(
          color: Colors.black, //change your color here
        ),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add_shopping_cart),
            color: Colors.black,
            onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CartContainer(),
                  ),
                ),
          )
        ],
        title: Text(
          'S H O P',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Container(
        margin: EdgeInsets.only(left: 30, right: 30),
        child: ListView(
          children: <Widget>[
            Container(
              height: 10,
            ),
            Container(
              alignment: Alignment.center,
              child: Hero(
                tag: widget.clothe.image,
                child: Image.asset(
                  widget.clothe.image,
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(top: 10, bottom: 10),
                  child: Text(
                    '${widget.clothe.title}',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 10, bottom: 10),
                  child: Text(
                    '\$${widget.clothe.price}',
                    style: TextStyle(
                      fontSize: 15,
                      color: Color.fromRGBO(117, 117, 117, 1),
                    ),
                  ),
                ),
                Divider(
                  indent: 1,
                  color: Colors.grey[900],
                ),
                Row(
                  children: <Widget>[
                    Container(
                      child: Text(
                        'Size',
                        style: TextStyle(
                          color: Color.fromRGBO(117, 117, 117, 1),
                        ),
                      ),
                      width: 80,
                    ),
                    Expanded(
                      child: DropdownButton(
                          items: sizes.map((v) {
                            return DropdownMenuItem(
                              child: Text(v),
                              value: v,
                            );
                          }).toList(),
                          isExpanded: true,
                          onChanged: (e) {
                            _updateSize(e);
                          },
                          value: _size),
                    )
                  ],
                ),
                Row(
                  children: <Widget>[
                    Container(
                      child: Text(
                        'Quantity',
                        style: TextStyle(
                          color: Color.fromRGBO(117, 117, 117, 1),
                        ),
                      ),
                      width: 80,
                    ),
                    Expanded(
                      child: DropdownButton(
                          items: quantities.map((v) {
                            return DropdownMenuItem(
                              child: Text(v.toString()),
                              value: v,
                            );
                          }).toList(),
                          isExpanded: true,
                          onChanged: (e) {
                            _updateQuantity(e);
                          },
                          value: _quantity),
                    )
                  ],
                ),
                ViewState(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(bottom: 10, top: 20),
                        child: Text(
                          'Description : ',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Text(
                        '${widget.clothe.description}',
                        style: TextStyle(
                          color: Color.fromRGBO(117, 117, 117, 1),
                        ),
                      ),
                    ],
                  ),
                  data: widget.clothe.description,
                ),
                ViewState(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(top: 15, bottom: 15),
                        child: Text(
                          'Features : ',
                          style: TextStyle(
                            color: Color.fromRGBO(117, 117, 117, 1),
                          ),
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: features,
                      ),
                    ],
                  ),
                  data: widget.clothe.features,
                ),
                Container(
                  height: 50,
                )
              ],
            )
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Container(
          height: 50,
          decoration: BoxDecoration(
            color: Color.fromRGBO(23, 44, 80, 1),
          ),
          child: Center(child: addToShop(widget.clothe, _size, _quantity)),
        ),
      ),
    );
  }

  Widget addToShop(Clothe clothe, String size, num quantity) {
    return StoreConnector<AppState, AddItemActionFunction>(
      converter: (store) => (item) => store.dispatch(AddItemAction(item)),
      builder: (context, callback) => InkWell(
            splashColor: Colors.transparent,
            onTap: () {
              callback(CartItem(
                  clothe.title, size, quantity, clothe.price, clothe.image));
            },
            child: Text(
              'ADD TO CART',
              style: TextStyle(color: Colors.white, fontSize: 15),
            ),
          ),
    );
  }
}

typedef AddItemActionFunction = Function(CartItem);

class ViewState extends StatelessWidget {
  final Widget child;
  final dynamic data;

  ViewState({this.child, this.data});

  @override
  Widget build(BuildContext context) {
    if (data.length == 0) {
      return Container();
    }
    return child;
  }
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
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ClotheDetails(c),
                  ),
                );
              },
              child: Hero(
                tag: c.image,
                child: Image.asset(
                  c.image,
                  height: 200,
                ),
              ),
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
            onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CartContainer(),
                  ),
                ),
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
          ),
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
            onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CartContainer(),
                  ),
                ),
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

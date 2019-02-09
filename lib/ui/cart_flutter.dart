import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:shop/redux/actions.dart';
import 'package:shop/redux/models.dart';
import 'package:shop/redux/store.dart';
import 'package:shop/ui/cart_badge.dart';
import 'package:shop/ui/drawer.dart';

class CartContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: SDrawer(),
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        centerTitle: true,
        actions: <Widget>[
          CartBadge(
            closeRouting: true,
          )
        ],
        title: Text(
          'S H O P',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Container(
          margin: EdgeInsets.only(left: 30, right: 30), child: viewCart()),
      bottomNavigationBar: BottomAppBar(
        child: Container(
          height: 50,
          decoration: BoxDecoration(
            color: Color.fromRGBO(23, 44, 80, 1),
          ),
          child: Center(
            child: Text('CHECKOUT', style: TextStyle(color: Colors.white)),
          ),
        ),
      ),
    );
  }

  Widget viewCart() {
    return StoreConnector<AppState, num>(
      converter: (store) => store.state.cartItems.length,
      builder: (context, count) => count > 0
          ? ListView(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(top: 20, bottom: 10),
                  child: Center(
                    child: Text(
                      'Your Cart',
                      style: TextStyle(fontSize: 17),
                    ),
                  ),
                ),
                countItems(),
                CartList(),
                Container(
                  child: cartTotal(),
                ),
                Container(
                  height: 50,
                )
              ],
            )
          : Container(
              padding: EdgeInsets.only(top: 50),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Your ',
                    style: TextStyle(fontSize: 17),
                  ),
                  Icon(Icons.shopping_cart),
                  Text(
                    ' is empty.',
                    style: TextStyle(fontSize: 17),
                  )
                ],
              ),
            ),
    );
  }

  Widget countItems() {
    return StoreConnector<AppState, num>(
      converter: (store) => store.state.cartItems.length,
      builder: (context, count) {
        String item = count > 1 ? 'items' : 'item';
        return Container(
          margin: EdgeInsets.only(bottom: 20),
          child: Center(
            child: Text(
              '($count $item)',
              style: TextStyle(
                fontSize: 17,
                color: Colors.grey,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget cartTotal() {
    return StoreConnector<AppState, num>(
      converter: (store) => store.state.cartItems
          .fold<num>(0, (acc, item) => acc + (item.price * item.quantity)),
      builder: (context, total) => Container(
            margin: EdgeInsets.only(right: 5, top: 30),
            child: Container(
              child: Row(
                children: <Widget>[
                  Text(
                    'Total : ',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 30),
                    child: Text(
                      '\$${total.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
                mainAxisAlignment: MainAxisAlignment.end,
              ),
            ),
          ),
    );
  }
}

class CartList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, List<CartItem>>(
      converter: (store) => store.state.cartItems,
      builder: (context, items) {
        List<CartItem> newList = List.from(items);
        newList.sort((a, b) {
          String l1 = (a.label + a.size).toLowerCase();
          String l2 = (b.label + b.size).toLowerCase();

          return l1.compareTo(l2);
        });
        final cartList = newList.map((item) {
          return Item(item);
        }).toList();
        return Container(
            margin: EdgeInsets.only(top: 10),
            child: Column(
              children: cartList,
            ));
      },
    );
  }
}

class Item extends StatelessWidget {
  final CartItem item;

  Item(this.item);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      child: IntrinsicHeight(
        child: Row(
          children: <Widget>[
            Image.asset(
              item.image,
              height: 72,
              width: 72,
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(left: 10),
                          child: Text(item.label),
                        ),
                        removeItem(item),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Text('Qty: '),
                          updateQuantitiesIcon(item, Icons.expand_less, 1),
                          Container(
                            alignment: Alignment.center,
                            width: 30,
                            child: Text(
                              item.quantity.toString(),
                            ),
                          ),
                          item.quantity <= 1
                              ? Icon(
                                  Icons.expand_more,
                                  color: Colors.grey[400],
                                  size: 30,
                                )
                              : updateQuantitiesIcon(
                                  item, Icons.expand_more, -1),
                          Container(
                            width: 60,
                            margin: EdgeInsets.only(
                              left: 10,
                              right: 10,
                            ),
                            child: Text('Size : ${item.size}'),
                          ),
                          Container(
                            width: 50,
                            child: Text('\$${item.price}'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget updateQuantitiesIcon(CartItem item, IconData icon, num quantity) {
    return StoreConnector<AppState, UpdateQuantitiesFunction>(
      converter: (store) => (item, quantity) => store.dispatch(
            UpdateQuantitiesAction(
              item,
              quantity,
            ),
          ),
      builder: (context, callback) => InkWell(
            splashColor: Colors.transparent,
            onTap: () {
              callback(
                item,
                quantity,
              );
            },
            child: Icon(
              icon,
              size: 30,
            ),
          ),
    );
  }

  Widget removeItem(CartItem item) {
    return StoreConnector<AppState, RemoveItemFunction>(
      converter: (store) =>
          (label, size) => store.dispatch(RemoveItemAction(label, size)),
      builder: (context, callback) => InkWell(
            child: Icon(Icons.close),
            onTap: () {
              callback(item.label, item.size);
            },
          ),
    );
  }
}

typedef UpdateQuantitiesFunction = Function(CartItem, num);
typedef RemoveItemFunction = Function(String, String);

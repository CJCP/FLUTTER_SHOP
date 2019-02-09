import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:shop/redux/store.dart';
import 'package:shop/ui/cart_flutter.dart';

class CartBadge extends StatelessWidget {
  final bool closeRouting;

  CartBadge({this.closeRouting = false});

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, int>(
      converter: (store) =>
          store.state.cartItems.fold(0, (acc, elem) => acc + elem.quantity),
      builder: (context, count) => count > 0
          ? InkWell(
              onTap: () => _navigate(context),
              child: Stack(
                alignment: Alignment(0, 0),
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(left: 12, right: 12),
                    child: Icon(
                      Icons.shopping_cart,
                      color: Colors.black,
                    ),
                  ),
                  Positioned(
                    top: 2,
                    right: 2,
                    child: Container(
                      height: 23,
                      width: 23,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color.fromRGBO(23, 44, 80, 1),
                      ),
                      child: Center(
                        child: Text(
                          count.toString(),
                          style: TextStyle(
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            )
          : IconButton(
              icon: Icon(Icons.shopping_cart),
              color: Colors.black,
              onPressed: () => _navigate(context)
            ),
    );
  }

  void _navigate(context) {
    if (closeRouting) return;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return CartContainer();
        },
      ),
    );
  }
}

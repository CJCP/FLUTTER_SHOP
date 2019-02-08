import 'store.dart';
import 'actions.dart';
import 'models.dart';
import 'package:redux/redux.dart';

class ShopMiddleware implements MiddlewareClass<AppState> {
  @override
  void call(Store<AppState> store, dynamic action, NextDispatcher next) {
    if (action is AddItemAction) {
      CartItem item = findItem(store.state.cartItems, action);
      if (item != null) {
        return store.dispatch(
          UpdateQuantitiesAction(
            action.item,
            item.quantity,
          ),
        );
      }
    } else if (action is ReduceQuantitiesAction) {
      if (!enoughStock(store.state.cartItems, action)) {
        return store.dispatch(
          RemoveItemAction(
            action.item.label,
            action.item.size,
          ),
        );
      }
    }
    next(action);
  }

  CartItem findItem(List<CartItem> shop, AddItemAction action) {
    return shop.firstWhere((item) => item.label == action.item.label && item.size == action.item.size, orElse: () => null);
  }

  bool enoughStock(List<CartItem> shop, ReduceQuantitiesAction action) {
    CartItem item = shop.firstWhere((item) => item.label == action.item.label);
    return item.quantity - action.quantity > 0;
  }
}
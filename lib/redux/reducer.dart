import 'models.dart';
import 'actions.dart';
import 'store.dart';
import 'package:redux/redux.dart';

final cartReducer = combineReducers<List<CartItem>>([
  TypedReducer<List<CartItem>, AddItemAction>(_addItem),
  TypedReducer<List<CartItem>, UpdateQuantitiesAction>(_updateQuantitiesAction),
  TypedReducer<List<CartItem>, RemoveItemAction>(_removeItem),
  TypedReducer<List<CartItem>, ReduceQuantitiesAction>(_reduceQuantitiesAction)
]);

List<CartItem> _addItem (List<CartItem> cartItems, AddItemAction action) {
  return List.from(cartItems)..add(action.item);
}

List<CartItem> _updateQuantitiesAction(List<CartItem> cartItems, UpdateQuantitiesAction action) {
  CartItem newItem = CartItem(action.item.label, action.item.size,  action.item.quantity + action.quantity, action.item.price, action.item.image);

  return List.from(cartItems.where((item) { 
    if (item.label != action.item.label) {
      return true;
    } else if (item.size != action.item.size) {
      return true;
    }
    return false;
  }))..add(newItem);
}

List<CartItem> _removeItem (List<CartItem> cartItems, RemoveItemAction action) {
  List<CartItem> newList = cartItems.where((item) {
    if (item.label != action.label) {
      return true;
    } else if (item.size != action.size) {
      return true;
    }
    return false;
  }).toList();
  return List.from(newList);
}

List<CartItem> _reduceQuantitiesAction(List<CartItem> cartItems, ReduceQuantitiesAction action ) {
  CartItem item = CartItem(action.item.label, action.item.size, action.item.quantity - action.quantity, action.item.price, action.item.image);
  List<CartItem> newList = cartItems.where((item) => item.label != action.item.label && item.size != action.item.size);

  return newList..add(item);
}

AppState appReducer(AppState state, dynamic action) {
  return AppState(
    state.categories,
    cartReducer(state.cartItems, action)
  );
}
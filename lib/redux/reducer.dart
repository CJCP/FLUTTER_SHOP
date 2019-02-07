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
  CartItem newItem = CartItem(action.item.label, action.item.size,  action.item.quantity + action.quantity, action.item.price);

  return List.from(cartItems.where((item) => item.label != action.item.label && item.size != item.size))..add(newItem);
}

List<CartItem> _removeItem (List<CartItem> cartItems, RemoveItemAction action) {
  List<CartItem> newList = cartItems.where((item) => item.label != action.label && item.size != action.size);

  return List.from(newList);
}

List<CartItem> _reduceQuantitiesAction(List<CartItem> cartItems, ReduceQuantitiesAction action ) {
  CartItem item = CartItem(action.item.label, action.item.size, action.item.quantity - action.quantity, action.item.price);
  List<CartItem> newList = cartItems.where((item) => item.label != action.item.label && item.size != action.item.size);
  return newList..add(item);
}

AppState appReducer(AppState state, dynamic action) {
  var test = AppState(
    state.categories,
    cartReducer(state.cartItems, action)
  );

  return test;
}
import 'models.dart';

class AppState {
  final ShopCategories categories;
  List<CartItem> cartItems;

  AppState(this.categories, this.cartItems);

  factory AppState.initial(ShopCategories categories) {
    return AppState(
      categories,
      List.unmodifiable([])
    );
  }
}
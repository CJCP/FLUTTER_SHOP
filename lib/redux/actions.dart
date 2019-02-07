import 'models.dart';

class AddItemAction {
  final CartItem item;

  AddItemAction(this.item);
}

class RemoveItemAction {
  final String label;
  final String size;

  RemoveItemAction(this.label, this.size);
}

class UpdateQuantitiesAction {
  final CartItem item;
  final num quantity;

  UpdateQuantitiesAction(this.item, this.quantity);
}

class ReduceQuantitiesAction {
  final CartItem item;
  final num quantity;

  ReduceQuantitiesAction(this.item, {this.quantity = 1});
}
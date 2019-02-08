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

class CartItem {
  final String label;
  final String size;
  final String image;
  final int quantity;
  final num price;

  CartItem(this.label, this.size, this.quantity, this.price, this.image);
}

class Clothe {
  final String name;
  final String title;
  final String category;
  final List<String> features;
  final String description;
  final String image;
  final String largeImage;

  final num price;

  Clothe(this.name, this.title, this.category, this.description, this.image,
      this.largeImage, this.price, this.features);

  Clothe.fromJSON(Map<String, dynamic> json)
      : name = json['name'],
        title = json['title'],
        category = json['category'],
        description = json['computedDescription'],
        image = json['image'],
        features = List<String>.from(json['features']),
        largeImage = json['largeImage'],
        price = json['price'];
}

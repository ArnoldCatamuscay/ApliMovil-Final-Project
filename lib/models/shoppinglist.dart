import 'package:myapp/models/product.dart';

class ShoppingList {
  
  ShoppingList({
    this.key,
    this.name,
    this.date,
    this.products,
  });

  String? key;
  String? name;
  String? date;
  List<Product>? products;

  // Método para crear una lista de productos desde un mapa
  static List<Product> productListFromMap(Map<dynamic, dynamic> map) {
    List<Product> products = [];
    map.forEach((key, value) {
      products.add(Product.fromMap(value));
    });
    return products;
  }
  
}
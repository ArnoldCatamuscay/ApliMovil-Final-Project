class Product {
  
  Product({
    this.title,
    this.place,
    this.key,
  });

  String? title;
  String? place;
  String? key;

  // Método para crear un Product desde un mapa
  factory Product.fromMap(Map<dynamic, dynamic> map) {
    return Product(
      title: map['title'],
      place: map['place'],
      key: map['key'],
    );
  }
}
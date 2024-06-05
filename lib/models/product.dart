class Product {
  
  Product({
    this.title,
    this.place,
    this.isChecked = false,
    this.key,
  });

  String? title;
  String? place;
  bool isChecked;
  String? key;

  // Método para crear un Product desde un mapa
  factory Product.fromMap(Map<dynamic, dynamic> map) {
    return Product(
      title: map['title'],
      place: map['place'],
      isChecked: map['isChecked'] ?? false,
      key: map['key'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'place': place,
      'isChecked': isChecked,
      'key': key,
    };
  }
}
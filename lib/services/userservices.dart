import 'package:firebase_database/firebase_database.dart';
import 'package:myapp/models/product.dart';

class UserServices {
  Future<List<Product>> getProductos() async {
    List<Product> products = [
      Product(title: 'Producto 1', place: 'D1'),
      Product(title: 'Producto 2', place: 'Olimpica'),
      Product(title: 'Producto 3', place: 'Ara'),
    ];

    return products;
  }

  Future<bool> saveNotas(String titulo) async {
    try{
      await FirebaseDatabase.instance
        .reference()
        .child('notas')
        .push()
        .set({
          'title': titulo,
        });
      return true;
    } catch(e) {
      print(e);
      return false;
    }
  }
  
}
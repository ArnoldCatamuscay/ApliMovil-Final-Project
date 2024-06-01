// ignore_for_file: deprecated_member_use

import 'package:firebase_database/firebase_database.dart';
import 'package:myapp/models/product.dart';

class ProductServices {
  Future<List<Product>> getProducts() async {

    List<Product> products = [];

    try{
      DatabaseReference ref = FirebaseDatabase.instance.reference().child('products');
      DatabaseEvent event = await ref.once();
      DataSnapshot snap = event.snapshot;
      
      if (snap.value != null && snap.value is Map) {
        for (var child in snap.children) {
          Map<dynamic, dynamic> map = child.value as Map<dynamic, dynamic>;
          Product newProduct = Product(
            key: child.key!,
            title: map['title'],
            place: map['place'],
          );
          products.add(newProduct);
        }
      } 
      return products;
    } catch (e){
      return products;
    }
  }

  Future<bool> saveProduct(String title, String place) async {
    try{
      await FirebaseDatabase.instance
        .reference()
        .child('products')
        .child(title)
        .set({
          'title': title,
          'place': place,
        });
      return true;
    } catch(e) {
      //print(e);
      return false;
    }
  }
  
}
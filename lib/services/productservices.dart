// ignore_for_file: deprecated_member_use

import 'package:firebase_database/firebase_database.dart';
import 'package:myapp/models/product.dart';

class ProductServices {
  Future<List<Product>> getProducts(String listKey) async {

    List<Product> products = [];

    try{
      DatabaseReference ref = FirebaseDatabase.instance
        .reference()
        .child("list_item");
      DatabaseEvent event = await ref.once();
      DataSnapshot snap = event.snapshot;
      
      if (snap.value != null && snap.value is Map) {
        for (var child in snap.children) {
          Map<dynamic, dynamic> map = child.value as Map<dynamic, dynamic>;
          Product newProduct = Product(
            key: child.key!,
            title: map['title'],
            place: map['place'],
            isChecked: map['isChecked'] ?? false,
            list: map['list'],
          );
          if(newProduct.list == listKey) {
            products.add(newProduct);
          }
          
        }
      } 
      return products;
    } catch (e){
      return products;
    }
  }

  Future<bool> saveProduct(String listKey, String title, String place, {bool isChecked = false}) async {
    try{
      await FirebaseDatabase.instance
        .reference()
        .child("list_item")
        .push()
        .set({
          'title': title,
          'place': place,
          'isChecked': isChecked,
          'list': listKey,
        });
      return true;
    } catch(e) {
      return false;
    }
  }

  Future<bool> updateProduct(String productKey, String newTitle, String newPlace) async {
    try {
      await FirebaseDatabase.instance
        .reference()
        .child("list_item")
        .child(productKey)
        .update({
          'title': newTitle,
          'place': newPlace,
        });
      return true;
    } catch(e) {
      return false;
    }
  }

  Future<bool> updateProductCheckStatus(String productKey, bool isChecked) async {
    try {
      await FirebaseDatabase.instance
        .reference()
        .child("list_item")
        .child(productKey)
        .update({
          'isChecked': isChecked,
        });
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> deleteProduct(String productKey) async {
    try {
      await FirebaseDatabase.instance
        .reference()
        .child("list_item")
        .child(productKey)
        .remove();
      return true;
    } catch (e) {
      return false;
    }
  }
  
}
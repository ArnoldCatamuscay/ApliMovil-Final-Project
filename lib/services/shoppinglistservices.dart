// ignore_for_file: deprecated_member_use

import 'package:firebase_database/firebase_database.dart';
import 'package:myapp/models/product.dart';
import 'package:myapp/models/shoppinglist.dart';

class ShoppingListServices {

  Future<List<ShoppingList>> getShoppingLists() async {
    List<ShoppingList> shoppingLists = [];
    try{
      DatabaseReference ref = FirebaseDatabase.instance
        .reference()
        .child('shoppingLists');
      DatabaseEvent event = await ref.once();
      DataSnapshot snap = event.snapshot;
      
      if (snap.value != null && snap.value is Map) {
        for (var child in snap.children) {
          Map<dynamic, dynamic> map = child.value as Map<dynamic, dynamic>;
          // Verificar si hay productos y convertirlos a una lista de Product
          List<Product>? products;
          if (map['products'] != null && map['products'] is Map) {
            products = ShoppingList.productListFromMap(map['products']);
          }
          ShoppingList newShoppingList = ShoppingList(
            key: child.key!,
            name: map['name'],
            date: map['date'],
            products: products,
          );
          shoppingLists.add(newShoppingList);
        }
      } 
      return shoppingLists;
    } catch (e){
      return shoppingLists;
    }
  }

  Future<bool> saveShoppingList(String name, String date) async {
    try{
      await FirebaseDatabase.instance
        .reference()
        .child('shoppingLists')
        .child(name)
        .set({
          'name': name,
          'date': date,
          // 'products': {
          //   'Detergente': {
          //     'title': 'Detergente',
          //     'place': 'D1'
          //   }
          // },
        });
      return true;
    } catch(e) {
      // print("EL ERROR ES: $e");
      return false;
    }
  }
  
}
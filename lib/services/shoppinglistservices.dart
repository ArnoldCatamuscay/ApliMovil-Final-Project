// ignore_for_file: deprecated_member_use

import 'package:firebase_database/firebase_database.dart';
import 'package:myapp/models/shoppinglist.dart';

class ShoppingListServices {

  Future<List<ShoppingList>> getShoppingLists() async {
    List<ShoppingList> shoppingLists = [];
    try{
      DatabaseReference ref = FirebaseDatabase.instance
        .reference()
        .child('shopping_list');
      DatabaseEvent event = await ref.once();
      DataSnapshot snap = event.snapshot;
      
      if (snap.value != null && snap.value is Map) {
        for (var child in snap.children) {
          Map<dynamic, dynamic> map = child.value as Map<dynamic, dynamic>;
          ShoppingList newShoppingList = ShoppingList(
            key: child.key!,
            name: map['name'],
            createdAt: map['createdAt'],
          );
          shoppingLists.add(newShoppingList);
        }
      } 
      return shoppingLists;
    } catch (e){
      return shoppingLists;
    }
  }

  Future<bool> saveShoppingList(String name, String createdAt, String? listKey) async {
    try {
      final Map<String, dynamic> data = {
        'name': name,
        'createdAt': createdAt,
      };

      await FirebaseDatabase.instance
        .reference()
        .child('shopping_list')
        .push() // .child(name)
        .set(data);

      return true;
    } catch (e) {
      return false;
    }
  }

  Future<ShoppingList> getLatestShoppingList() async {
    ShoppingList latestList = ShoppingList();
    DateTime? latestDate;

    try {
      DatabaseReference ref = FirebaseDatabase.instance
        .reference()
        .child('shopping_list');
      DatabaseEvent event = await ref.once();
      DataSnapshot snap = event.snapshot;

      if (snap.value != null && snap.value is Map) {
        for (var child in snap.children) {
          Map<dynamic, dynamic> map = child.value as Map<dynamic, dynamic>;

          // Crear la lista de compras actual
          ShoppingList currentShoppingList = ShoppingList(
            key: child.key!,
            name: map['name'],
            createdAt: map['createdAt'],
          );

          // Convertir la fecha a DateTime
          DateTime currentDate = DateTime.parse(map['createdAt']);

          // Verificar si es la fecha más reciente
          if (latestDate == null || currentDate.isAfter(latestDate)) {
            latestDate = currentDate;
            latestList = currentShoppingList;
          }
        }
      }
      return latestList;
    } catch (e) {
      // Manejar el error según sea necesario
      throw Exception("Error fetching latest shopping list: $e");
    }
  }

}
import 'package:flutter/material.dart';
import 'package:myapp/models/place.dart';
import 'package:myapp/models/product.dart';
import 'package:myapp/models/shoppinglist.dart';
import 'package:myapp/services/placeservices.dart';
import 'package:myapp/services/productservices.dart';
import 'package:myapp/services/shoppinglistservices.dart';
import 'package:intl/intl.dart';

class Appstate with ChangeNotifier {
  
  List<ShoppingList> _shoppingLists = [];
  List<Product> _products = [];
  List<Place> _places = [];
  
  //* Products
  Future<bool> saveProduct(String listKey, String productName, String placeName) async {
    try {
      bool response = await ProductServices().saveProduct(listKey, productName, placeName);
      if(response) {
        notifyListeners();
      }
      return response;
    } catch (e) {
      return false;
    }
  }

  Future<List<Product>> getProducts(String listKey) async {
    try{
      _products = await ProductServices().getProducts(listKey);
      
      return _products;
    } catch (e){
      return _products;
    }
  }

  Future<bool> updateProduct(String productKey, String newTitle, String newPlace) async {
    try {
      
      bool response = await ProductServices().updateProduct(/*listKey, */productKey, newTitle, newPlace);
      if(response) {
        notifyListeners();
      }
      return response;
    } catch (e) {
      return false;
    }
  }

  Future<bool> updateProductCheckStatus(String productKey, bool isChecked) async {
    try {
      bool response = await ProductServices().updateProductCheckStatus(productKey, isChecked);
      if (response) {
        _products.firstWhere((product) => product.key == productKey).isChecked = isChecked;
        notifyListeners();
      }
      return response;
    } catch (e) {
      return false;
    }
  }

  Future<bool> deleteProduct(String productKey) async {
    try {
      bool response = await ProductServices().deleteProduct(productKey);
      if(response) {
        notifyListeners();
      }
      return response;
    } catch (e) {
      return false;
    }
  }
  
  //* Places
  Future<bool> savePlace(String placeName) async {
    try {
      bool response = await PlaceServices().savePlace(placeName);
      if(response) {
        notifyListeners();
      }
      return response;
    } catch (e) {
      return false;
    }
  }

  Future<List<Place>> getPlaces() async {
    try{
      _places = await PlaceServices().getPlaces();
      
      return _places;
    } catch (e){
      return _places;
    }
  }

  //* ShoppingLists
  Future<List<ShoppingList>> getShoppingLists() async {
    try{
      _shoppingLists = await ShoppingListServices().getShoppingLists();
      
      return _shoppingLists;
    } catch(e) {
      return _shoppingLists;
    }
  }

  Future<bool> saveShoppingList(String name, String? listKey) async {
    try {
      // Obtener la fecha y hora actual
      DateTime now = DateTime.now();
      // Formatear la fecha y hora actual como "yyyy-MM-dd HH:mm:ss"
      String formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
      bool response = await ShoppingListServices().saveShoppingList(name, formattedDate, listKey);
      if(response) {
        if(listKey!=null) {
          var latestList = await ShoppingListServices().getLatestShoppingList();
          var products = await ProductServices().getProducts(listKey);
          if(products.isNotEmpty) {
            for (Product product in products) {
              await ProductServices().saveProduct(latestList.key!, product.title!, product.place!);
            }
          }
        }
        notifyListeners();
      }
      return response;
    } catch (e) {
      return false;
    }
  }

  Future<ShoppingList> getLatestShoppingList() async {
    return await ShoppingListServices().getLatestShoppingList();
  }

}
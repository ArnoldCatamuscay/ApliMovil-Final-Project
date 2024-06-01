import 'package:flutter/material.dart';
import 'package:myapp/models/product.dart';
import 'package:myapp/services/userservices.dart';

class Appstate with ChangeNotifier {
  
  List<Product> _products = [];
  
  Future<bool> saveProducts(String productName, String placeName) async {
    try {
      bool response = await UserServices().saveProduct(productName, placeName);
      if(response) {
        notifyListeners();
      }
      return response;
    } catch (e) {
      return false;
    }
  }

  Future<List<Product>> getProducts() async {
    try{
      _products = await UserServices().getProductos();
      
      return _products;
    } catch (e){
      return _products;
    }
  }

}
import 'package:flutter/material.dart';
import 'package:myapp/models/place.dart';
import 'package:myapp/models/product.dart';
import 'package:myapp/services/placeservices.dart';
import 'package:myapp/services/productservices.dart';

class Appstate with ChangeNotifier {
  
  List<Product> _products = [];
  List<Place> _places = [];
  
  //* Products
  Future<bool> saveProduct(String productName, String placeName) async {
    try {
      bool response = await ProductServices().saveProduct(productName, placeName);
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
      _products = await ProductServices().getProducts();
      
      return _products;
    } catch (e){
      return _products;
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

}
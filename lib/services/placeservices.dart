// ignore_for_file: deprecated_member_use

import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';
import 'package:myapp/models/place.dart';

class PlaceServices {
  Future<List<Place>> getPlaces() async {

    List<Place> places = [];

    try{
      DatabaseReference ref = FirebaseDatabase.instance.reference().child('places');
      DatabaseEvent event = await ref.once();
      DataSnapshot snap = event.snapshot;
      
      if (snap.value != null && snap.value is Map) {
        for (var child in snap.children) {
          Map<dynamic, dynamic> map = child.value as Map<dynamic, dynamic>;
          Place newPlace = Place(
            key: child.key!,
            name: map['name'],
            createdAt: map['createdAt'],
          );
          places.add(newPlace);
        }
      } 
      return places;
    } catch (e){
      return places;
    }
  }

  Future<bool> savePlace(String placeName) async {
    try{
      // Obtener la fecha y hora actual
      DateTime now = DateTime.now();
      // Formatear la fecha y hora actual como "yyyy-MM-dd HH:mm"
      String createdAt = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
      await FirebaseDatabase.instance
        .reference()
        .child('places')
        .child(placeName)
        .set({
          'name': placeName,
          'createdAt': createdAt,
        });
      return true;
    } catch(e) {
      return false;
    }
  }
  
}
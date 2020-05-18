import 'package:flutter/foundation.dart';
import 'dart:io';


import '../models/place.dart';
import '../helpers/db_helper.dart';
import '../helpers/location_helper.dart';

class GreatPlaces with ChangeNotifier {
  List<Place> _items = [];

  List<Place> get items {
    return [..._items];
  }

  Place findById ( String id ) {
    return _items.firstWhere((place) => place.id == id);
  }

  Future<void> addPlace(
      String pickedTitle, 
      File pickedImage, 
      PlaceLocation pickedLocation
    ) async {
    final address = await LocationHelper.getPlaceAddress(
      pickedLocation.latitude, 
      pickedLocation.longitude
    );
    final updatedLocation = PlaceLocation(
      latitude: pickedLocation.latitude,
      longitude: pickedLocation.longitude,
      address: address
    );
    final newPlace = Place(
      id: DateTime.now().toString(),
      image: pickedImage,
      title: pickedTitle,
      location: updatedLocation
    );

    _items.add(newPlace);
    notifyListeners();
    DBHelper.insert('user_places', {
      'id': newPlace.id,
      'title': newPlace.title,
      'imagePath': newPlace.image.path,
      'locationLatitude': newPlace.location.latitude,
      'locationLongitude': newPlace.location.longitude,
      'address': newPlace.location.address
    });
  }  // end of addPlace


  Future<void> fetchAndSetPlaces () async {
    final dataList = await DBHelper.getData('user_places');

    print('greatePlaces provider -> fetchAndSetPlaces -> datalist length in BackEnd ->'  );
    print(dataList.length);

    _items = dataList.map( (item) => Place(
        id: item['id'],
        title: item['title'],
        image: File(item['imagePath']),
        location: PlaceLocation(
          latitude: item['locationLatitude'],
          longitude: item['locationLongitude'],
          address: item['address']
        )

      )

    ).toList();

    notifyListeners();
  }
}
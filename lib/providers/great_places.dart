import 'package:flutter/foundation.dart';
import 'dart:io';


import '../models/place.dart';
import '../helpers/db_helper.dart';

class GreatPlaces with ChangeNotifier {
  List<Place> _items = [];

  List<Place> get items {
    return [..._items];
  }

  void addPlace(String pickedTitle, File pickedImage) {
    final newPlace = Place(
      id: DateTime.now().toString(),
      image: pickedImage,
      title: pickedTitle,
      location: null
    );

    _items.add(newPlace);
    notifyListeners();
    DBHelper.insert('user_places', {
      'id': newPlace.id,
      'title': newPlace.title,
      'imagePath': newPlace.image.path
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
        location: null

      )

    ).toList();

    notifyListeners();
  }
}
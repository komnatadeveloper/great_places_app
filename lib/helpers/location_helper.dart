import '../environment_variables.dart';
import 'dart:convert' as dartConvert;
import 'package:http/http.dart' as http;

class LocationHelper {
  static generateLocationPreviewImage( {
      double latitude,
      double longitude
    } ) {
    
    return 'https://maps.googleapis.com/maps/api/staticmap?center=&$latitude,$longitude&=16&size=600x300&maptype=roadmap&markers=color:red%7Clabel:C%7C$latitude,$longitude&key=$GOOGLE_API_KEY';


  }


  static Future<String> getPlaceAddress (double lat, double lon) async {
    final url = 'https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$lon&key=$GOOGLE_API_KEY';
    final res = await http.get(url);
    return dartConvert.json.decode(
      res.body
    )['results'][0]['formatted_address'];
  }


}
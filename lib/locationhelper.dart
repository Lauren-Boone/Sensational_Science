@JS('navigator.geolocation')
library location; 
import 'dart:html';
import 'package:js/js.dart';
import 'dart:js'; 
import 'package:universal_html/js.dart';

@JS('getCurrentPosition')
external void getCurrentPosition(Function success(Geolocation position)); 

@JS()
@anonymous
class GeolocationPos{
  external factory GeolocationPos({GeolocationCoordinates geolocationCoordinates}); 

  external GeolocationCoordinates get coords; 
}

@JS()
@anonymous
class GeolocationCoordinates{
  external factory GeolocationCoordinates({
    double latitude,
    double longitudem 
  }); 

  external double get latitude; 
  external double get longitude; 
}

@JS()
// if(html.window.navigator.geolocation != null){

// }

@JS('navigator.geolocation')
library location; 

import 'package:js/js.dart';

@JS('getCurrentPosition')
external void getCurrentPosition(Function success(GeolocationPosition position)); 

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
@anonymous
class GeolocationPosition{
  external factory GeolocationPosition({GeolocationCoordinates geolocationCoordinates}); 

  external GeolocationCoordinates get coords; 
}



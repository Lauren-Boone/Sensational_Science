
F allowInterop<F extends Function>(F f){
  return f; 
}

void getCurrentPosition(Function success(GeolocationPosition position)){
  print("WRONG PLACE");
}

class GeolocationPosition{
  external factory GeolocationPosition({GeolocationCoordinates geolocationCoordinates}); 

  external GeolocationCoordinates get coords; 
}

class GeolocationCoordinates{
  external factory GeolocationCoordinates({
    double latitude,
    double longitudem 
  }); 

  external double get latitude; 
  external double get longitude; 
}
import 'package:latlong/latlong.dart';

class ScanModel {

    int id;
    String type;
    String value;

    ScanModel({
        this.id,
        this.type,
        this.value,
    }){
      if ( this.value.contains('http') || this.value.contains('www') ) {
        this.type = 'http';
      }
       else if( this.value.contains('geo' )){
        this.type = 'geo';
      }
      if ( !this.value.contains('http://') && !this.value.contains('http://') && !this.value.contains('geo:') ) {
        this.value = 'http://' + this.value;
      }
    }

    factory ScanModel.fromJson(Map<String, dynamic> json) => new ScanModel(
        id   : json["id"],
        type : json["type"],
        value: json["value"],
    );

    Map<String, dynamic> toJson() => {
        "id"   : id,
        "type" : type,
        "value": value,
    };

    LatLng getLatLng() {

      // geo:40.724233047051705,-74.00731459101564
      final lalo = value.substring(4).split(',');
      final lat  = double.parse( lalo[0] );
      final lng  = double.parse( lalo[1] );

      return LatLng( lat, lng );

    }

}

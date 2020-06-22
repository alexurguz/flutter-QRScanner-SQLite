import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';

import 'package:qr_scanner_sqlite/src/models/scanner/scanner_model.dart';


class MapaPage extends StatefulWidget {

  @override
  _MapaPageState createState() => _MapaPageState();
}

class _MapaPageState extends State<MapaPage> {
  final map = new MapController();

  String mapType = 'streets';

  @override
  Widget build(BuildContext context) {

    final ScanModel scan = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      appBar: AppBar(
        title: Text('QR coordinates'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.my_location),
            onPressed: (){
              map.move(scan.getLatLng(), 15);
            },
          )
        ],
      ),
      body: _createFlutterMap(scan),
      floatingActionButton: _createFloatButton( context ),
    );
  }

  Widget _createFloatButton(BuildContext context ) {

    return FloatingActionButton(
      child: Icon( Icons.repeat ),
      backgroundColor: Theme.of(context).primaryColor,
      onPressed: () {
        // streets, dark, light, outdoors, satellite
      setState((){
        if ( mapType == 'streets' ) {
          mapType = 'dark';
        } else if ( mapType == 'dark' ) {
          mapType = 'light';
        } else if ( mapType == 'light' ) {
          mapType = 'outdoors';
        } else if ( mapType == 'outdoors' ) {
          mapType = 'satellite';
        } else {
          mapType = 'streets';
        }
        });
      },
    );

  }

  Widget _createFlutterMap( ScanModel scan ) {

    return FlutterMap(
      mapController: map,
      options: MapOptions(
        center: scan.getLatLng(),
        zoom: 15
      ),
      layers: [
        _createMap(),
        _createMarkers( scan )
      ],
    );

  }

  _createMap() {

    return TileLayerOptions(
      urlTemplate: 'https://api.mapbox.com/v4/'
      '{id}/{z}/{x}/{y}@2x.png?access_token={accessToken}',
      additionalOptions: {
        'accessToken': 'pk.eyJ1Ijoia2xlcml0aCIsImEiOiJjanY2MjF4NGIwMG9nM3lvMnN3ZDM1dWE5In0.0SfmUpbW6UFj7ZnRdRyNAw',
        'id': 'mapbox.$mapType' 
        // streets, dark, light, outdoors, satellite
      }
    );
  }

  _createMarkers( ScanModel scan ) {

    return MarkerLayerOptions(
      markers: <Marker>[
        Marker(
          width: 100.0,
          height: 100.0,
          point: scan.getLatLng(),
          builder: ( context ) => Container(
            child: Icon(
              Icons.location_on, 
              size: 70.0,
              color: Theme.of(context).primaryColor,
              ),
          )
        )
      ]
    );

  }
}

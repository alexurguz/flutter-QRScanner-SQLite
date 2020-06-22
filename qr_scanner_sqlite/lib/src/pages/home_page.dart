import 'dart:io';
import 'package:flutter/material.dart';
import 'package:qr_scanner_sqlite/src/bloc/scans_bloc.dart';
import 'package:qr_scanner_sqlite/src/models/scanner/scanner_model.dart';
import 'package:qr_scanner_sqlite/src/pages/address_page.dart';
import 'package:qr_scanner_sqlite/src/pages/maps_page.dart';
import 'package:qr_scanner_sqlite/src/utilities/utils.dart' as utils;
import 'package:barcode_scan/barcode_scan.dart';


class HomePage extends StatefulWidget {

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final scansBloc = new ScansBloc();

  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('QR Scanner'),
        actions: <Widget>[
          IconButton(
            icon: Icon( Icons.delete_forever ),
            onPressed: scansBloc.deleteScanTODOS,
          )
        ],
      ),
      body: _callPage(currentIndex),
      bottomNavigationBar: _createButtonNavigationBar(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        child: Icon( Icons.filter_center_focus ),
        onPressed: ()=> _scanQR( context ),
        backgroundColor: Theme.of(context).primaryColor,
      ),
    );
  }

  _scanQR(BuildContext context) async {

    // https://fernando-herrera.com
    // geo:40.724233047051705,-74.00731459101564

    String futureString;

    try {
      futureString = await BarcodeScanner.scan();
    } catch(e) {
      futureString = e.toString();
    }

    if ( futureString != null ) {

      final scan = ScanModel( value: futureString );
      scansBloc.agregarScan(scan);
      currentIndex = 1;
      if ( Platform.isIOS ) {
        Future.delayed( Duration( milliseconds: 750 ), () {
          utils.openScan(context, scan);
        });
      } else {
        utils.openScan(context, scan);
      }
    }
  }

  Widget _callPage( int paginaActual ) {

    switch( paginaActual ) {

      case 0: return MapasPage();
      case 1: return DireccionesPage();

      default:
        return MapasPage();
    }

  }

  Widget _createButtonNavigationBar() {

    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: (index) {
        setState(() {
          currentIndex = index; 
        });
      },
      items: [
        BottomNavigationBarItem(
          icon: Icon( Icons.map ),
          title: Text('Maps')
        ),
        BottomNavigationBarItem(
          icon: Icon( Icons.brightness_5 ),
          title: Text('Address')
        ),
      ],
    );


  }
}
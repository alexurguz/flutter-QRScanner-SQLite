import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:qr_scanner_sqlite/src/models/scanner/scanner_model.dart';


openScan(BuildContext context, ScanModel scan ) async {
  print('Utils::openScan::type:::'+ scan.type);
  print('Utils::openScan::value:::'+ scan.value);
  if ( scan.type == 'http' || scan.type == 'https' || scan.type == 'www') {
    if (await canLaunch( scan.value )) {
      await launch(scan.value);
    } else {
      throw 'Could not launch ${ scan.value }';
    }
  } else {
    Navigator.pushNamed(context, 'map', arguments: scan);
  }

}


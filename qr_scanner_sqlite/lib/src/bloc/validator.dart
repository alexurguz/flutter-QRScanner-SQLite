
import 'dart:async';

import 'package:qr_scanner_sqlite/src/models/scanner/scanner_model.dart';


class Validators {

  final validarGeo = StreamTransformer<List<ScanModel>, List<ScanModel>>.fromHandlers(
    handleData: ( scans, sink ) {

      final geoScans = scans.where( (s) => s.type == 'geo' ).toList();
      sink.add(geoScans);
    }
  );

  final validarHttp = StreamTransformer<List<ScanModel>, List<ScanModel>>.fromHandlers(
    handleData: ( scans, sink ) {

      final geoScans = scans.where( (s) => (s.type == 'http' || s.type == 'https' || s.type == 'www') ).toList();
      sink.add(geoScans);
    }
  );



}

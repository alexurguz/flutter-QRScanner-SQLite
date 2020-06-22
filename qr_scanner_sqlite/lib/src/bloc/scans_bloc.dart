import 'dart:async';

import 'package:qr_scanner_sqlite/src/bloc/validator.dart';
import 'package:qr_scanner_sqlite/src/providers/db_provider.dart';
import 'package:qr_scanner_sqlite/src/models/scanner/scanner_model.dart';

class ScansBloc with Validators {

  static final ScansBloc _singleton = new ScansBloc._internal();

  factory ScansBloc() {
    return _singleton;
  }

  ScansBloc._internal() {
    obtenerScans();
  }

  final _scansController = StreamController<List<ScanModel>>.broadcast();

  Stream<List<ScanModel>> get scansStream     => _scansController.stream.transform(validarGeo);
  Stream<List<ScanModel>> get scansStreamHttp => _scansController.stream.transform(validarHttp);


  dispose() {
    _scansController?.close();
  }

  obtenerScans() async {
    _scansController.sink.add( await DBProvider.db.getAllScanners() );
  }

  agregarScan( ScanModel scan ) async{
    print('create::bloc::value::'+ scan.value);
    print('create::bloc::type::'+ scan.type);
    await DBProvider.db.newScan(scan);
    obtenerScans();
  }

  deleteScan( int id ) async {
    await DBProvider.db.deleteScan(id);
    obtenerScans();
  }

  deleteScanTODOS() async {

    await DBProvider.db.deleteAll();
    obtenerScans();
  }


}
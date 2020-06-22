import 'dart:io';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

import 'package:qr_scanner_sqlite/src/models/scanner/scanner_model.dart';

class DBProvider {

  static Database _database;
  static final DBProvider db = DBProvider._();

  DBProvider._();

  Future<Database> get database async {

    if ( _database != null ) return _database;

    _database = await initDB();
    return _database;
  }

  initDB() async {

    Directory documentsDirectory = await getApplicationDocumentsDirectory();

    final path = join( documentsDirectory.path, 'APP_SCANNER_DB.db' );

    return await openDatabase(
      path,
      version: 1,
      onOpen: (db) {},
      onCreate: ( Database db, int version ) async {
        await db.execute(
          'CREATE TABLE SCANNER ('
          ' id INTEGER PRIMARY KEY,'
          ' type TEXT,'
          ' value TEXT'
          ')'
        );
      }
    );

  }

  // INSERT - Create rows
  newScanRaw( ScanModel newScan ) async {

    final db  = await database;

    final res = await db.rawInsert(
      "INSERT Into SCANNER (id, type, value) "
      "VALUES ( ${ newScan.id }, '${ newScan.type }', '${ newScan.value }' )"
    );
    return res;

  }

  newScan( ScanModel newScan ) async {

    final db  = await database;
    final res = await db.insert('SCANNER',  newScan.toJson() );
    return res;
  }

  // SELECT - Get information
  Future<ScanModel> getScanId( int id ) async {

    final db  = await database;
    final res = await db.query('SCANNER', where: 'id = ?', whereArgs: [id]  );
    return res.isNotEmpty ? ScanModel.fromJson( res.first ) : null;

  }

  Future<List<ScanModel>> getAllScanners() async {

    final db  = await database;
    final res = await db.query('SCANNER');

    List<ScanModel> list = res.isNotEmpty
                              ? res.map( (c) => ScanModel.fromJson(c) ).toList()
                              : [];
    return list;
  }

  Future<List<ScanModel>> getScannerByType( String type ) async {

    final db  = await database;
    final res = await db.rawQuery("SELECT * FROM SCANNER WHERE type='$type'");

    List<ScanModel> list = res.isNotEmpty
                              ? res.map( (c) => ScanModel.fromJson(c) ).toList()
                              : [];
    return list;
  }

  // UPDATE - Modify rows
  Future<int> updateScan( ScanModel newScan ) async {

    final db  = await database;
    final res = await db.update('SCANNER', newScan.toJson(), where: 'id = ?', whereArgs: [newScan.id] );
    return res;

  }

  // DELETE - Remove rows
  Future<int> deleteScan( int id ) async {

    final db  = await database;
    final res = await db.delete('SCANNER', where: 'id = ?', whereArgs: [id]);
    return res;
  }

  Future<int> deleteAll() async {

    final db  = await database;
    final res = await db.rawDelete('DELETE FROM SCANNER');
    return res;
  }
}


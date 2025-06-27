import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import 'dart:io';

class DatabaseHelper {
  static final _databaseName = "hinos.db";
  static final table = 'hino';
  static final columnId = 'id';
  static final columnNome = 'titulo';

  // torna esta classe singleton
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();
  // tem somente uma referência ao banco de dados
  static Database? _database;

  Future<Database> get database async =>
      _database ??= await openDatabaseFromAssets();

  Future<Database> openDatabaseFromAssets() async {
    // Get the temporary directory (cache)
    final directory = await getTemporaryDirectory();
    final path = join(directory.path, _databaseName);

    // Check if the database file exists
    final exists = await File(path).exists();

    if (!kReleaseMode || !exists) {
      // Copy from assets
      ByteData data = await rootBundle.load('assets/db/$_databaseName');
      List<int> bytes =
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

      // Write and flush the bytes written
      await File(path).writeAsBytes(bytes, flush: true);
    }

    // Open the database
    return await openDatabase(path);
  }

  Future<List<Map<String, dynamic>>> queryAllRows() async {
    Database db = await instance.database;
    return await db.query(table);
  }

  Future<List<Map<String, dynamic>>> searchById(String id) async {
    Database db = await instance.database;
 
    return await db.rawQuery('SELECT Id, Titulo FROM Hino where Id=?', [id]);
  }

  Future<List<Map<String, dynamic>>> searchByText(String valor) async {
    Database db = await instance.database;
    return await db.rawQuery(
        "select Hino.Id, Verso.IdHino, Hino.Titulo, Verso.Coro, Verso.Ordem, Verso.Texto from Hino inner join Verso on Verso.IdHino = Hino.Id and Verso.Estrofe = 1 and Verso.Ordem = 1 where Hino.Titulo LIKE ? ORDER BY Verso.Estrofe, Verso.Ordem LIMIT 12",
        ['%$valor%']);
  }

  Future<List<Map<String, dynamic>>> getVersos(String id) async {
    Database db = await instance.database;
    return await db.rawQuery(
        'select Verso.IdHino, Hino.Titulo, Verso.Coro, Verso.Ordem, Verso.Texto from Hino inner join Verso on Verso.IdHino = Hino.Id where Hino.Id=? ORDER BY Verso.Estrofe, Verso.Ordem LIMIT 12',
        [id]);
  }
}

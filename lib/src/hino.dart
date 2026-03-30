import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'dart:io';

class DatabaseHelper {
  static final _databaseName = "hinos.db";

  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;
  Future<Database> get database async =>
      _database ??= await openDatabaseFromAssets();

  Future<Database> openDatabaseFromAssets() async {
    final dbDir = await getDatabasesPath();
    final dbPath = join(dbDir, _databaseName);

    // Verifica versão do app
    final prefs = await SharedPreferences.getInstance();
    final savedVersion = prefs.getString('dbVersion');
    final appVersion = (await PackageInfo.fromPlatform()).version;

    final dbExists = await File(dbPath).exists();

    // Copia se:
    // 1. o banco ainda não existe
    // 2. ou a versão mudou (substitui pelo novo db do assets)
    if (!dbExists || savedVersion != appVersion) {
      ByteData data = await rootBundle.load('assets/db/$_databaseName');
      List<int> bytes = data.buffer.asUint8List();

      await File(dbPath).writeAsBytes(bytes, flush: true);

      // Salva a versão no SharedPreferences
      await prefs.setString('dbVersion', appVersion);
    }

    return await openDatabase(dbPath);
  }

  Future<List<Map<String, dynamic>>> searchById(String id) async {
    Database db = await instance.database;
    return await db.rawQuery(
        'select Hino.Id, Hino.Titulo, (select Texto from Verso where IdHino = Hino.Id ORDER BY Verso.Estrofe, Verso.Ordem LIMIT 1) as Texto from Hino where Hino.Id LIKE ? and Hino.Categoria != ? and length(Hino.Id) = length(?) + 1 ORDER BY Hino.Ordem LIMIT 4',
        ['%$id', 'N', id]);
  }

  Future<List<Map<String, dynamic>>> searchByText(String valor) async {
    Database db = await instance.database;
    return await db.rawQuery(
        "select Hino.Id, Verso.IdHino, Hino.Titulo, Verso.Coro, Verso.Ordem, Verso.Texto from Hino inner join Verso on Verso.IdHino = Hino.Id and Verso.Estrofe = 1 and Verso.Ordem = 1 where Hino.Id = ? or Hino.Titulo LIKE ? or Verso.Texto LIKE ? ORDER BY Verso.Estrofe, Verso.Ordem LIMIT 12",
        [valor, '%$valor%', '%$valor%']);
  }

  Future<List<Map<String, dynamic>>> searchByCategoria(String valor) async {
    Database db = await instance.database;
    return await db.rawQuery(
        "select Hino.Id, Verso.IdHino, Hino.Titulo, Verso.Coro, Verso.Ordem, Verso.Texto from Hino inner join Verso on Verso.IdHino = Hino.Id and Verso.Estrofe = 1 and Verso.Ordem = 1 where Hino.Categoria = ? ORDER BY Hino.Ordem",
        [valor]);
  }

  Future<List<Map<String, dynamic>>> getVersos(String id) async {
    Database db = await instance.database;
    return await db.rawQuery(
        'select Verso.IdHino, Hino.Titulo, Verso.Coro, Verso.Ordem, Verso.Texto, Verso.Estrofe from Hino inner join Verso on Verso.IdHino = Hino.Id where Hino.Id = ? ORDER BY Verso.Estrofe, Verso.Ordem',
        [id]);
  }
}

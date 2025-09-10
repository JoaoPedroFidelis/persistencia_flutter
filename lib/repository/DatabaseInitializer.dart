import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:io' show Platform;
import 'package:sqflite_common_ffi/sqflite_ffi.dart' show sqfliteFfiInit, databaseFactoryFfi;
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart' show databaseFactoryFfiWeb;

import '../domain/Pessoa.dart';

class DatabaseInitializer {
  DatabaseInitializer._internal();
  static final DatabaseInitializer instance = DatabaseInitializer._internal();
  static const String _dbName = 'meu_banco.db';

  Database? _db;
  final List<String> tables = [];

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDB();
    return _db!;
  }

  Future<Database> _initDB() async {
    // Função chamada na criação do banco
    Future<void> _onCreate(Database db, int version) async {
      tables.add(Pessoa.createSql);
      for (var sql in tables) {
        await db.execute(sql);
      }
    }

    if (kIsWeb) {
      // Web: IndexedDB
      return await databaseFactoryFfiWeb.openDatabase(
        _dbName,
        options: OpenDatabaseOptions(version: 1, onCreate: _onCreate),
      );
    } else if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
      // Desktop: sqflite ffi
      sqfliteFfiInit();
      return await databaseFactoryFfi.openDatabase(
        p.join(await getDatabasesPath(), _dbName),
        options: OpenDatabaseOptions(version: 1, onCreate: _onCreate),
      );
    } else {
      // Mobile: Android/iOS
      final dbPath = p.join(await getDatabasesPath(), _dbName);
      return await openDatabase(dbPath, version: 1, onCreate: _onCreate);
    }
  }
}

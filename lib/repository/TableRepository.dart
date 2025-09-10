import 'package:exemplo/domain/DbTable.dart';
import 'package:sqflite/sqflite.dart';

abstract class TableRepository<T extends DbTable> {
  final String table;

  TableRepository(this.table);

  Database? _db;

  Future<Database> get database async {
    if (_db == null) throw Exception("Database não inicializado");
    return _db!;
  }

  set database(Database db) {
    _db = db;
  }

  Future<int> insert(T obj) async {
    final db = await database;
    return db.insert(table, obj.toMap(), conflictAlgorithm: ConflictAlgorithm.abort);
  }

  Future<int> update(T obj) async {
    if (obj.id == null) return 0;
    final db = await database;
    return db.update(table, obj.toMap(), where: 'id = ?', whereArgs: [obj.id]);
  }

  Future<int> delete(int id) async {
    final db = await database;
    return db.delete(table, where: 'id = ?', whereArgs: [id]);
  }

  Future<T?> getById(int id, T Function(Map<String, dynamic>) fromMap) async {
    final db = await database;
    final result = await db.query(table, where: 'id = ?', whereArgs: [id], limit: 1);
    if (result.isEmpty) return null;
    return fromMap(result.first);
  }

  dynamic convert(Map<String, dynamic> map){
    return null;
  }

  Future<List<T>> getAll() async {
    final db = await database;
    final maps = await db.query(table, orderBy: 'id DESC');
    final List<T> list = [];

    for (var i = 0; i < maps.length; i++) {
      list.add(convert(maps[i]));
    }
    return list;
  }
}

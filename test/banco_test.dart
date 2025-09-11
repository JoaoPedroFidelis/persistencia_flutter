import 'package:flutter_test/flutter_test.dart';
import 'package:exemplo/repository/DatabaseInitializer.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  test('Conexão com banco está sendo executada corretamente', () async {
    final db = await DatabaseInitializer.instance.database;
    expect(DatabaseInitializer.instance.running, true);
    expect(db.isOpen, true);
  });
}

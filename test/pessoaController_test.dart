import 'package:flutter_test/flutter_test.dart';
import 'package:exemplo/repository/DatabaseInitializer.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:exemplo/controller/PessoaController.dart';
import 'package:exemplo/domain/Pessoa.dart';

void main() {
  late PessoaController pessoaController;

  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  test('Controller de pessoa salva e recupera registros', () async {
    final db = await DatabaseInitializer.instance.database;
    pessoaController = PessoaController();
    pessoaController.load(db);

    await pessoaController.save('carlos', 20);

    final List<Pessoa> pessoas = await pessoaController.futurePessoas!;
    expect(pessoas, isNotNull);
    expect(pessoas, isA<List<Pessoa>>());

    final existeCarlos = pessoas.any((p) => p.nome == 'carlos' && p.idade == 20);
    expect(pessoas.length > 0, true);
    expect(existeCarlos, true);
  });
}

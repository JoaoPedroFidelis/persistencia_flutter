import 'package:flutter_test/flutter_test.dart';
import 'package:exemplo/repository/DatabaseInitializer.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:exemplo/repository/PessoaRepository.dart';
import 'package:exemplo/domain/Pessoa.dart';

void main() {
  late PessoaRepository pessoaRepository;

  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  test('Repository de pessoa esta seguindo processos padrão de banco', () async {
    final db = await DatabaseInitializer.instance.database;
    pessoaRepository = PessoaRepository();
    pessoaRepository.database = db;

    try {
      await pessoaRepository.insert(Pessoa(id: 1, nome: 'Jordan', idade: 23));
    } catch (e) {
      await pessoaRepository.update(Pessoa(id: 1, nome: 'Jordan', idade: 23));
    }

    final Pessoa? pessoa = await pessoaRepository.getById(1, Pessoa.fromMap);
    expect(pessoa, isNotNull);
    expect(pessoa?.nome, 'Jordan');
    expect(pessoa?.idade, 23);
  });
}

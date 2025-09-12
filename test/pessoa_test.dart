import 'package:flutter_test/flutter_test.dart';
import 'package:exemplo/domain/pessoa.dart';

void main() {
  test('Criar pessoa deve definir nome e idade corretamente', () {
    final pessoa = Pessoa(nome: 'Ana', idade: 30);

    expect(pessoa.nome, 'Ana');
    expect(pessoa.idade, 30);
  });
}
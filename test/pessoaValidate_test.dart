import 'package:flutter_test/flutter_test.dart';
import 'package:exemplo/controller/PessoaController.dart';
import 'package:exemplo/domain/pessoa.dart';

void main() {
  PessoaController pessoaController = PessoaController();
  test('Controller de pessoa valida corretamente campos', () {
    final p1 = Pessoa(nome: 'Carlos', idade: 20);
    expect(pessoaController.validateNome(p1.nome), null);
    expect(pessoaController.validateIdade(p1.idade.toString()), null);

    final p2 = Pessoa(nome: 'João123', idade: 1000);
    expect(pessoaController.validateNome(p2.nome), 'Nome não pode ter números');
    expect(pessoaController.validateIdade(p2.idade.toString()), 'Idade inválida');
  });
}
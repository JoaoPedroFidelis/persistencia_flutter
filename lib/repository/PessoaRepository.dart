import 'package:exemplo/domain/Pessoa.dart';
import 'package:exemplo/repository/TableRepository.dart';

class PessoaRepository extends TableRepository<Pessoa> {
  @override String table = Pessoa.table; // tabela pessoas

  @override Pessoa convert(Map<String, dynamic> map){ // converte um mapa em uma estancia valida de Pessoa
    return Pessoa.fromMap(map);
  }
}

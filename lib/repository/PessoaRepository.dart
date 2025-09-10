import 'package:exemplo/domain/Pessoa.dart';
import 'package:exemplo/repository/TableRepository.dart';

class PessoaRepository extends TableRepository<Pessoa> {
  @override final String table = Pessoa.table;
  PessoaRepository() : super(Pessoa.table);

  @override Pessoa convert(Map<String, dynamic> map){
    return Pessoa.fromMap(map);
  }
}

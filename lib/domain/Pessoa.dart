import 'package:exemplo/domain/DbTable.dart';

class Pessoa extends DbTable {
  // VARIAVEIS DE INICIAÇÃO
  static const String table = 'pessoas'; // nome da tabela no banco
  static const String createSql = '''
    CREATE TABLE $table(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      nome TEXT NOT NULL,
      idade INTEGER NOT NULL
    )
  '''; // comando SQL para criar a tabela
  
  // ATRIBUTOS
  final String nome;
  final int idade;

  // FUNÇÕES / CONSTRUTOR
  const Pessoa({
    int? id,
    required this.nome,
    required this.idade,
  }) : super(id: id);

  @override
  Pessoa copyWith({int? id, String? nome, int? idade}) {
    return Pessoa(
      id: id ?? this.id,
      nome: nome ?? this.nome,
      idade: idade ?? this.idade,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    final map = super.toMap();
    map.addAll({
      'nome': nome,
      'idade': idade,
    });
    return map;
  }

  factory Pessoa.fromMap(Map<String, dynamic> map) {
    return Pessoa(
      id: map['id'] as int?,
      nome: map['nome'] as String,
      idade: map['idade'] as int,
    );
  }

  @override
  String toString() => 'Pessoa(id: $id, nome: $nome, idade: $idade)';
}

class DbTable {
  // VARIAVEIS DE INICIAÇÃO
  static const String table = ''; // nome da tabela no banco
  static const String createSql = ''; // comando SQL para criar a tabela

  // ATRIBUTOS
  final int? id; // id que toda tabela automaticamente deve ter

  // FUNÇÕES / CONSTRUTOR
  const DbTable({this.id});

  DbTable copyWith({int? id}) { // cria uma cópia alterando valores específicos
    return DbTable(id: id ?? this.id);
  }

  Map<String, dynamic> toMap() { // converte o objeto em mapa
    final map = <String, dynamic>{};
    if (id != null) map['id'] = id;
    return map;
  }

  factory DbTable.fromMap(Map<String, dynamic> map) { // cria um objeto a partir de um mapa
    return DbTable(
      id: map['id'] as int?,
    );
  }

  @override
  String toString() => 'DbTable(id: $id)';
}

class DbTable {
  // VARIAVEIS DE INICIAÇÃO
  static const String table = '';
  static const String createSql = '';

  // ATRIBUTOS
  final int? id;

  // FUNÇÕES / CONSTRUTOR
  const DbTable({this.id});

  DbTable copyWith({int? id}) {
    return DbTable(id: id ?? this.id);
  }

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{};
    if (id != null) map['id'] = id;
    return map;
  }

  factory DbTable.fromMap(Map<String, dynamic> map) {
    return DbTable(
      id: map['id'] as int?,
    );
  }

  @override
  String toString() => 'DbTable(id: $id)';
}

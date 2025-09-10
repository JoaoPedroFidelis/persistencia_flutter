import 'package:flutter/material.dart';
import 'package:exemplo/domain/Pessoa.dart';
import 'package:exemplo/repository/PessoaRepository.dart';
import 'package:sqflite/sqlite_api.dart';

class PessoaController {
  final PessoaRepository pessoaRepository = PessoaRepository();

  Future<List<Pessoa>>? futurePessoas;
  int? editingId;
  bool isSaving = false;

  void load(Database db) async {
    pessoaRepository.database = db;
    refreshPessoas();
  }

  // CRUD
  void refreshPessoas() {
    futurePessoas = pessoaRepository.getAll();
  }

  Future<void> save(String nome, int idade) async {
    isSaving = true;
    nome = nome.trim().toLowerCase();

    Pessoa p = Pessoa(id: editingId, nome: nome, idade: idade);

    try {
      if (editingId == null) {
        await pessoaRepository.insert(p);
      } else {
        await pessoaRepository.update(p);
      }
      stopEditing();
      refreshPessoas();
    } finally {
      isSaving = false;
    }
  }

  Future<void> delete(int id) async {
    await pessoaRepository.delete(id);
    refreshPessoas();
  }

  void edit(Pessoa p, TextEditingController nomeCtrl, TextEditingController idadeCtrl) {
    editingId = p.id;
    nomeCtrl.text = p.nome;
    idadeCtrl.text = p.idade.toString();
  }

  // VALIDATES
  String? validateIdade(String ?v){
    if (v == null || v.trim().isEmpty) return 'Informe a idade';
    final n = int.tryParse(v.trim());
    if (n == null || n < 0 || n > 150) return 'Idade inválida';

    return null;
  }
  String? validateNome(String ?v){
    if (v == null || v.trim().isEmpty) return 'Informe o nome';
    if (v.trim().length < 2) return 'Nome muito curto';
    if (v.contains(RegExp(r'[0-9]'))) return 'Nome não pode ter números';

    return null;
  }

  // FUNÇÕES GERAIS
  bool isEditing(){
    return editingId != null;
  }
  void stopEditing() {
    editingId = null;
  }
}

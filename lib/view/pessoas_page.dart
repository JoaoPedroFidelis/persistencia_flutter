import 'package:flutter/material.dart';
import 'package:sqflite/sqlite_api.dart';

import 'package:exemplo/repository/DatabaseInitializer.dart';
import 'package:exemplo/controller/FormController.dart';
import 'package:exemplo/controller/PessoaController.dart';
import 'package:exemplo/domain/Pessoa.dart';

class PessoasPage extends StatefulWidget {
  const PessoasPage({super.key});

  @override
  State<PessoasPage> createState() => _PessoasPageState();
}

class _PessoasPageState extends State<PessoasPage> {
  final _formKey = GlobalKey<FormState>();
  final _nomeCtrl = TextEditingController();
  final _idadeCtrl = TextEditingController();
  List<TextEditingController> get inputListAction{
    return [_nomeCtrl, _idadeCtrl];
  }

  int _reloadTick = 0;
  bool _defaultLoad = false;

  late FormController formController;
  late PessoaController pessoaController;

  @override
  void dispose() {
    formController.dispose(inputListAction);
    super.dispose();
  }
  @override
  void initState() {
    super.initState();
    loadMain();
  }

  // CARREGAR BANCO DE DADOS
  Future<Database> loadDb() async {
    final db = await DatabaseInitializer.instance.database;
    return db;
  }

  // CARREGAMENTO INICIAL
  loadMain() async {
    final db = await loadDb();

    formController = FormController();
    pessoaController = PessoaController();

    dynamic controllers = [pessoaController];
    for (var i = 0; i < controllers.length; i++) {
      await controllers[i].load(db);
    }
    _defaultLoad = true;
    refreshAction();
  }

  // AÇÕES DO FRONT
  void clearFormAction() {
    pessoaController.stopEditing();
    _formKey.currentState?.reset();
    formController.clear(inputListAction);
  }
  void editAction(Pessoa p) {
    pessoaController.edit(p, _nomeCtrl, _idadeCtrl);
    setState(() => pessoaController.isEditing());
  }
  void refreshAction([String? act]) {
    if(act == null){
      pessoaController.refreshPessoas();
      setState(() { _reloadTick++; });
      return;
    }

    switch(act.toUpperCase()){
      case 'EDIT':
        setState(() => pessoaController.isEditing());
        break;
    }
  }

  // BUILD
  @override
  Widget build(BuildContext context) {
    if (!_defaultLoad) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pessoas (SQLite)'),
        actions: [
          IconButton(
            tooltip: 'Recarregar',
            onPressed: () async {
              refreshAction();
            },
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // ---------------------------
            // Formulário
            // ---------------------------
            Padding(
              padding: const EdgeInsets.all(12),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _nomeCtrl,
                      decoration: const InputDecoration(
                        labelText: 'Nome',
                        border: OutlineInputBorder(),
                      ),
                      textInputAction: TextInputAction.next,
                      validator: (v) { return pessoaController.validateNome(v); },
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _idadeCtrl,
                      decoration: const InputDecoration(
                        labelText: 'Idade',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (v) { return pessoaController.validateIdade(v); },
                      onFieldSubmitted: (_) {
                        if (!pessoaController.isSaving && _formKey.currentState!.validate()) {
                          pessoaController.save(formController.string(_nomeCtrl), formController.intParse(_idadeCtrl));
                        }
                      },
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: pessoaController.isSaving ? null : () {
                                    if (_formKey.currentState!.validate()) {
                                      pessoaController.save(formController.string(_nomeCtrl), formController.intParse(_idadeCtrl));
                                      pessoaController.isSaving = false;
                                      clearFormAction();
                                      refreshAction();
                                    }
                                  },
                            icon: pessoaController.isSaving
                                ? const SizedBox(
                                    width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2),
                                  ) : Icon(pessoaController.isEditing() ? Icons.save : Icons.add),
                            label: Text(pessoaController.isEditing() ? 'Salvar alterações' : 'Adicionar'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        if (pessoaController.isEditing())
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () {
                                pessoaController.editingId = null;
                                clearFormAction();
                                refreshAction("EDIT");
                              },
                              icon: const Icon(Icons.close),
                              label: const Text('Cancelar edição'),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const Divider(height: 1),
            // ---------------------------
            // Lista
            // ---------------------------
            Expanded(
              child: FutureBuilder<List<Pessoa>>(
                key: ValueKey(_reloadTick), // <- força rebuild quando _reloadTick muda    
                future: pessoaController.futurePessoas,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: Padding(
                      padding: EdgeInsets.all(24),
                      child: CircularProgressIndicator(),
                    ));
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text('Erro: ${snapshot.error}'));
                  }
                  final pessoas = snapshot.data ?? const <Pessoa>[];
                  if (pessoas.isEmpty) {
                    return const Center(child: Text('Nenhuma pessoa cadastrada.'));
                  }
                  return ListView.separated(
                    padding: const EdgeInsets.all(12),
                    itemCount: pessoas.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      final p = pessoas[index];
                      return Dismissible(
                        key: ValueKey(p.id ?? '${p.nome}-${p.idade}-$index'),
                        direction: DismissDirection.endToStart,
                        background: Container(
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          color: Colors.red,
                          child: const Icon(Icons.delete, color: Colors.white),
                        ),
                        confirmDismiss: (_) async {
                          return await showDialog<bool>(
                                context: context,
                                builder: (ctx) => AlertDialog(
                                  title: const Text('Remover registro'),
                                  content: Text('Deseja remover ${p.nome}?'),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(ctx, false),
                                      child: const Text('Cancelar'),
                                    ),
                                    TextButton(
                                      onPressed: () => Navigator.pop(ctx, true),
                                      child: const Text('Remover'),
                                    ),
                                  ],
                                ),
                              ) ??
                              false;
                        },
                        onDismissed: (_) => pessoaController.delete(p.id!),
                        child: ListTile(
                          tileColor: Colors.grey.withValues(alpha: 0.06),
                          title: Text('${p.nome} (${p.idade})'),
                          subtitle: Text('ID: ${p.id ?? '-'}'),
                          onTap: () {editAction(p);},
                          trailing: IconButton(
                            tooltip: 'Editar',
                            icon: const Icon(Icons.edit),
                            onPressed: () {editAction(p);},
                        ),
                      ));
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../database/bancoPessoa.dart';
import '../models/pessoa.dart';
import 'telaPessoa.dart';

class TelaHome extends StatefulWidget {
  const TelaHome({super.key});

  @override
  State<TelaHome> createState() => _TelaHomeState();
}

class _TelaHomeState extends State<TelaHome> {
  String _nomeUsuario = '';
  List<Pessoa> _pessoas = [];

  @override
  void initState() {
    super.initState();
    _carregar();
  }

  Future<void> _carregar() async {
    final prefs = await SharedPreferences.getInstance();
    final pessoas = await BancoPessoa.listarPessoas();
    setState(() {
      _nomeUsuario = prefs.getString('username') ?? '';
      _pessoas = pessoas;
    });
  }

  // Abre a tela de cadastro (pessoa == null) ou de edicao e recarrega a lista
  Future<void> _abrirTelaPessoa([Pessoa? pessoa]) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => TelaPessoa(pessoa: pessoa)),
    );
    _carregar();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Ola, $_nomeUsuario')),
      body: ListView.builder(
        itemCount: _pessoas.length,
        itemBuilder: (context, index) {
          final pessoa = _pessoas[index];
          return Dismissible(
            key: ValueKey(pessoa.id),
            onDismissed: (direction) async {
              await BancoPessoa.excluirPessoa(pessoa);
              setState(() {
                _pessoas.removeAt(index);
              });
              if (!context.mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('${pessoa.nome} excluido')),
              );
            },
            child: ListTile(
              title: Text(pessoa.nome),
              subtitle: Text(pessoa.telefone),
              onTap: () => _abrirTelaPessoa(pessoa),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _abrirTelaPessoa(),
        child: const Icon(Icons.add),
      ),
    );
  }
}

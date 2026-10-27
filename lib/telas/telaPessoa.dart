import 'package:flutter/material.dart';
import '../database/bancoPessoa.dart';
import '../models/pessoa.dart';

// Tela usada para cadastrar (pessoa == null) e para editar uma pessoa
class TelaPessoa extends StatefulWidget {
  final Pessoa? pessoa;

  const TelaPessoa({super.key, this.pessoa});

  @override
  State<TelaPessoa> createState() => _TelaPessoaState();
}

class _TelaPessoaState extends State<TelaPessoa> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nomeController;
  late final TextEditingController _emailController;
  late final TextEditingController _idadeController;
  late final TextEditingController _telefoneController;

  @override
  void initState() {
    super.initState();
    final p = widget.pessoa;
    _nomeController = TextEditingController(text: p?.nome ?? '');
    _emailController = TextEditingController(text: p?.email ?? '');
    _idadeController = TextEditingController(text: p?.idade.toString() ?? '');
    _telefoneController = TextEditingController(text: p?.telefone ?? '');
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _emailController.dispose();
    _idadeController.dispose();
    _telefoneController.dispose();
    super.dispose();
  }

  String? _obrigatorio(String? value) {
    return (value == null || value.isEmpty) ? 'Campo obrigatorio' : null;
  }

  Future<void> _salvar() async {
    if (!_formKey.currentState!.validate()) return;

    final pessoa = Pessoa(
      id: widget.pessoa?.id ?? 0,
      nome: _nomeController.text,
      email: _emailController.text,
      idade: int.parse(_idadeController.text),
      telefone: _telefoneController.text,
    );

    if (widget.pessoa == null) {
      await BancoPessoa.inserirPessoa(pessoa);
    } else {
      await BancoPessoa.atualizarPessoa(pessoa);
    }

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Pessoa salva com sucesso')),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.pessoa == null ? 'Nova pessoa' : 'Editar pessoa'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nomeController,
                decoration: const InputDecoration(labelText: 'Nome'),
                validator: _obrigatorio,
              ),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                validator: _obrigatorio,
              ),
              TextFormField(
                controller: _idadeController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Idade'),
                validator: (value) => int.tryParse(value ?? '') == null
                    ? 'Digite uma idade valida'
                    : null,
              ),
              TextFormField(
                controller: _telefoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(labelText: 'Telefone'),
                validator: _obrigatorio,
              ),
              const SizedBox(height: 16),
              ElevatedButton(onPressed: _salvar, child: const Text('Salvar')),
            ],
          ),
        ),
      ),
    );
  }
}

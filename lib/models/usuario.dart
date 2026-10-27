class Usuario {
  int id;
  String nome;
  String senha;

  Usuario({this.id = 0, required this.nome, required this.senha});

  Map<String, dynamic> toMap() {
    return {'id': id, 'nome': nome, 'senha': senha};
  }

  static Usuario fromMap(Map<String, dynamic> map) {
    return Usuario(
      id: map['id'] as int,
      nome: map['nome'] as String,
      senha: map['senha'] as String,
    );
  }
}

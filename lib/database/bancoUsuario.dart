import 'conexao.dart';
import '../models/usuario.dart';

class BancoUsuario {
  static Future<void> inserirUsuario(Usuario usuario) async {
    final db = await Conexao.abrirConexao();
    final dados = usuario.toMap()..remove('id');
    await db.insert('usuarios', dados);
  }

 
  static Future<Usuario?> login(String nome, String senha) async {
    final db = await Conexao.abrirConexao();
    final maps = await db.query(
      'usuarios',
      where: 'nome = ? AND senha = ?',
      whereArgs: [nome, senha],
    );
    if (maps.isEmpty) return null;
    return Usuario.fromMap(maps.first);
  }
}

import '../database/database.dart';
import '../models/projeto.dart';

class ProjetoRepository {
  final db = AppDatabase().db;

  int criar(Projeto projeto) {
    final stmt = db.prepare(
      'INSERT INTO projetos (nome, descricao) VALUES (?, ?)',
    );
    stmt.execute([projeto.nome, projeto.descricao]);
    stmt.dispose();

    final result = db.select('SELECT last_insert_rowid() AS id');
    return result.first['id'] as int;
  }

  List<Projeto> listarTodos() {
    final result = db.select('SELECT * FROM projetos');
    return result
        .map((row) => Projeto.fromMap({
              'id': row['id'],
              'nome': row['nome'],
              'descricao': row['descricao'],
            }))
        .toList();
  }

  Projeto? buscarPorId(int id) {
    final result = db.select('SELECT * FROM projetos WHERE id = ?', [id]);
    if (result.isEmpty) return null;

    final row = result.first;
    return Projeto.fromMap({
      'id': row['id'],
      'nome': row['nome'],
      'descricao': row['descricao'],
    });
  }

  bool atualizar(int id, Projeto projeto) {
    final stmt = db.prepare(
      'UPDATE projetos SET nome = ?, descricao = ? WHERE id = ?',
    );
    stmt.execute([projeto.nome, projeto.descricao, id]);
    stmt.dispose();

    final result = db.select('SELECT changes() AS count');
    return (result.first['count'] as int) > 0;
  }

  bool deletar(int id) {
    final stmt = db.prepare('DELETE FROM projetos WHERE id = ?');
    stmt.execute([id]);
    stmt.dispose();

    final result = db.select('SELECT changes() AS count');
    return (result.first['count'] as int) > 0;
  }
}
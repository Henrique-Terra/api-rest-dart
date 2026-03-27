import '../database/database.dart';
import '../models/tarefa.dart';

class TarefaRepository { 
  final db = AppDatabase().db;

  int criar(Tarefa tarefa) {
    final stmt = db.prepare('''
      INSERT INTO tarefas (titulo, descricao, concluida)
      VALUES (?, ?, ?)
    ''');

    stmt.execute([
      tarefa.titulo,
      tarefa.descricao,
      tarefa.concluida ? 1 : 0,
    ]);

    stmt.dispose();

    final result = db.select('SELECT last_insert_rowid() AS id');
    return result.first['id'] as int;
  }

  List<Tarefa> listarTodas() {
    final result = db.select('SELECT * FROM tarefas');
    return result
        .map((row) => Tarefa.fromMap({
              'id': row['id'],
              'titulo': row['titulo'],
              'descricao': row['descricao'],
              'concluida': row['concluida'],
            }))
        .toList();
  }

  Tarefa? buscarPorId(int id) {
    final result = db.select(
      'SELECT * FROM tarefas WHERE id = ?',
      [id],
    );

    if (result.isEmpty) return null;

    final row = result.first;
    return Tarefa.fromMap({
      'id': row['id'],
      'titulo': row['titulo'],
      'descricao': row['descricao'],
      'concluida': row['concluida'],
    });
  }

  bool atualizar(int id, Tarefa tarefa) {
    final stmt = db.prepare('''
      UPDATE tarefas
      SET titulo = ?, descricao = ?, concluida = ?
      WHERE id = ?
    ''');

    stmt.execute([
      tarefa.titulo,
      tarefa.descricao,
      tarefa.concluida ? 1 : 0,
      id,
    ]);

    stmt.dispose();

    final result = db.select('SELECT changes() AS count');
    final count = result.first['count'] as int;
    return count > 0;
  }

  bool deletar(int id) {
    final stmt = db.prepare('DELETE FROM tarefas WHERE id = ?');
    stmt.execute([id]);
    stmt.dispose();

    final result = db.select('SELECT changes() AS count');
    final count = result.first['count'] as int;
    return count > 0;
  }
}
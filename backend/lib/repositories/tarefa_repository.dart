import '../database/database.dart';
import '../models/tarefa.dart';

class TarefaRepository {
  final db = AppDatabase().db;

  int criar(Tarefa tarefa) {
    final stmt = db.prepare('''
      INSERT INTO tarefas (titulo, descricao, concluida, projeto_id)
      VALUES (?, ?, ?, ?)
    ''');

    stmt.execute([
      tarefa.titulo,
      tarefa.descricao,
      tarefa.concluida ? 1 : 0,
      tarefa.projetoId,
    ]);

    stmt.dispose();

    final result = db.select('SELECT last_insert_rowid() AS id');
    return result.first['id'] as int;
  }

  List<Tarefa> listarTodas() {
    final result = db.select('SELECT * FROM tarefas');
    return result.map((row) => Tarefa.fromMap(_rowToMap(row))).toList();
  }

  List<Tarefa> listarPorProjeto(int projetoId) {
    final result = db.select(
      'SELECT * FROM tarefas WHERE projeto_id = ?',
      [projetoId],
    );
    return result.map((row) => Tarefa.fromMap(_rowToMap(row))).toList();
  }

  Tarefa? buscarPorId(int id) {
    final result = db.select('SELECT * FROM tarefas WHERE id = ?', [id]);
    if (result.isEmpty) return null;
    return Tarefa.fromMap(_rowToMap(result.first));
  }

  bool atualizar(int id, Tarefa tarefa) {
    final stmt = db.prepare('''
      UPDATE tarefas
      SET titulo = ?, descricao = ?, concluida = ?, projeto_id = ?
      WHERE id = ?
    ''');

    stmt.execute([
      tarefa.titulo,
      tarefa.descricao,
      tarefa.concluida ? 1 : 0,
      tarefa.projetoId,
      id,
    ]);

    stmt.dispose();

    final result = db.select('SELECT changes() AS count');
    return (result.first['count'] as int) > 0;
  }

  bool deletar(int id) {
    final stmt = db.prepare('DELETE FROM tarefas WHERE id = ?');
    stmt.execute([id]);
    stmt.dispose();

    final result = db.select('SELECT changes() AS count');
    return (result.first['count'] as int) > 0;
  }

  Map<String, dynamic> _rowToMap(dynamic row) {
    return {
      'id': row['id'],
      'titulo': row['titulo'],
      'descricao': row['descricao'],
      'concluida': row['concluida'],
      'projeto_id': row['projeto_id'],
    };
  }
}
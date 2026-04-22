import 'package:sqlite3/sqlite3.dart';

class AppDatabase {
  static final AppDatabase _instance = AppDatabase._internal();
  late final Database db;

  factory AppDatabase() {
    return _instance;
  }

  AppDatabase._internal() {
    db = sqlite3.open('banco.db');
    _createTables();
  }

  void _createTables() {
    db.execute('PRAGMA foreign_keys = ON');

    db.execute('''
      CREATE TABLE IF NOT EXISTS projetos (
        id        INTEGER PRIMARY KEY AUTOINCREMENT,
        nome      TEXT NOT NULL,
        descricao TEXT NOT NULL
      )
    ''');

    db.execute('''
      CREATE TABLE IF NOT EXISTS tarefas (
        id         INTEGER PRIMARY KEY AUTOINCREMENT,
        titulo     TEXT    NOT NULL,
        descricao  TEXT    NOT NULL,
        concluida  INTEGER NOT NULL,
        projeto_id INTEGER NOT NULL,
        FOREIGN KEY (projeto_id) REFERENCES projetos(id) ON DELETE CASCADE
      )
    ''');
  }
}
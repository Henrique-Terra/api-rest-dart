import 'package:sqlite3/sqlite3.dart';

class AppDatabase {
  static final AppDatabase _instance = AppDatabase._internal();
  late final Database db;

  factory AppDatabase() {
    return _instance;
  }

  AppDatabase._internal() {
    db = sqlite3.open('banco.db');
    _createTable();
  }

  void _createTable() {
    db.execute('''
      CREATE TABLE IF NOT EXISTS tarefas (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        titulo TEXT NOT NULL,
        descricao TEXT NOT NULL,
        concluida INTEGER NOT NULL
      )
    ''');
  }
}
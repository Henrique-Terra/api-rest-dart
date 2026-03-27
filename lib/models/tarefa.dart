class Tarefa {
  final int? id;
  final String titulo;
  final String descricao;
  final bool concluida;

  Tarefa({
    this.id,
    required this.titulo,
    required this.descricao,
    required this.concluida,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'titulo': titulo,
      'descricao': descricao,
      'concluida': concluida ? 1 : 0,
    };
  }

  factory Tarefa.fromMap(Map<String, dynamic> map) {
    return Tarefa(
      id: map['id'] as int,
      titulo: map['titulo'] as String,
      descricao: map['descricao'] as String,
      concluida: (map['concluida'] as int) == 1,
    );
  }
}
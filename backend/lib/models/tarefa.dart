class Tarefa {
  final int? id;
  final String titulo;
  final String descricao;
  final bool concluida;
  final int projetoId;

  Tarefa({
    this.id,
    required this.titulo,
    required this.descricao,
    required this.concluida,
    required this.projetoId,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'titulo': titulo,
      'descricao': descricao,
      'concluida': concluida,
      'projeto_id': projetoId,
    };
  }

  factory Tarefa.fromMap(Map<String, dynamic> map) {
    return Tarefa(
      id: map['id'] as int,
      titulo: map['titulo'] as String,
      descricao: map['descricao'] as String,
      concluida: (map['concluida'] as int) == 1,
      projetoId: map['projeto_id'] as int,
    );
  }
}
class Projeto {
  final int? id;
  final String nome;
  final String descricao;

  Projeto({
    this.id,
    required this.nome,
    required this.descricao,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
      'descricao': descricao,
    };
  }

  factory Projeto.fromMap(Map<String, dynamic> map) {
    return Projeto(
      id: map['id'] as int,
      nome: map['nome'] as String,
      descricao: map['descricao'] as String,
    );
  }
}
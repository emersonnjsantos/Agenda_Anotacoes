class Anotacao {
  int? id;
  String titulo;
  String descricao;
  String data;

  Anotacao(this.id, this.titulo, this.descricao, this.data);

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'titulo': titulo,
      'descricao': descricao,
      'data': data,
    };
  }
}

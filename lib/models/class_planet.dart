class Planeta {
  int? id;
  String nome;
  double tamanho;
  double distancia;
  String? apelido;
  String? descricao;

  Planeta({
    this.id,
    required this.nome,
    required this.tamanho,
    required this.distancia,
    this.apelido,
    this.descricao,
  });

  Planeta.vazio()
      : nome = '',
        tamanho = 0.0,
        distancia = 0.0,
        apelido = '',
        descricao = '';

  factory Planeta.fromMap(Map<String, dynamic> map) => Planeta(
        id: map['id'],
        nome: map['nome'],
        tamanho: map['tamanho'],
        distancia: map['distancia'],
        apelido: map['apelido'],
        descricao: map['descricao'],
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'nome': nome,
        'tamanho': tamanho,
        'distancia': distancia,
        'apelido': apelido,
        'descricao': descricao,
      };
}
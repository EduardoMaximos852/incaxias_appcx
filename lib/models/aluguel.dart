class Aluguel {
  final String id;
  final String titulo;
  final String bairro;
  final String descricao;
  final double preco;
  final int quartos;
  final int banheiros;
  final int salas;
  final bool cozinhaAmericana;
  final String endereco;
  final String whatsapp;
  final String mapsUrl;
  final List<String> imagens;
  final String tipo;

  Aluguel({
    required this.id,
    required this.titulo,
    required this.bairro,
    required this.descricao,
    required this.preco,
    required this.quartos,
    required this.banheiros,
    required this.salas,
    required this.cozinhaAmericana,
    required this.endereco,
    required this.whatsapp,
    required this.mapsUrl,
    required this.imagens,
    required this.tipo,
  });

  factory Aluguel.fromMap(String id, Map<String, dynamic> map) {
    return Aluguel(
      id: id,
      titulo: map['titulo'] ?? '',
      bairro: map['bairro'] ?? '',
      descricao: map['descricao'] ?? '',
      preco: (map['preco'] ?? 0).toDouble(),
      quartos: map['quartos'] ?? 0,
      banheiros: map['banheiros'] ?? 0,
      salas: map['salas'] ?? 0,
      cozinhaAmericana: map['cozinhaAmericana'] ?? false,
      endereco: map['endereco'] ?? '',
      whatsapp: map['whatsapp'] ?? '',
      mapsUrl: map['mapsUrl'] ?? '',
      imagens: List<String>.from(map['imagens'] ?? []),
      tipo: map['tipo'] ?? '',
    );
  }
}

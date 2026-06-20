class Vaga {
  final String id;
  final String titulo;
  final String empresa;
  final String bairro;
  final String tipoVaga;
  final String imageUrl;

  Vaga({
    required this.id,
    required this.titulo,
    required this.empresa,
    required this.bairro,
    required this.tipoVaga,
    required this.imageUrl,
  });

  factory Vaga.fromMap(String id, Map<String, dynamic> map) {
    return Vaga(
      id: id,
      titulo: map['titulo'] ?? '',
      empresa: map['empresa'] ?? '',
      bairro: map['bairro'] ?? '',
      tipoVaga: map['tipoVaga'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
    );
  }

  data() {}
}

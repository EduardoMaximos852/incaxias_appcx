class Vereador {
  final String id;
  final String nome;
  final String fotoUrl;
  final String inicioMandato;
  final String fimMandato;
  final String partido;
  final int votos;
  final String historia;
  final String natural;
  final String descricao;

  Vereador({
    required this.id,
    required this.nome,
    required this.fotoUrl,
    required this.inicioMandato,
    required this.fimMandato,
    required this.partido,
    required this.votos,
    required this.historia,
    required this.natural,
    required this.descricao,
  });

  factory Vereador.fromFirestore(Map<String, dynamic> json, String id) {
    return Vereador(
      id: id,
      nome: json['nome'] ?? '',
      fotoUrl: json['fotoUrl'] ?? '',
      inicioMandato: json['inicioMandato'] ?? '',
      fimMandato: json['fimMandato'] ?? '',
      partido: json['partido'] ?? '',
      votos: json['votos'] ?? 0,
      historia: json['historia'] ?? '',
      natural: json['natural'] ?? '',
      descricao: json['descricao'] ?? '',
    );
  }
}

class Mototaxi {
  final String nome;
  final String apelido;
  final String cpf;
  final String carteiraMot;
  final String chassi;
  final String moto;
  final String placa;
  final String trabalho;
  final String whatsapp;
  final String endereco;
  final String bairro;
  final String fotoUrl;

  Mototaxi({
    required this.nome,
    required this.apelido,
    required this.cpf,
    required this.carteiraMot,
    required this.chassi,
    required this.moto,
    required this.placa,
    required this.trabalho,
    required this.whatsapp,
    required this.endereco,
    required this.bairro,
    required this.fotoUrl,
  });

  factory Mototaxi.fromMap(Map<String, dynamic> map) {
    return Mototaxi(
      nome: map['nome'] ?? '',
      apelido: map['Apelido'] ?? '',
      cpf: map['cpf'] ?? '',
      carteiraMot: map['carteira_mot'] ?? '',
      chassi: map['chassi'] ?? '',
      moto: map['moto'] ?? '',
      placa: map['placa'] ?? '',
      trabalho: map['trabalho'] ?? '',
      whatsapp: map['whatsapp'] ?? '',
      endereco: map['endereco'] ?? '',
      bairro: map['bairro'] ?? '',
      fotoUrl: map['fotoUrl'] ?? '',
    );
  }
}

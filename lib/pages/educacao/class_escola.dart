class EscolaModel {

  String nome;
  String endereco;
  String bairro;
  String telefone;
  String whatsapp;
  String imagemPrincipal;
  String descricao;
  double avaliacao;

  List<dynamic> galeria;
  List<dynamic> turmas;
  List<dynamic> biblioteca;
  List<dynamic> lazer;
  List<dynamic> professores;
  List<dynamic> laboratorios;

  EscolaModel({
    required this.nome,
    required this.endereco,
    required this.bairro,
    required this.telefone,
    required this.whatsapp,
    required this.imagemPrincipal,
    required this.descricao,
    required this.avaliacao,
    required this.galeria,
    required this.turmas,
    required this.biblioteca,
    required this.lazer,
    required this.professores,
    required this.laboratorios,
  });

  factory EscolaModel.fromMap(Map<String,dynamic> map){

    return EscolaModel(
      nome: map['nome'],
      endereco: map['endereco'],
      bairro: map['bairro'],
      telefone: map['telefone'],
      whatsapp: map['whatsapp'],
      imagemPrincipal: map['imagemPrincipal'],
      descricao: map['descricao'],
      avaliacao: (map['avaliacao']??0).toDouble(),

      galeria: map['galeria'] ?? [],
      turmas: map['turmas'] ?? [],
      biblioteca: map['biblioteca'] ?? [],
      lazer: map['lazer'] ?? [],
      professores: map['professores'] ?? [],
      laboratorios: map['laboratorios'] ?? [],
    );
  }

}
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class EmergencyContact {
  final String nome;
  final String telefone;
  final String imagem;

  EmergencyContact({
    required this.nome,
    required this.telefone,
    required this.imagem,
  });
}

class EmergencyPage extends StatefulWidget {
  const EmergencyPage({super.key});

  @override
  State<EmergencyPage> createState() => _EmergencyPageState();
}

class _EmergencyPageState extends State<EmergencyPage> {
  final TextEditingController pesquisaController = TextEditingController();

  final List<EmergencyContact> contatos = [
    EmergencyContact(
      nome: "SAMU",
      telefone: "192",
      imagem:
          "https://cdn-icons-png.flaticon.com/512/2967/2967350.png",
    ),
    EmergencyContact(
      nome: "Polícia Militar",
      telefone: "190",
      imagem:
          "https://cdn-icons-png.flaticon.com/512/295/295128.png",
    ),
    EmergencyContact(
      nome: "Corpo de Bombeiros",
      telefone: "193",
      imagem:
          "https://cdn-icons-png.flaticon.com/512/3306/3306571.png",
    ),
    EmergencyContact(
      nome: "Polícia Civil",
      telefone: "181",
      imagem:
          "https://cdn-icons-png.flaticon.com/512/3062/3062634.png",
    ),
    EmergencyContact(
      nome: "Defesa Civil",
      telefone: "199",
      imagem:
          "https://cdn-icons-png.flaticon.com/512/684/684908.png",
    ),
    EmergencyContact(
      nome: "PRF - Polícia Rodoviária Federal",
      telefone: "191",
      imagem:
          "https://cdn-icons-png.flaticon.com/512/1048/1048940.png",
    ),
    EmergencyContact(
      nome: "Disque Denúncia",
      telefone: "181",
      imagem:
          "https://cdn-icons-png.flaticon.com/512/2462/2462719.png",
    ),
    EmergencyContact(
      nome: "Disque Direitos Humanos",
      telefone: "100",
      imagem:
          "https://cdn-icons-png.flaticon.com/512/3063/3063828.png",
    ),
    EmergencyContact(
      nome: "Disque Mulher",
      telefone: "180",
      imagem:
          "https://cdn-icons-png.flaticon.com/512/3048/3048122.png",
    ),
    EmergencyContact(
      nome: "CEMAR - Equatorial Energia",
      telefone: "116",
      imagem:
          "https://cdn-icons-png.flaticon.com/512/1046/1046857.png",
    ),
    EmergencyContact(
      nome: "CAEMA",
      telefone: "0800 701 0195",
      imagem:
          "https://cdn-icons-png.flaticon.com/512/3105/3105807.png",
    ),
  ];

  List<EmergencyContact> filtrados = [];

  @override
  void initState() {
    super.initState();
    filtrados = contatos;
  }

  Future<void> ligar(String numero) async {
    final Uri uri = Uri(scheme: "tel", path: numero);

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  void filtrar(String valor) {
    setState(() {
      filtrados = contatos
          .where((e) =>
              e.nome.toLowerCase().contains(valor.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text("Urgência e Emergência"),
        centerTitle: true,
        backgroundColor: Colors.red,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(15),
            child: TextField(
              controller: pesquisaController,
              onChanged: filtrar,
              decoration: InputDecoration(
                hintText: "Pesquisar serviço...",
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filtrados.length,
              itemBuilder: (context, index) {
                final item = filtrados[index];

                return Card(
                  margin: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      radius: 28,
                      backgroundImage: NetworkImage(item.imagem),
                    ),
                    title: Text(
                      item.nome,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(item.telefone),
                    trailing: FloatingActionButton.small(
                      backgroundColor: Colors.green,
                      heroTag: index,
                      onPressed: () => ligar(item.telefone),
                      child: const Icon(Icons.phone),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
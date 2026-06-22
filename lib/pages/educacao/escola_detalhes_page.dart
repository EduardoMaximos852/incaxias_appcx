import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class EscolaDetalhesPage extends StatelessWidget {

  final DocumentSnapshot escola;

  const EscolaDetalhesPage({
    super.key,
    required this.escola,
  });

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      body: SingleChildScrollView(

        child: Column(

          crossAxisAlignment: CrossAxisAlignment.start,

          children: [

            Hero(
              tag: escola.id,
              child: Image.network(
                escola['imagemPrincipal'],
                width: double.infinity,
                height: 250,
                fit: BoxFit.cover,
              ),
            ),

            Padding(
              padding: EdgeInsets.all(15),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [

                  Text(
                    escola['nome'],
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  SizedBox(height: 10),

                  Text(escola['descricao']),

                  SizedBox(height: 20),

                  categoria(
                    "Galeria da Escola",
                    escola['galeria'],
                  ),

                  categoria(
                    "Salas e Turmas",
                    escola['turmas'],
                  ),

                  categoria(
                    "Biblioteca",
                    escola['biblioteca'],
                  ),

                  categoria(
                    "Área de Lazer",
                    escola['lazer'],
                  ),

                  categoria(
                    "Professores",
                    escola['professores'],
                  ),

                  categoria(
                    "Laboratórios",
                    escola['laboratorios'],
                  ),
                ],
              ),
            )

          ],
        ),
      ),
    );
  }

  Widget categoria(
      String titulo,
      List imagens,
      ){

    return Column(

      crossAxisAlignment: CrossAxisAlignment.start,

      children: [

        Text(
          titulo,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),

        SizedBox(height: 10),

        SizedBox(

          height: 150,

          child: ListView.builder(
            scrollDirection: Axis.horizontal,

            itemCount: imagens.length,

            itemBuilder: (_,i){

              return Container(

                width: 220,
                margin: EdgeInsets.only(right: 10),

                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.network(
                    imagens[i],
                    fit: BoxFit.cover,
                  ),
                ),
              );
            },
          ),
        ),

        SizedBox(height: 25),

      ],
    );
  }

}
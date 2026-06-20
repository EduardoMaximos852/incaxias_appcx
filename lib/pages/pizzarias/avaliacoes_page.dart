import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AvaliacaoWidget extends StatefulWidget {
  final String pizzariaId;
  const AvaliacaoWidget({super.key, required this.pizzariaId});

  @override
  State<AvaliacaoWidget> createState() => _AvaliacaoWidgetState();
}

class _AvaliacaoWidgetState extends State<AvaliacaoWidget> {
  double _rating = 0;
  final TextEditingController _comentarioController = TextEditingController();
  bool _enviando = false;

  Future<void> _enviarAvaliacao() async {
    if (_rating == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Selecione uma nota para avaliar.")),
      );
      return;
    }

    setState(() => _enviando = true);

    try {
      // 1️⃣ Adiciona avaliação na subcoleção
      await FirebaseFirestore.instance
          .collection('pizzarias')
          .doc(widget.pizzariaId)
          .collection('avaliacoes')
          .add({
            "nota": _rating,
            "comentario": _comentarioController.text,
            "data": Timestamp.now(),
          });

      // 2️⃣ Atualiza a última nota na pizzaria (para mostrar no card)
      await FirebaseFirestore.instance
          .collection('pizzarias')
          .doc(widget.pizzariaId)
          .update({
            'ultimaNota': _rating, // aqui fica a última nota enviada
          });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Avaliação enviada! Obrigado.")),
      );

      setState(() {
        _rating = 0;
        _comentarioController.clear();
      });
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Erro ao enviar avaliação: $e")));
    } finally {
      setState(() => _enviando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Avalie esta Pizzaria",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            5,
            (i) => IconButton(
              icon: Icon(
                i < _rating ? Icons.star : Icons.star_border,
                size: 32,
                color: Colors.amber,
              ),
              onPressed: () => setState(() => _rating = (i + 1).toDouble()),
            ),
          ),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _comentarioController,
          decoration: InputDecoration(
            hintText: "Deixe um comentário (opcional)",
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            fillColor: Colors.white,
            filled: true,
          ),
          maxLines: 3,
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _enviando ? null : _enviarAvaliacao,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade600,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            child: _enviando
                ? const CircularProgressIndicator(color: Colors.white)
                : const Text("Enviar Avaliação"),
          ),
        ),
      ],
    );
  }
}

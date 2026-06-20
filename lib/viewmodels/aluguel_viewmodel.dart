import 'package:flutter/material.dart';
import 'package:incaxias_appcx/respository/aluguel_repository.dart';
import '../models/aluguel.dart';

class AluguelViewModel extends ChangeNotifier {
  final AluguelRepository _repo = AluguelRepository();

  List<Aluguel> _lista = [];

  String bairroBusca = "";
  String tipoSelecionado = "Todos";
  double precoMax = 5000;

  Stream<List<Aluguel>> streamAlugueis() {
    return _repo.getAlugueis();
  }

  List<Aluguel> filtrar(List<Aluguel> lista) {
    return lista.where((item) {
      final bairroOk = item.bairro.toLowerCase().contains(
        bairroBusca.toLowerCase(),
      );

      final tipoOk = tipoSelecionado == "Todos"
          ? true
          : item.tipo.toLowerCase() == tipoSelecionado.toLowerCase();

      final precoOk = item.preco <= precoMax;

      return bairroOk && tipoOk && precoOk;
    }).toList();
  }
}

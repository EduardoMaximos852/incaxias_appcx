import 'package:shared_preferences/shared_preferences.dart';

class FavoritosService {
  static const _key = "favoritos";

  Future<List<String>> getFavoritos() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_key) ?? [];
  }

  Future<bool> isFavorito(String aluguelId) async {
    final lista = await getFavoritos();
    return lista.contains(aluguelId);
  }

  Future<void> toggleFavorito(String aluguelId) async {
    final prefs = await SharedPreferences.getInstance();
    final lista = await getFavoritos();

    if (lista.contains(aluguelId)) {
      lista.remove(aluguelId);
    } else {
      lista.add(aluguelId);
    }

    await prefs.setStringList(_key, lista);
  }
}

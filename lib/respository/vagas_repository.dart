import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/vaga.dart';

class VagasRepository {
  final _ref = FirebaseFirestore.instance.collection('vagas').orderBy('titulo');

  Stream<List<Vaga>> getVagas() {
    return _ref.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return Vaga.fromMap(doc.id, doc.data());
      }).toList();
    });
  }
}

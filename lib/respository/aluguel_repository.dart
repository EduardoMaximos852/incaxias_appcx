import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/aluguel.dart';

class AluguelRepository {
  final _db = FirebaseFirestore.instance.collection('aluguel');

  Stream<List<Aluguel>> getAlugueis() {
    return _db.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return Aluguel.fromMap(doc.id, doc.data());
      }).toList();
    });
  }
}

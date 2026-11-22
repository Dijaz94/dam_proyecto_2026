import 'package:cloud_firestore/cloud_firestore.dart';

class FsService {
  // Traer categorias de firestore
  Future<List<String>> categorias() async {
    final snap = await FirebaseFirestore.instance
        .collection('categorias')
        .get();
    if (snap.docs.isEmpty) return [];
    return List<String>.from(snap.docs.first['cat']);
  }
}

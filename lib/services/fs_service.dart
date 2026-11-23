import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FsService {
  // Traer categorias de firestore
  Future<List<String>> categorias() async {
    final snap = await FirebaseFirestore.instance
        .collection('categorias')
        .get();
    if (snap.docs.isEmpty) return [];
    return List<String>.from(snap.docs.first['cat']);
  }

  Future<void> agregarPublicacion(
    String titulo,
    String descripcion,
    String tipo,
    String categoria,
    String lugar,
    DateTime fechaHora,
    Uint8List foto,
  ) {
    final autor = FirebaseAuth.instance.currentUser!;

    return FirebaseFirestore.instance.collection('publicaciones').doc().set({
      'titulo': titulo,
      'descripcion': descripcion,
      'tipo': tipo,
      'categoria': categoria,
      'lugar': lugar,
      'estado': 'Vigente',
      'fechaHora': fechaHora,
      'foto': Blob(foto),
      'autorCorreo': autor.email,
    });
  }

  Stream<QuerySnapshot> publicaciones() {
    return FirebaseFirestore.instance.collection('publicaciones').snapshots();
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dam_proyecto_2026/pages/detalle.dart';
import 'package:dam_proyecto_2026/services/fs_service.dart';
import 'package:dam_proyecto_2026/theme.dart';
import 'package:flutter/material.dart';

class NavAllPosts extends StatefulWidget {
  const NavAllPosts({super.key});

  @override
  State<NavAllPosts> createState() => _NavAllPostsState();
}

class _NavAllPostsState extends State<NavAllPosts> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FsService().publicaciones(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData ||
            snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        var publicaciones = snapshot.data!.docs;

        return ListView.separated(
          separatorBuilder: (context, index) => Divider(),
          itemCount: publicaciones.length,
          itemBuilder: (context, index) {
            var publicacion = publicaciones[index];
            final bool esDevuelto = publicacion['estado'] == 'Devuelto';
            final Blob fotoBlob = publicacion['foto'] as Blob;

            return ListTile(
              tileColor: esDevuelto ? Colors.grey.shade200 : null,

              leading: ClipRRect(
                //widget para recortar hijo de forma rectangular con esquinas redondeadas
                borderRadius: BorderRadius.circular(8),
                child: Image.memory(
                  fotoBlob.bytes,
                  width: 56,
                  height: 56,
                  fit: BoxFit.cover,
                ),
              ),
              title: Text(publicacion['titulo']),
              subtitle: Text(
                '${publicacion['tipo']} • ${publicacion['categoria']} • ${publicacion['lugar']}',
              ),
              trailing: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: esDevuelto ? UsmColors.verde : UsmColors.rojo,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  publicacion['estado'],
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              onTap: () {
                // Aquí puedes abrir un detalle o diálogo si quieres
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Detalle(publicacion: publicacion),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}

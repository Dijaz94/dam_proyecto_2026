import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dam_proyecto_2026/services/fs_service.dart';
import 'package:flutter/material.dart';

class NavMyPosts extends StatefulWidget {
  const NavMyPosts({super.key});

  @override
  State<NavMyPosts> createState() => _NavMyPostsState();
}

class _NavMyPostsState extends State<NavMyPosts> {
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
            final Blob fotoBlob = publicacion['foto'] as Blob;

            return ListTile(
              leading: ClipRRect(
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
                '${publicacion['tipo']} • ${publicacion['lugar']}',
              ),
              trailing: Text(publicacion['categoria']),
              onTap: () {
                // Aquí puedes abrir un detalle o diálogo si quieres
              },
            );
          },
        );
      },
    );
  }
}

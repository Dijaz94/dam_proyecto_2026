import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dam_proyecto_2026/services/fs_service.dart';
import 'package:dam_proyecto_2026/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_design_icons/flutter_material_design_icons.dart';

class NavMyPosts extends StatefulWidget {
  const NavMyPosts({super.key});

  @override
  State<NavMyPosts> createState() => _NavMyPostsState();
}

class _NavMyPostsState extends State<NavMyPosts> {
  Future<void> _confirmarEliminacion(BuildContext context, String id) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Eliminar publicación'),
        content: const Text('¿Estás seguro? Esta acción no se puede deshacer.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: UsmColors.rojo,
              foregroundColor: Colors.white,
            ),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );

    if (confirmar == true) {
      await FsService().eliminarPublicacion(id);
    }
  }

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
            final bool esDevuelto = publicacion['estado'] == 'Devuelto';
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
              trailing: PopupMenuButton<String>(
                onSelected: (opcion) async {
                  if (opcion == 'estado') {
                    final nuevoEstado = esDevuelto ? 'Vigente' : 'Devuelto';
                    await FsService().cambiarEstado(
                      publicacion.id,
                      nuevoEstado,
                    );
                  } else if (opcion == 'eliminar') {
                    await _confirmarEliminacion(context, publicacion.id);
                  }
                },
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 'estado',
                    child: Row(
                      children: [
                        Icon(
                          esDevuelto ? MdiIcons.undo : MdiIcons.check,
                          color: esDevuelto ? UsmColors.azul : UsmColors.verde,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          esDevuelto
                              ? 'Marcar como vigente'
                              : 'Marcar como devuelto',
                        ),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'eliminar',
                    child: Row(
                      children: [
                        Icon(Icons.delete_outline, color: UsmColors.rojo),
                        const SizedBox(width: 8),
                        const Text('Eliminar'),
                      ],
                    ),
                  ),
                ],
              ),
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

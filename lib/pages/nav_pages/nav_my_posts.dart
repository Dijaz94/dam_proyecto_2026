import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dam_proyecto_2026/services/auth_service.dart';
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
      builder: (contextDialog) => AlertDialog(
        title: const Text('Eliminar publicación'),
        content: const Text('¿Estás seguro? Esta acción no se puede deshacer.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(contextDialog, false),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: UsmColors.rojo,
              foregroundColor: Colors.white,
            ),
            onPressed: () => Navigator.pop(contextDialog, true),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );

    if (confirmar == true) {
      await FsService().eliminarPublicacion(id);
    }
  }

  Widget _datoResumen(String titulo, int cantidad, Color color) {
    return Column(
      children: [
        Text(
          cantidad.toString(),
          style: TextStyle(
            color: color,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          titulo,
          style: const TextStyle(color: Colors.white70, fontSize: 12),
        ),
      ],
    );
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
        final total = publicaciones.length;
        final devueltos = publicaciones
            .where((doc) => doc['estado'] == 'Devuelto')
            .length;
        final vigentes = total - devueltos;
        final user = AuthService.instance.currentUser;

        return Column(
          children: [
            // Cabecera de perfil y resumen
            Container(
              margin: const EdgeInsets.all(12),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: UsmColors.azulOscuro,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 22,
                        backgroundColor: UsmColors.dorado,
                        backgroundImage: user?.photoURL != null
                            ? NetworkImage(user!.photoURL!)
                            : null,
                        child: user?.photoURL == null
                            ? const Icon(
                                Icons.person,
                                color: UsmColors.azulOscuro,
                              )
                            : null,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              user?.displayName ?? 'Usuario',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              user?.email ?? '',
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 12,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _datoResumen('Total', total, Colors.white),
                      _datoResumen('Vigentes', vigentes, UsmColors.dorado),
                      _datoResumen('Devueltos', devueltos, UsmColors.azulClaro),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.separated(
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
                          final nuevoEstado = esDevuelto
                              ? 'Vigente'
                              : 'Devuelto';
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
                                color: esDevuelto
                                    ? UsmColors.azul
                                    : UsmColors.verde,
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
              ),
            ),
          ],
        );
      },
    );
  }
}

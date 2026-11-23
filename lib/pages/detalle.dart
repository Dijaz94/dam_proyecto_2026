import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dam_proyecto_2026/theme.dart';
import 'package:dam_proyecto_2026/utils/fechas.dart';
import 'package:flutter/material.dart';

class Detalle extends StatelessWidget {
  const Detalle({super.key, required this.publicacion});

  final QueryDocumentSnapshot publicacion;

  @override
  Widget build(BuildContext context) {
    final Blob fotoBlob = publicacion['foto'] as Blob;

    return Scaffold(
      backgroundColor: UsmColors.azulClaro,
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Center(
          child: Container(
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.memory(fotoBlob.bytes, fit: BoxFit.cover),

                SizedBox(height: 20),
                Padding(
                  padding: EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Título: ${publicacion['titulo']}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text('Descripción: ${publicacion['descripcion']}'),
                      SizedBox(height: 5),
                      Text('Tipo: ${publicacion['tipo']}'),
                      SizedBox(height: 5),
                      Text('Categoría: ${publicacion['categoria']}'),
                      SizedBox(height: 5),
                      Text('Estado: ${publicacion['estado']}'),
                      SizedBox(height: 5),
                      Text(
                        'Fecha: ${formateadaFechaApi(publicacion['fechaHora'])}',
                      ),
                      SizedBox(height: 5),
                      Text(
                        'Hora: ${formateadaHoraApi(publicacion['fechaHora'])}',
                      ),
                      SizedBox(height: 5),
                      Text('Lugar: ${publicacion['lugar']}'),
                      SizedBox(height: 5),
                      Text('Autor: ${publicacion['autorCorreo']}'),
                    ],
                  ),
                ),
                SizedBox(height: 10),

                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Volver'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

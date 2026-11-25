import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dam_proyecto_2026/theme.dart';
import 'package:dam_proyecto_2026/utils/fechas.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_design_icons/flutter_material_design_icons.dart';

class Detalle extends StatelessWidget {
  const Detalle({super.key, required this.publicacion});

  final QueryDocumentSnapshot publicacion;

  @override
  Widget build(BuildContext context) {
    final Blob fotoBlob = publicacion['foto'] as Blob;
    final data = publicacion.data() as Map<String, dynamic>;
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
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        data['titulo'],
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 28,
                          color: UsmColors.azulOscuro,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        data['descripcion'],
                        style: TextStyle(
                          fontSize: 18,
                          color: UsmColors.azulOscuro,
                        ),
                      ),
                      SizedBox(height: 5),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: EdgeInsets.fromLTRB(8, 6, 8, 6),
                            decoration: BoxDecoration(
                              color: Colors.lightBlue.shade100,
                              borderRadius: BorderRadius.all(
                                Radius.circular(20),
                              ),
                            ),
                            child: Text(data['tipo']),
                          ),
                          SizedBox(width: 5),
                          Container(
                            padding: EdgeInsets.fromLTRB(8, 6, 8, 6),
                            decoration: BoxDecoration(
                              color: Colors.lightBlue.shade100,
                              borderRadius: BorderRadius.all(
                                Radius.circular(20),
                              ),
                            ),
                            child: Text(data['categoria']),
                          ),
                          SizedBox(width: 5),
                          Container(
                            padding: EdgeInsets.fromLTRB(8, 6, 8, 6),
                            decoration: BoxDecoration(
                              color: data['estado'] == 'Vigente'
                                  ? UsmColors.rojo
                                  : UsmColors.verde,
                              borderRadius: BorderRadius.all(
                                Radius.circular(20),
                              ),
                            ),
                            child: Text(
                              data['estado'],
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 20),
                      Padding(
                        padding: EdgeInsets.only(left: 40),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                              children: [
                                Icon(MdiIcons.calendarClock),
                                SizedBox(width: 5),

                                Text(
                                  'Fecha: ${formateadaFechaApi(data['fechaHora'])} - ${formateadaHoraApi(data['fechaHora'])}',
                                ),
                              ],
                            ),
                            SizedBox(height: 5),
                            Row(
                              children: [
                                Icon(MdiIcons.mapMarkerOutline),
                                SizedBox(width: 5),
                                Text('Lugar: ${data['lugar']}'),
                              ],
                            ),
                            SizedBox(height: 5),
                            Row(
                              children: [
                                Icon(MdiIcons.emailOutline),
                                SizedBox(width: 5),
                                Text('Autor: ${data['autor'] ?? 'unknown'}'),
                              ],
                            ),
                          ],
                        ),
                      ),
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

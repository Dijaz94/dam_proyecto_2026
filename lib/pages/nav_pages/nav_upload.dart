import 'dart:typed_data';

import 'package:dam_proyecto_2026/services/fs_service.dart';
import 'package:dam_proyecto_2026/theme.dart';
import 'package:dam_proyecto_2026/utils/fechas.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_design_icons/flutter_material_design_icons.dart';
import 'package:image_picker/image_picker.dart';

class NavUpload extends StatefulWidget {
  const NavUpload({super.key});

  @override
  State<NavUpload> createState() => _NavUploadState();
}

class _NavUploadState extends State<NavUpload> {
  final tituloCtrl = TextEditingController();
  final descripcionCtrl = TextEditingController();
  final lugarCtrl = TextEditingController();
  final formKey = GlobalKey<FormState>();

  final List<String> tipos = ['Perdido', 'Encontrado'];
  late final Future<List<String>> _categotiasFuture;
  String? tipoSeleccionado;
  String? categoriaSeleccionada;
  DateTime fechaSeleccionada = DateTime.now();
  DateTime horaSeleccionada = DateTime.now();

  DateTime fechaHoraSeleccionada = DateTime.now();
  Uint8List? fotoBytes;

  @override
  void dispose() {
    tituloCtrl.dispose();
    descripcionCtrl.dispose();
    lugarCtrl.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _categotiasFuture = FsService().categorias();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: UsmColors.azul,
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Center(
          child: Column(
            children: [
              SizedBox(height: 16),
              Text(
                'Nuevo Objeto',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 28,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 16),
              Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Form(
                  key: formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: tituloCtrl,
                        decoration: InputDecoration(
                          labelText: 'Título',
                          border: OutlineInputBorder(),
                        ),
                        validator: (valor) {
                          if (valor == null || valor.trim().isEmpty) {
                            return 'Este campo es obligatorio';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 20),
                      TextFormField(
                        controller: descripcionCtrl,
                        decoration: InputDecoration(
                          labelText: 'Descripción',
                          border: OutlineInputBorder(),
                        ),
                        validator: (valor) {
                          if (valor == null || valor.trim().isEmpty) {
                            return 'Este campo es obligatorio';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 20),
                      Row(
                        children: [
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              isExpanded: true,
                              decoration: InputDecoration(
                                labelText: 'Tipo',
                                border: OutlineInputBorder(),
                              ),
                              items: tipos
                                  .map(
                                    (tipo) => DropdownMenuItem(
                                      value: tipo,
                                      child: Text(tipo),
                                    ),
                                  )
                                  .toList(),
                              onChanged: (tipo) => tipoSeleccionado = tipo,
                              validator: (valor) {
                                if (valor == null || valor.trim().isEmpty) {
                                  return 'Este campo es obligatorio';
                                }
                                return null;
                              },
                            ),
                          ),
                          SizedBox(width: 20),
                          Expanded(
                            child: FutureBuilder(
                              future: _categotiasFuture,
                              builder: (context, snapshot) {
                                if (!snapshot.hasData ||
                                    snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                  return Center(
                                    child: CircularProgressIndicator(),
                                  );
                                }
                                var categorias = snapshot.data;
                                return DropdownButtonFormField(
                                  isExpanded: true,
                                  decoration: InputDecoration(
                                    labelText: 'Categorías',
                                    border: OutlineInputBorder(),
                                  ),
                                  items: categorias!
                                      .map(
                                        (cat) => DropdownMenuItem(
                                          value: cat,
                                          child: Text(cat),
                                        ),
                                      )
                                      .toList(),
                                  onChanged: (cat) =>
                                      categoriaSeleccionada = cat,
                                  validator: (valor) {
                                    if (valor == null || valor.trim().isEmpty) {
                                      return 'Selecciona un valor';
                                    }
                                    return null;
                                  },
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      TextFormField(
                        controller: lugarCtrl,
                        decoration: InputDecoration(
                          labelText: 'Lugar',
                          border: OutlineInputBorder(),
                        ),
                        validator: (valor) {
                          if (valor == null || valor.trim().isEmpty) {
                            return 'Este campo es obligatorio';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 20),
                      Row(
                        children: [
                          Text('Fecha: '),
                          Text(formateadaFecha(fechaSeleccionada.toString())),
                          Spacer(),
                          IconButton(
                            onPressed: () {
                              showDatePicker(
                                context: context,
                                firstDate: DateTime(2025),
                                lastDate: DateTime.now(),
                                initialDate: fechaSeleccionada,
                                builder: (context, child) {
                                  return Theme(
                                    data: Theme.of(context).copyWith(
                                      colorScheme: ColorScheme.light(
                                        primary: UsmColors.dorado,
                                        onPrimary: Colors.white,
                                        surface: Colors.white,
                                        onSurface: UsmColors.azulOscuro,
                                      ),
                                    ),
                                    child: child!,
                                  );
                                },
                              ).then((fecha) {
                                if (fecha != null) {
                                  setState(() {
                                    fechaSeleccionada = fecha;
                                  });
                                }
                              });
                            },
                            icon: Icon(
                              MdiIcons.calendarEdit,
                              color: UsmColors.rojo,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      Row(
                        children: [
                          Text('Hora: '),
                          Text(formateadaHora(horaSeleccionada.toString())),
                          Spacer(),
                          IconButton(
                            onPressed: () {
                              showTimePicker(
                                context: context,
                                initialTime: TimeOfDay.fromDateTime(
                                  horaSeleccionada,
                                ),
                                builder: (context, child) {
                                  return Theme(
                                    data: Theme.of(context).copyWith(
                                      colorScheme: ColorScheme.light(
                                        primary: UsmColors.dorado,
                                        onPrimary: Colors.white,
                                        surface: Colors.white,
                                        onSurface: UsmColors.azulOscuro,
                                      ),
                                    ),
                                    child: child!,
                                  );
                                },
                              ).then((hora) {
                                if (hora != null) {
                                  setState(() {
                                    horaSeleccionada = DateTime(
                                      horaSeleccionada.year,
                                      horaSeleccionada.month,
                                      horaSeleccionada.day,
                                      hora.hour,
                                      hora.minute,
                                    );
                                  });
                                }
                              });
                            },
                            icon: Icon(
                              MdiIcons.clockOutline,
                              color: UsmColors.rojo,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Imagen:'),
                          SizedBox(height: 8),
                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton.icon(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                  ),
                                  onPressed: () async {
                                    final archivo = await ImagePicker()
                                        .pickImage(
                                          source: ImageSource.camera,
                                          maxHeight: 1024,
                                          maxWidth: 1024,
                                        );

                                    if (archivo == null) return;

                                    final bytes = await archivo.readAsBytes();
                                    if (!mounted) return;

                                    // Para ver que no pese mas de 1 mega
                                    if (bytes.length > 900 * 1024) {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                            'Error, el archivo pesa más de 1Mb.',
                                          ),
                                          backgroundColor: UsmColors.azulClaro,
                                        ),
                                      );
                                      return;
                                    }

                                    setState(() {
                                      fotoBytes = bytes;
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                            'Imagen subida exitosamente.',
                                          ),
                                          backgroundColor: UsmColors.azulClaro,
                                        ),
                                      );
                                    });
                                  },
                                  icon: Icon(MdiIcons.camera),
                                  label: Text(
                                    'Tomar foto',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                              SizedBox(width: 10),
                              Expanded(
                                child: ElevatedButton.icon(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                  ),
                                  onPressed: () async {
                                    final archivo = await ImagePicker()
                                        .pickImage(
                                          source: ImageSource.gallery,
                                          maxHeight: 1024,
                                          maxWidth: 1024,
                                        );

                                    if (archivo == null) return;

                                    final bytes = await archivo.readAsBytes();
                                    if (!mounted) return;

                                    // Para ver que no pese mas de 1 mega
                                    if (bytes.length > 900 * 1024) {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                            'Error, el archivo pesa más de 1Mb.',
                                          ),
                                          backgroundColor: UsmColors.azulClaro,
                                        ),
                                      );
                                      return;
                                    }

                                    setState(() {
                                      fotoBytes = bytes;
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                            'Imagen subida exitosamente.',
                                          ),
                                          backgroundColor: UsmColors.azulClaro,
                                        ),
                                      );
                                    });
                                  },
                                  icon: Icon(MdiIcons.image),
                                  label: Text(
                                    'Galería',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: UsmColors.dorado,
                            elevation: 3,
                            textStyle: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          onPressed: () async {
                            if (!formKey.currentState!.validate()) return;

                            // 2. Valida que haya imagen antes de usar fotoBytes!
                            if (fotoBytes == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Debes seleccionar o tomar una foto',
                                  ),
                                ),
                              );
                              return;
                            }

                            try {
                              fechaHoraSeleccionada = DateTime(
                                fechaSeleccionada.year,
                                fechaSeleccionada.month,
                                fechaSeleccionada.day,
                                horaSeleccionada.hour,
                                horaSeleccionada.minute,
                              );

                              await FsService().agregarPublicacion(
                                tituloCtrl.text.trim(),
                                descripcionCtrl.text.trim(),
                                tipoSeleccionado!,
                                categoriaSeleccionada!,
                                lugarCtrl.text.trim(),
                                fechaHoraSeleccionada,
                                fotoBytes!,
                              );
                              tituloCtrl.clear();
                              descripcionCtrl.clear();
                              lugarCtrl.clear();
                              formKey.currentState?.reset();

                              setState(() {
                                tipoSeleccionado = null;
                                categoriaSeleccionada = null;
                                fotoBytes = null;
                                fechaSeleccionada = DateTime.now();
                                horaSeleccionada = DateTime.now();
                              });

                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Publicación subida exitosamente',
                                  ),
                                  backgroundColor: UsmColors.azulClaro,
                                ),
                              );
                            } catch (error) {}
                          },
                          child: Text('Publicar'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

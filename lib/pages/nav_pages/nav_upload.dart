import 'package:flutter/material.dart';

class NavUpload extends StatefulWidget {
  const NavUpload({super.key});

  @override
  State<NavUpload> createState() => _NavUploadState();
}

class _NavUploadState extends State<NavUpload> {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text('Subir Post'));
  }
}

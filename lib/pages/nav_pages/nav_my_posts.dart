import 'package:dam_proyecto_2026/services/auth_service.dart';
import 'package:flutter/material.dart';

class NavMyPosts extends StatefulWidget {
  const NavMyPosts({super.key});

  @override
  State<NavMyPosts> createState() => _NavMyPostsState();
}

class _NavMyPostsState extends State<NavMyPosts> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Mis Posts'),
          ElevatedButton(
            onPressed: AuthService.instance.signOut,
            child: Text('Cerrar Sesión'),
          ),
        ],
      ),
    );
  }
}

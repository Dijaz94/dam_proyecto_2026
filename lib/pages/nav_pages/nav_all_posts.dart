import 'package:flutter/material.dart';

class NavAllPosts extends StatefulWidget {
  const NavAllPosts({super.key});

  @override
  State<NavAllPosts> createState() => _NavAllPostsState();
}

class _NavAllPostsState extends State<NavAllPosts> {
  @override
  Widget build(BuildContext context) {
    return Container(child: Text('Todos los Posts'));
  }
}

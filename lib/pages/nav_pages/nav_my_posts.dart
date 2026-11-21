import 'package:flutter/material.dart';

class NavMyPosts extends StatefulWidget {
  const NavMyPosts({super.key});

  @override
  State<NavMyPosts> createState() => _NavMyPostsState();
}

class _NavMyPostsState extends State<NavMyPosts> {
  @override
  Widget build(BuildContext context) {
    return Container(child: Text('Mis Posts'));
  }
}

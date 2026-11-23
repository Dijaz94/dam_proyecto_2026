import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NavMyPosts extends StatefulWidget {
  const NavMyPosts({super.key});

  @override
  State<NavMyPosts> createState() => _NavMyPostsState();
}

class _NavMyPostsState extends State<NavMyPosts> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('My Posts'),

            ElevatedButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
              },
              child: Text('Cerrar sesión'),
            ),
          ],
        ),
      ),
    );
  }
}

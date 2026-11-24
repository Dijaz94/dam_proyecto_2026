import 'package:dam_proyecto_2026/pages/nav_pages/nav_all_posts.dart';
import 'package:dam_proyecto_2026/pages/nav_pages/nav_my_posts.dart';
import 'package:dam_proyecto_2026/pages/nav_pages/nav_upload.dart';
import 'package:dam_proyecto_2026/services/auth_service.dart';
import 'package:dam_proyecto_2026/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_design_icons/flutter_material_design_icons.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _paginaSeleccionada = 0;
  final List<Widget> _paginas = [NavAllPosts(), NavUpload(), NavMyPosts()];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: UsmColors.azul,
        foregroundColor: Colors.white,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Text(
                AuthService.instance.currentUser?.displayName ?? 'unknown',
                style: const TextStyle(fontSize: 18),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Image.asset('lib/assets/Logo_UTFSM.png', height: 40),
            if (_paginaSeleccionada == 2)
              InkWell(
                onTap: AuthService.instance.signOut,
                borderRadius: BorderRadius.circular(8),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 4,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(MdiIcons.logout, size: 22),
                      const Text(
                        'Cerrar sesión',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),

      body: IndexedStack(index: _paginaSeleccionada, children: _paginas),
      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(
          backgroundColor: UsmColors.azulOscuro,
          indicatorColor: Colors.white,
          labelTextStyle: WidgetStateProperty.all(
            TextStyle(color: Colors.white),
          ),
          iconTheme: WidgetStateProperty.resolveWith((state) {
            if (state.contains(WidgetState.selected)) {
              return IconThemeData(color: UsmColors.azulOscuro);
            }
            return IconThemeData(color: Colors.white);
          }),
        ),

        child: NavigationBar(
          selectedIndex: _paginaSeleccionada,
          onDestinationSelected: (indice) {
            setState(() {
              _paginaSeleccionada = indice;
            });
          },
          destinations: [
            NavigationDestination(
              icon: Icon(MdiIcons.post),
              label: 'Publicaciones',
            ),
            NavigationDestination(icon: Icon(MdiIcons.upload), label: 'Subir'),
            NavigationDestination(
              icon: Icon(MdiIcons.account),
              label: 'Mis publicaciones',
            ),
          ],
        ),
      ),
    );
  }
}

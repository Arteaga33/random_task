import 'package:flutter/material.dart';

import '../screens/settings_screen.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          AppBar(
            title: const Text('Arteaga 33', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.task),
            title: const Text('Tasks'),
            onTap:(){
              Navigator.of(context).pushNamed('/');
            }
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Filters and settings'),
            onTap:(){
              Navigator.of(context).pushNamed(SettingsScreen.routeName);
            }
          )
        ],
      ),
    );
  }
}

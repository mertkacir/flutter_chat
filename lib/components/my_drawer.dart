import "package:flutter/material.dart";
import "package:namer_app/services/auth/auth_service.dart";

import "../pages/settings_page.dart";

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});
  void logout(){
    final auth = AuthService();
    auth.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.background,
      child: Column(
        children: [
          DrawerHeader(child:Center(
            child:Icon(
              Icons.message,
              color: Theme.of(context).colorScheme.primary,
              size: 40,
            ),
          ),
        ),

        Padding(
          padding: const EdgeInsets.only(left: 25.0),
          child: ListTile(
            title: Text("A N A    E K R A N"),
            leading: Icon(Icons.home),
            onTap: () {
              Navigator.pop(context);
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 25.0),
          child: ListTile(
            title: Text("A Y A R L A R"),
            leading: Icon(Icons.settings),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(
                builder: (context) => SettingsPage(),
                ),
              );
              
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 25.0),
          child: ListTile(
            title: Text("Ç I K I Ş"),
            leading: Icon(Icons.logout),
            onTap: logout,
          ),
        )
        ],
      ),
    );
  }
}
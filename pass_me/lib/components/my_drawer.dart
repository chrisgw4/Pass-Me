import 'package:flutter/material.dart';


class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.surface,
      child: Column(
        children: [
          // Drawer Header
          DrawerHeader(
              child: Icon(
                Icons.favorite,
                color: Theme.of(context).colorScheme.inversePrimary,
              ),

          ),

          const SizedBox(height: 25,),

          // Home title
          Padding(
            padding: const EdgeInsets.only(left:25),
            child: ListTile(
              leading: Icon(
                Icons.home,
                color: Theme.of(context).colorScheme.inversePrimary,
              ),
              title: Text("Home"),
              onTap: () {
                // already home screen so pop it
                Navigator.pop(context);
              },
            ),
          ),

          // profile
          Padding(
            padding: const EdgeInsets.only(left:25),
            child: ListTile(
              leading: Icon(
                Icons.person,
                color: Theme.of(context).colorScheme.inversePrimary,
              ),
              title: Text("Profile"),
              onTap: () {
                // already home screen so pop it
                Navigator.pop(context);
                
                Navigator.pushNamed(context, '/profile_page');
              },
            ),
          ),

          // users
          Padding(
            padding: const EdgeInsets.only(left:25),
            child: ListTile(
              leading: Icon(
                Icons.group,
                color: Theme.of(context).colorScheme.inversePrimary,
              ),
              title: Text("Users"),
              onTap: () {
                // already home screen so pop it
                Navigator.pop(context);

                Navigator.pushNamed(context, '/users_page');
              },
            ),
          )
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';

import '../screens/login_screen.dart';
import '../screens/orders_screen.dart';
import '../screens/product_management_screen.dart';
import '../screens/user_registration_screen.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Text(
              'Drawer Header',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Home'),
            onTap: () {
              // Update the state of the app
              // ...
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.people),
            title: const Text('User Registration'),
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const UserRegistrationForm()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.category),
            title: const Text('Product Management'),
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) =>  const ProductManagementPage()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.inventory),
            title: const Text('Orders'),
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) =>  const OrdersPage()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Log Out'),
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) =>  const LoginScreen()));
            },
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';

import '../widgets/custom_drawer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Responsive Drawer Example'),
      ),
      drawer: const CustomDrawer(), // Integrate the custom drawer here
      body: const Center(
        child: Text('Hello, World!'),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class AdministrationPage extends StatelessWidget {
  const AdministrationPage({super.key});

  static Route<void> route() {
    return MaterialPageRoute<void>(builder: (_) => const AdministrationPage());
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: const Text('Administrations'),
      ),
      body: const Center(
        child: Placeholder(),
      ),
    );
  }
}

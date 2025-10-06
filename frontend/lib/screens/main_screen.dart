import 'package:flutter/material.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Карта ПВЗ')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.map, size: 64, color: Colors.blue),
            SizedBox(height: 16),
            Text('Главная — карта ПВЗ\n(заглушка для MVP)', textAlign: TextAlign.center),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Навигация к созданию заказа
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
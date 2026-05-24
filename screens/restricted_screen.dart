import 'package:flutter/material.dart';

/// Пример закрытого экрана, доступного только после входа.
class RestrictedScreen extends StatelessWidget {
  const RestrictedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Секретный раздел')),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.check_circle, color: Colors.green, size: 80),
            SizedBox(height: 16),
            Text('Вы получили полный доступ!'),
          ],
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'telas/telaLogin.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Contatos',
      theme: ThemeData(colorSchemeSeed: Colors.blue),
      home: const TelaLogin(),
    );
  }
}

import 'package:flutter/material.dart';

import 'package:exemplo/view/pessoas_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const PessoasApp());
}

class PessoasApp extends StatelessWidget {
  const PessoasApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Persistência Local (SQLite)',
      theme: ThemeData(useMaterial3: true),
      home: const PessoasPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
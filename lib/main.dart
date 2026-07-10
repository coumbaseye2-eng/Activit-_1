import 'package:activite_1_dclic/views/login.dart';
import 'package:flutter/material.dart';
import 'Services/database_manager.dart';
import 'modele/user.dart';

final ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(ThemeMode.light);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _creerUtilisateurTestSiBesoin();
  runApp(const NotesApp());
}

Future<void> _creerUtilisateurTestSiBesoin() async {
  final dbManager = DatabaseManager();
  final existant = await dbManager.getUserByCredentials('coumbista', '1234');
  if (existant == null) {
    try {
      await dbManager.insertUser(
        User(username: 'coumbista', password: '1234'),
      );
    } catch (e) {}
  }
}

class NotesApp extends StatelessWidget {
  const NotesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (context, currentTheme, _) {
        return MaterialApp(
          title: 'Notes App',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            brightness: Brightness.light,
            primarySwatch: Colors.indigo,
          ),
          darkTheme: ThemeData(
            brightness: Brightness.dark,
            primarySwatch: Colors.indigo,
          ),
          themeMode: currentTheme,
          home: const LoginInterface(),
        );
      },
    );
  }
}
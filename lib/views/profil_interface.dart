import 'dart:io';
import 'package:flutter/material.dart';
import '../modele/user.dart';
import '../Services/database_manager.dart';
import 'login.dart';

class ProfilInterface extends StatefulWidget {
  final User user;

  const ProfilInterface({super.key, required this.user});

  @override
  State<ProfilInterface> createState() => _ProfilInterfaceState();
}

class _ProfilInterfaceState extends State<ProfilInterface> {
  final DatabaseManager _dbManager = DatabaseManager();
  late User _user;

  @override
  void initState() {
    super.initState();
    _user = widget.user;
  }
  Future<void> _changerTheme(bool sombre) async {
    _user.theme = sombre ? 'sombre' : 'clair';
    await _dbManager.updateUser(_user);
    setState(() {});
  }
  Future<void> _changerLangue(String? langue) async {
    if (langue == null) return;
    _user.langue = langue;
    await _dbManager.updateUser(_user);
    setState(() {});
  }

  Future<void> _seDeconnecter() async {
    final bool? confirme = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmer la déconnexion'),
        content: const Text('Voulez-vous vraiment vous déconnecter ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Se déconnecter', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirme == true && mounted) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const LoginInterface()),
            (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        children: [
          const SizedBox(height: 12),
          const SizedBox(height: 12),
          Text(_user.username, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const Divider(height: 40),
          Align(
            alignment: Alignment.centerLeft,
            child: Text('PARAMÈTRES', style: TextStyle(color: Colors.grey[600], fontSize: 12)),
          ),
          const SizedBox(height: 8),
          SwitchListTile(
            title: const Text('Thème sombre'),
            value: _user.theme == 'sombre',
            onChanged: _changerTheme,
          ),
          ListTile(
            title: const Text('Langue'),
            trailing: DropdownButton<String>(
              value: _user.langue,
              items: const [
                DropdownMenuItem(value: 'fr', child: Text('Français')),
                DropdownMenuItem(value: 'en', child: Text('English')),
              ],
              onChanged: _changerLangue,
            ),
          ),
          const Spacer(),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: _seDeconnecter,
              style: OutlinedButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('Se déconnecter'),
            ),
          ),
        ],
      ),
    );
  }
}
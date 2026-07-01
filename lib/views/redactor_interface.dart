import 'package:flutter/material.dart';
import '../modele/redactor.dart';
import '../services/database_manager.dart';

class RedacteurInterface extends StatefulWidget {
  const RedacteurInterface({super.key});

  @override
  State<RedacteurInterface> createState() => _RedacteurInterfaceState();
}

class _RedacteurInterfaceState extends State<RedacteurInterface> {
  final DatabaseManager _dbManager = DatabaseManager();

  final TextEditingController _nomController = TextEditingController();
  final TextEditingController _prenomController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _rechercheController = TextEditingController();

  List<Redactor> _redacteursList = [];
  List<Redactor> _redacteursAffiches = [];
  bool _rechercheActive = false;

  @override
  void initState() {
    super.initState();
    _refreshRedacteursList();
  }

  void _refreshRedacteursList() async {
    final data = await _dbManager.getAllRedacteurs();
    setState(() {
      _redacteursList = data;
      _appliquerRecherche();
    });
  }

  void _appliquerRecherche() {
    final texte = _rechercheController.text.trim().toLowerCase();
    if (texte.isEmpty) {
      _redacteursAffiches = _redacteursList;
    } else {
      _redacteursAffiches = _redacteursList.where((r) {
        return r.nom.toLowerCase().contains(texte) ||
            r.prenom.toLowerCase().contains(texte) ||
            r.email.toLowerCase().contains(texte);
      }).toList();
    }
  }

  void _basculerRecherche() {
    setState(() {
      _rechercheActive = !_rechercheActive;
      if (!_rechercheActive) {
        _rechercheController.clear();
        _appliquerRecherche();
      }
    });
  }

  void _ajouterRedacteur() async {
    if (_nomController.text.trim().isEmpty ||
        _prenomController.text.trim().isEmpty ||
        _emailController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veuillez remplir tous les champs')),
      );
      return;
    }

    Redactor nouveau = Redactor.sansId(
      nom: _nomController.text.trim(),
      prenom: _prenomController.text.trim(),
      email: _emailController.text.trim(),
    );

    try {
      await _dbManager.insertRedacteur(nouveau);
      _nomController.clear();
      _prenomController.clear();
      _emailController.clear();
      _refreshRedacteursList();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Rédacteur ajouté avec succès !')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString().replaceFirst('Exception: ', ''))),
      );
    }
  }

  void _afficherDialogueModification(Redactor redacteur) {
    final TextEditingController modifNomController = TextEditingController(text: redacteur.nom);
    final TextEditingController modifPrenomController = TextEditingController(text: redacteur.prenom);
    final TextEditingController modifEmailController = TextEditingController(text: redacteur.email);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Modifier Rédacteur'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: modifNomController, decoration: const InputDecoration(labelText: 'Nouveau Nom')),
              TextField(controller: modifPrenomController, decoration: const InputDecoration(labelText: 'Nouveau Prénom')),
              TextField(controller: modifEmailController, decoration: const InputDecoration(labelText: 'Nouvel Email')),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () async {
              redacteur.nom = modifNomController.text.trim();
              redacteur.prenom = modifPrenomController.text.trim();
              redacteur.email = modifEmailController.text.trim();

              try {
                await _dbManager.updateRedacteur(redacteur);
                Navigator.pop(context);
                _refreshRedacteursList();
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(e.toString().replaceFirst('Exception: ', ''))),
                );
              }
            },
            child: const Text('Enregistrer'),
          ),
        ],
      ),
    );
  }

  void _confirmerSuppression(int id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmation'),
        content: const Text('Voulez-vous vraiment supprimer ce rédacteur ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              try {
                await _dbManager.deleteRedacteur(id);
                Navigator.pop(context);
                _refreshRedacteursList();
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(e.toString().replaceFirst('Exception: ', ''))),
                );
              }
            },
            child: const Text('Supprimer', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _rechercheActive
            ? TextField(
          controller: _rechercheController,
          autofocus: true,
          style: const TextStyle(color: Colors.white),
          cursorColor: Colors.white,
          decoration: const InputDecoration(
            hintText: 'Rechercher un rédacteur...',
            hintStyle: TextStyle(color: Colors.white70),
            border: InputBorder.none,
          ),
          onChanged: (value) {
            setState(() {
              _appliquerRecherche();
            });
          },
        )
            : const Text('Gestion des rédacteurs', style: TextStyle(color: Colors.white)),
        centerTitle: false,
        backgroundColor: Colors.pinkAccent,
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.white),
          onPressed: () {},
        ),
        actions: [
          IconButton(
            icon: Icon(_rechercheActive ? Icons.close : Icons.search, color: Colors.white),
            onPressed: _basculerRecherche,
          ),
        ],
      ),
      body: Column(
        children: [
          if (!_rechercheActive)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  TextField(controller: _nomController, decoration: const InputDecoration(labelText: 'Nom')),
                  TextField(controller: _prenomController, decoration: const InputDecoration(labelText: 'Prénom')),
                  TextField(controller: _emailController, decoration: const InputDecoration(labelText: 'Email')),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _ajouterRedacteur,
                      icon: const Icon(Icons.add, color: Colors.white),
                      label: const Text('Ajouter un Rédacteur', style: TextStyle(color: Colors.white, fontSize: 16)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.pinkAccent,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          const Divider(height: 1),
          Expanded(
            child: _redacteursAffiches.isEmpty
                ? Center(
              child: Text(
                _rechercheController.text.trim().isEmpty
                    ? 'Aucun rédacteur enregistré.'
                    : 'Aucun résultat trouvé.',
              ),
            )
                : ListView.builder(
              itemCount: _redacteursAffiches.length,
              itemBuilder: (context, index) {
                final item = _redacteursAffiches[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  child: ListTile(
                    title: Text('${item.nom} ${item.prenom}', style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text(item.email),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.grey),
                          onPressed: () => _afficherDialogueModification(item),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.grey),
                          onPressed: () => _confirmerSuppression(item.id!),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
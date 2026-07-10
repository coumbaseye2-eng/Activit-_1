import 'package:flutter/material.dart';
import '../modele/note.dart';
import '../modele/user.dart';
import '../Services/database_manager.dart';
import 'edition_interface.dart';
import 'profil_interface.dart';

class AccueilInterface extends StatefulWidget {
  final User user;

  const AccueilInterface({super.key, required this.user});

  @override
  State<AccueilInterface> createState() => _AccueilInterfaceState();
}

class _AccueilInterfaceState extends State<AccueilInterface> {
  final DatabaseManager _dbManager = DatabaseManager();

  List<Note> _notesList = [];
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _refreshNotesList();
  }

  void _refreshNotesList() async {
    final data = await _dbManager.getAllNotes();
    setState(() {
      _notesList = data;
    });
  }

  void _onTabTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<void> _ouvrirCreation() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const EditionInterface()),
    );
    _refreshNotesList();
  }

  Future<void> _ouvrirModification(Note note) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EditionInterface(note: note)),
    );
    _refreshNotesList();
  }

  Future<void> _confirmerSuppression(Note note) async {
    final bool? confirme = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmer la suppression'),
        content: const Text('Voulez-vous vraiment supprimer cette note ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Supprimer', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirme == true && note.id != null) {
      try {
        await _dbManager.deleteNote(note.id!);
        _refreshNotesList();
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Une erreur est survenue lors de la suppression.')),
        );
      }
    }
  }

  Widget _buildListeNotes() {
    if (_notesList.isEmpty) {
      return const Center(
        child: Text(
          "Aucune note pour l'instant.\nAppuyez sur + pour en créer une.",
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.grey),
        ),
      );
    }
    return ListView.builder(
      itemCount: _notesList.length,
      itemBuilder: (context, index) {
        final note = _notesList[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          child: ListTile(
            title: Text(
              note.contenu,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            onTap: () => _ouvrirModification(note),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit, size: 20),
                  onPressed: () => _ouvrirModification(note),
                ),
                IconButton(
                  icon: const Icon(Icons.delete, size: 20, color: Colors.red),
                  onPressed: () => _confirmerSuppression(note),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool surAccueil = _selectedIndex == 0;

    return Scaffold(
      appBar: AppBar(title: Text(surAccueil ? 'Mes Notes' : 'Profil')),
      body: surAccueil
          ? _buildListeNotes()
          : ProfilInterface(user: widget.user),
      floatingActionButton: surAccueil
          ? FloatingActionButton(
        onPressed: _ouvrirCreation,
        child: const Icon(Icons.add),
      )
          : null,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onTabTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Accueil'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
        ],
      ),
    );
  }
}
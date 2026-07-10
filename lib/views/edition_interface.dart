import 'package:flutter/material.dart';
import '../modele/note.dart';
import '../Services/database_manager.dart';

class EditionInterface extends StatefulWidget {
  final Note? note;
  const EditionInterface({super.key, this.note});

  @override
  State<EditionInterface> createState() => _EditionInterfaceState();
}
class _EditionInterfaceState extends State<EditionInterface> {
  final DatabaseManager _dbManager = DatabaseManager();
  late final TextEditingController _contenuController;

  bool get _enModification => widget.note != null;

  @override
  void initState() {
    super.initState();
    _contenuController = TextEditingController(text: widget.note?.contenu ?? '');
  }
  @override
  void dispose() {
    _contenuController.dispose();
    super.dispose();
  }

  Future<void> _enregistrer() async {
    final texte = _contenuController.text.trim();
    if (texte.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Le contenu de la note ne peut pas être vide.')),
      );
      return;
    }
    final maintenant = DateTime.now().toIso8601String();

    try {
      if (_enModification) {
        final noteModifiee = Note(
          id: widget.note!.id,
          contenu: texte,
          createdAt: widget.note!.createdAt,
          updatedAt: maintenant,
        );
        await _dbManager.updateNote(noteModifiee);
      } else {
        final nouvelleNote = Note.sansId(
          contenu: texte,
          createdAt: maintenant,
          updatedAt: maintenant,
        );
        await _dbManager.insertNote(nouvelleNote);
      }
      if (!mounted) return;
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Une erreur est survenue lors de l\'enregistrement.')),
      );
    }
  }
  void _annuler() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_enModification ? 'Modifier la note' : 'Nouvelle note'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: TextField(
                controller: _contenuController,
                maxLines: null,
                expands: true,
                textAlignVertical: TextAlignVertical.top,
                decoration: const InputDecoration(
                  hintText: 'Écrivez votre note ici...',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: _annuler,
                    child: const Text('Annuler'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _enregistrer,
                    child: const Text('Enregistrer'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
class Note {
  int? id;
  String contenu;
  String createdAt;
  String updatedAt;

  Note({
    this.id,
    required this.contenu,
    required this.createdAt,
    required this.updatedAt,
  });

  Note.sansId({
    required this.contenu,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'contenu': contenu,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }

  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
      id: map['id'] as int?,
      contenu: map['contenu'] as String,
      createdAt: map['created_at'] as String,
      updatedAt: map['updated_at'] as String,
    );
  }
}
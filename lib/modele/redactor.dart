class Redactor {
  int? id;
  String nom;
  String prenom;
  String email;
  Redactor({
    this.id,
    required this.nom,
    required this.prenom,
    required this.email,
  });
  Redactor.sansId({
    required this.nom,
    required this.prenom,
    required this.email,
  });
  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'nom': nom,
      'prenom': prenom,
      'email': email,
    };
  }
  factory Redactor.fromMap(Map<String, dynamic> map) {
    return Redactor(
      id: map['id'] as int?,
      nom: map['nom'] as String,
      prenom: map['prenom'] as String,
      email: map['email'] as String,
    );
  }
}
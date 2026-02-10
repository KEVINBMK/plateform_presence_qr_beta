class UserModel {
  final String uid;
  final String email;
  final String nom;
  final String prenom;
  final UserRole role;
  final String? matricule; // Pour étudiants
  final String? departement; // Pour professeurs

  UserModel({
    required this.uid,
    required this.email,
    required this.nom,
    required this.prenom,
    required this.role,
    this.matricule,
    this.departement,
  });

  // Créer depuis Firestore
  factory UserModel.fromFirestore(Map<String, dynamic> data, String uid) {
    return UserModel(
      uid: uid,
      email: data['email'] ?? '',
      nom: data['nom'] ?? '',
      prenom: data['prenom'] ?? '',
      role: UserRole.fromString(data['role'] ?? 'ETUDIANT'),
      matricule: data['matricule'],
      departement: data['departement'],
    );
  }

  // Convertir en Map pour Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'email': email,
      'nom': nom,
      'prenom': prenom,
      'role': role.toFirestore(),
      if (matricule != null) 'matricule': matricule,
      if (departement != null) 'departement': departement,
    };
  }

  String get fullName => '$prenom $nom';
}

enum UserRole {
  prof,
  etudiant;

  static UserRole fromString(String role) {
    switch (role.toUpperCase()) {
      case 'PROF':
        return UserRole.prof;
      case 'ETUDIANT':
        return UserRole.etudiant;
      default:
        return UserRole.etudiant;
    }
  }

  String toFirestore() {
    switch (this) {
      case UserRole.prof:
        return 'PROF';
      case UserRole.etudiant:
        return 'ETUDIANT';
    }
  }
}


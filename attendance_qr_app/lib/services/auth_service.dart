import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Stream de l'état d'authentification
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Utilisateur actuel
  User? get currentUser => _auth.currentUser;

  // Connexion avec gestion d'erreurs
  Future<UserCredential> signIn(String email, String password) async {
    try {
      return await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'user-not-found':
          throw Exception('Aucun utilisateur trouvé avec cet email');
        case 'wrong-password':
          throw Exception('Mot de passe incorrect');
        case 'invalid-email':
          throw Exception('Email invalide');
        case 'user-disabled':
          throw Exception('Ce compte a été désactivé');
        case 'too-many-requests':
          throw Exception('Trop de tentatives. Réessayez plus tard');
        default:
          throw Exception('Erreur de connexion: ${e.message}');
      }
    } catch (e) {
      throw Exception('Erreur inattendue: $e');
    }
  }

  // Inscription avec création du profil Firestore
  Future<UserCredential> signUp({
    required String email,
    required String password,
    required String nom,
    required String prenom,
    required UserRole role,
    String? matricule,
    String? departement,
  }) async {
    try {
      // Créer le compte Firebase Auth
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      // Créer le profil utilisateur dans Firestore
      final user = UserModel(
        uid: credential.user!.uid,
        email: email.trim(),
        nom: nom,
        prenom: prenom,
        role: role,
        matricule: matricule,
        departement: departement,
      );

      await _db.collection('users').doc(credential.user!.uid).set(user.toFirestore());

      return credential;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'email-already-in-use':
          throw Exception('Cet email est déjà utilisé');
        case 'weak-password':
          throw Exception('Le mot de passe est trop faible');
        case 'invalid-email':
          throw Exception('Email invalide');
        default:
          throw Exception('Erreur d\'inscription: ${e.message}');
      }
    } catch (e) {
      throw Exception('Erreur inattendue: $e');
    }
  }

  // Récupérer le profil utilisateur depuis Firestore
  Future<UserModel?> getUserProfile(String uid) async {
    try {
      print('📥 Récupération du profil utilisateur: $uid');

      final doc = await _db.collection('users').doc(uid).get();

      if (!doc.exists) {
        print('⚠️ Document utilisateur inexistant pour UID: $uid');
        return null;
      }

      final data = doc.data();
      if (data == null) {
        print('⚠️ Données utilisateur nulles pour UID: $uid');
        return null;
      }

      print('✅ Profil utilisateur récupéré: ${data['email']}');
      return UserModel.fromFirestore(data, uid);
    } catch (e) {
      print('❌ Erreur récupération profil: $e');
      if (e.toString().contains('permission')) {
        throw Exception('Erreur de permissions. Impossible de lire votre profil.');
      }
      throw Exception('Erreur de récupération du profil: $e');
    }
  }

  // Stream du profil utilisateur
  Stream<UserModel?> getUserProfileStream(String uid) {
    print('📡 Stream profil utilisateur: $uid');
    return _db.collection('users').doc(uid).snapshots().map((doc) {
      if (!doc.exists || doc.data() == null) {
        print('⚠️ Document utilisateur inexistant dans stream');
        return null;
      }
      return UserModel.fromFirestore(doc.data()!, uid);
    });
  }

  // Réinitialisation du mot de passe
  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email.trim());
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'user-not-found':
          throw Exception('Aucun utilisateur trouvé avec cet email');
        case 'invalid-email':
          throw Exception('Email invalide');
        default:
          throw Exception('Erreur: ${e.message}');
      }
    } catch (e) {
      throw Exception('Erreur inattendue: $e');
    }
  }

  // Déconnexion
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      throw Exception('Erreur de déconnexion: $e');
    }
  }

  // Vérifier si l'utilisateur est connecté
  bool get isLoggedIn => _auth.currentUser != null;
}

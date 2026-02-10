import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();

  UserModel? _currentUserProfile;
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  UserModel? get currentUserProfile => _currentUserProfile;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _authService.isLoggedIn;
  User? get currentUser => _authService.currentUser;

  // Stream de l'état d'authentification
  Stream<User?> get authStateChanges => _authService.authStateChanges;

  // Initialiser le provider et écouter les changements d'auth
  AuthProvider() {
    _authService.authStateChanges.listen((User? user) async {
      if (user != null) {
        await _loadUserProfile(user.uid);
      } else {
        _currentUserProfile = null;
        notifyListeners();
      }
    });
  }

  // Charger le profil utilisateur
  Future<void> _loadUserProfile(String uid) async {
    try {
      _currentUserProfile = await _authService.getUserProfile(uid);
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  // Connexion
  Future<bool> signIn(String email, String password) async {
    _setLoading(true);
    _errorMessage = null;

    try {
      await _authService.signIn(email, password);
      _setLoading(false);
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _setLoading(false);
      return false;
    }
  }

  // Inscription
  Future<bool> signUp({
    required String email,
    required String password,
    required String nom,
    required String prenom,
    required UserRole role,
    String? matricule,
    String? departement,
  }) async {
    _setLoading(true);
    _errorMessage = null;

    try {
      await _authService.signUp(
        email: email,
        password: password,
        nom: nom,
        prenom: prenom,
        role: role,
        matricule: matricule,
        departement: departement,
      );
      _setLoading(false);
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _setLoading(false);
      return false;
    }
  }

  // Réinitialisation du mot de passe
  Future<bool> resetPassword(String email) async {
    _setLoading(true);
    _errorMessage = null;

    try {
      await _authService.resetPassword(email);
      _setLoading(false);
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _setLoading(false);
      return false;
    }
  }

  // Déconnexion
  Future<void> signOut() async {
    _setLoading(true);
    try {
      await _authService.signOut();
      _currentUserProfile = null;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
    } finally {
      _setLoading(false);
    }
  }

  // Helper pour gérer l'état de chargement
  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  // Effacer le message d'erreur
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}


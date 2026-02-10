import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../models/user_model.dart';
import 'login_screen.dart';
import 'prof_home_screen.dart';
import 'student_home_screen.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();

    return StreamBuilder(
      stream: authProvider.authStateChanges,
      builder: (context, snapshot) {
        // Loading
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        // Non connecté
        if (!snapshot.hasData || snapshot.data == null) {
          return const LoginScreen();
        }

        // Connecté - charger le profil
        final userProfile = authProvider.currentUserProfile;

        // Attendre le chargement du profil
        if (userProfile == null) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        // Rediriger selon le rôle
        switch (userProfile.role) {
          case UserRole.prof:
            return const ProfHomeScreen();
          case UserRole.etudiant:
            return const StudentHomeScreen();
        }
      },
    );
  }
}

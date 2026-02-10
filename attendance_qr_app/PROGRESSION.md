# Progression du projet - Plateforme de Presence QR

Derniere mise a jour : session actuelle

---

## Ce qui est fait

### Backend / Services
- Modeles de donnees : UserModel, ScheduleModel, AttendanceModel (lib/models/)
- Service d'authentification Firebase (lib/services/auth_service.dart)
- Service Firestore pour les operations CRUD (lib/services/firestore_service.dart)
- Provider d'authentification avec gestion d'etat (lib/providers/auth_provider.dart)
- Regles de securite Firestore deployees sur Firebase (firestore.rules)

### Configuration Firebase
- Projet Firebase "attendance-qr-upc" configure
- Authentication Email/Password active
- Cloud Firestore en mode production avec regles de securite
- Comptes de test crees : prof@upc.cd et etudiant@upc.cd (Password123!)
- Collections Firestore : users, schedules, attendances

### Ecrans de base
- Ecran de connexion avec formulaire email/mot de passe (lib/screens/login_screen.dart)
- AuthWrapper : redirection automatique selon le role prof/etudiant (lib/screens/auth_wrapper.dart)
- Dashboard professeur avec carte de profil (lib/screens/prof_home_screen.dart)
- Dashboard etudiant avec bouton scan QR (lib/screens/student_home_screen.dart)

### Structure du projet
- main.dart configure avec Firebase, Provider et navigation
- firebase_options.dart en place (placeholder, a completer si necessaire)
- pubspec.yaml avec toutes les dependances (firebase_core, firebase_auth, cloud_firestore, qr_flutter, mobile_scanner, provider)

---

## Ce qui reste a faire

### Ecrans manquants
- Ecran de creation de seance (professeur) : formulaire cours + generation QR
- Ecran de scan QR (etudiant) : camera + lecture du code QR
- Ecran historique des presences (etudiant)
- Ecran liste des presences par seance (professeur)

### Fonctionnalites
- Generation du QR code avec token unique par seance
- Scan et validation du QR code cote etudiant
- Enregistrement de la presence dans Firestore
- Affichage de l'historique des presences
- Export ou consultation des listes de presence

### A finaliser
- Remplacer les valeurs placeholder dans firebase_options.dart si besoin
- Tests unitaires et d'integration
- Gestion des erreurs avancee (timeout, hors ligne)
- Interface utilisateur : ameliorations visuelles

---

## Estimation

Le backend est fait a environ 90%. Le frontend (ecrans et navigation) est a environ 30%.
Les fonctionnalites coeur (generation QR + scan + enregistrement presence) restent a implementer.

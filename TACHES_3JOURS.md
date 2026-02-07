# Taches par Personne - 3 Jours (Firebase + Flutter)

Voici qui fait quoi. Pas le temps de niaiser.

Stack: Firebase + Flutter (bye Symfony)

---

## JOUR 1 - Firebase Setup + Auth

### Dev 1 - Lead Firebase

Matin:
- [ ] Créer projet sur Firebase Console (https://console.firebase.google.com)
- [ ] Nom: "attendance-qr-upc" ou similaire
- [ ] Activer Authentication → Email/Password
- [ ] Créer Firestore Database → Mode Test (pour l'instant)
- [ ] Télécharger google-services.json pour Android
- [ ] Télécharger GoogleService-Info.plist pour iOS

Aprem:
- [ ] Créer 2 users manuellement dans Authentication:
  - prof@upc.cd / password123
  - etudiant@upc.cd / password123
- [ ] Créer documents dans collection users (voir structure)
- [ ] Aider Dev 2 avec les Firestore Rules
- [ ] Aider équipe mobile avec config Firebase

### Dev 2 - Firebase Security

Matin:
- [ ] Apprendre Firestore Rules (doc Firebase)
- [ ] Créer structure collections dans Firestore:
  - users (uid, email, nom, prenom, role)
  - schedules (vide pour l'instant)
  - attendances (vide pour l'instant)

Aprem:
- [ ] Écrire Firestore Rules basiques (mode test étendu)
- [ ] Permettre lecture si authentifié
- [ ] Tester dans Rules Playground
- [ ] Documenter la structure dans un fichier .md

### Dev 3 - Lead Mobile

Matin:
- [ ] flutter create mobile
- [ ] cd mobile
- [ ] flutter pub add firebase_core firebase_auth cloud_firestore
- [ ] flutter pub add provider qr_flutter mobile_scanner
- [ ] Placer google-services.json dans android/app/
- [ ] Placer GoogleService-Info.plist dans ios/Runner/

Aprem:
- [ ] Configurer Firebase dans main.dart (Firebase.initializeApp())
- [ ] Créer lib/services/auth_service.dart (squelette)
- [ ] Créer lib/services/firestore_service.dart (squelette)
- [ ] Setup Provider dans main.dart
- [ ] Tester que Firebase se connecte (flutter run)

### Dev 4 - Auth Integration

Matin:
- [ ] Créer lib/services/auth_service.dart
- [ ] Méthodes: signIn(email, password)
- [ ] signOut()
- [ ] Stream<User?> get authStateChanges

Aprem:
- [ ] Tester signIn avec prof@upc.cd
- [ ] Vérifier dans Firebase Console que ça marche
- [ ] Créer Provider AuthProvider
- [ ] Gérer loading states
- [ ] Tester end-to-end avec UI Login (Dev 5)

### Dev 5 - UI Login

Matin:
- [ ] Créer lib/screens/login_screen.dart
- [ ] TextField email
- [ ] TextField password (obscureText: true)
- [ ] ElevatedButton "Se connecter"
- [ ] Wireframe basique Material Design

Aprem:
- [ ] Connecter avec AuthService (Dev 4)
- [ ] Afficher erreurs avec SnackBar
- [ ] Loading indicator pendant connexion
- [ ] Navigation après login (prof_home vs student_home)
- [ ] Tester avec users Firebase

### Dev 6 - Interface Prof

Matin:
- [ ] Créer lib/screens/prof_home_screen.dart
- [ ] AppBar avec titre "Prof Dashboard"
- [ ] FloatingActionButton "+"
- [ ] Wireframe liste séances (vide pour l'instant)

Aprem:
- [ ] Créer lib/screens/create_schedule_screen.dart
- [ ] TextField nomCours
- [ ] Button "Créer et générer QR"
- [ ] Navigation vers cette page
- [ ] Design basique propre

### Dev 7 - Scanner QR Étudiant

Matin:
- [ ] Créer lib/screens/student_home_screen.dart
- [ ] AppBar "Étudiant Dashboard"
- [ ] Button "Scanner QR"
- [ ] Config permissions caméra:
  - AndroidManifest.xml: CAMERA permission
  - Info.plist (iOS): NSCameraUsageDescription

Aprem:
- [ ] Créer lib/screens/scan_qr_screen.dart
- [ ] Intégrer mobile_scanner
- [ ] Tester scan basique (n'importe quel QR)
- [ ] Afficher résultat scan dans console
- [ ] Fix bugs permissions

### Dev 8 - Firestore CRUD Service

Matin:
- [ ] Créer lib/services/firestore_service.dart
- [ ] Méthode createSchedule(nomCours, qrToken, userId)
- [ ] Structure: voir PLAN_MVP.md

Aprem:
- [ ] Méthode getScheduleByQrToken(token)
- [ ] Méthode markAttendance(scheduleId, userId, userName)
- [ ] Méthode getAttendancesBySchedule(scheduleId)
- [ ] Tester depuis Dev Tools / console

### Dev 9 - Navigation & UI

Matin:
- [ ] Setup routes dans main.dart
- [ ] MaterialApp avec initialRoute
- [ ] Theme basique (primaryColor, etc.)

Aprem:
- [ ] Navigation entre écrans (login → home)
- [ ] Logout button dans AppBar
- [ ] LoadingIndicator widget réutilisable
- [ ] SnackBar helper pour messages

### Dev 10 - QA & Documentation

Toute la journée:
- [ ] Documenter structure Firestore dans un .md
- [ ] Créer checklist tests manuels
- [ ] Tester login dès que dispo
- [ ] Noter tous les bugs dans BUGS.txt
- [ ] Préparer scénario de démo (draft)
- [ ] Aider à debug

**FIN JOUR 1:** Login fonctionne Firebase → Flutter, navigation OK.

---

## JOUR 2 - QR Code Flow

### Dev 1 - Lead Firebase

Matin:
- [ ] Vérifier que Firestore est prêt
- [ ] Créer index Firestore si besoin (schedules.qrToken)
- [ ] Monitorer usage dans console

Aprem:
- [ ] Aider Debug problèmes Firestore
- [ ] Optimiser queries si lent
- [ ] Support équipe mobile

### Dev 2 - Firestore Security Rules

Matin:
- [ ] Rules: schedules créables seulement par PROF
- [ ] attendances créables par étudiants
- [ ] Test Rules Playground

Aprem:
- [ ] Passer Firestore en mode "production" avec rules
- [ ] Tester avec différents users
- [ ] Documenter les règles

### Dev 3 - Lead Mobile

Matin:
- [ ] Coordonner équipe
- [ ] S'assurer que tout le monde avance
- [ ] Debug problèmes critiques

Aprem:
- [ ] Intégration features QR
- [ ] Tester flow complet
- [ ] Fix bugs bloquants

### Dev 4 - Auth + État App

Matin:
- [ ] Améliorer gestion session
- [ ] Logout functionality
- [ ] Persist auth avec Firebase

Aprem:
- [ ] Aider Dev 8 avec Firestore queries
- [ ] Gérer erreurs auth
- [ ] Tests multi-users

### Dev 5 - UI Login Polish

Matin:
- [ ] Améliorer UI login (design)
- [ ] Validation email/password
- [ ] Messages d'erreur clairs

Aprem:
- [ ] Aider Dev 6 et Dev 7
- [ ] Tests UI
- [ ] Fix bugs visuels

### Dev 6 - Interface Prof (QR Generation)

Matin:
- [ ] Finir create_schedule_screen.dart
- [ ] Générer qrToken: Random().nextInt(999999).toString()
- [ ] Appeler firestoreService.createSchedule()
- [ ] Récupérer scheduleId

Aprem:
- [ ] Afficher QR avec qr_flutter
- [ ] Package qr_flutter: QrImageView(data: qrToken)
- [ ] Page fullscreen pour afficher QR
- [ ] Tester que schedule s'enregistre dans Firestore

### Dev 7 - Scanner QR Étudiant

Matin:
- [ ] Finir scan_qr_screen.dart
- [ ] mobile_scanner: MobileScannerController
- [ ] Capturer le qrToken scanné

Aprem:
- [ ] Appeler firestoreService.getScheduleByQrToken(token)
- [ ] Si schedule existe: markAttendance()
- [ ] Messages succès/erreur
- [ ] Tester avec QR réel généré par Dev 6

### Dev 8 - Firestore Service (suite)

Matin:
- [ ] Implémenter toutes les méthodes Firestore
- [ ] createSchedule() - ajouter doc dans collection
- [ ] getScheduleByQrToken() - query where qrToken ==
- [ ] markAttendance() - ajouter doc attendances

Aprem:
- [ ] getAttendancesBySchedule() - liste présents
- [ ] Gérer erreurs Firestore
- [ ] Vérifier doublons (try/catch si déjà présent)
- [ ] Tester queries dans console

### Dev 9 - UI Liste Présences

Matin:
- [ ] Créer lib/screens/attendance_list_screen.dart
- [ ] StreamBuilder<QuerySnapshot> pour temps réel
- [ ] ListView des présents

Aprem:
- [ ] Design liste (ListTile avec nom + heure)
- [ ] Tri par timestamp
- [ ] Pull to refresh (optionnel)
- [ ] Tester avec données réelles

### Dev 10 - QA

Toute la journée:
- [ ] Tester création schedule
- [ ] Tester génération QR
- [ ] Tester scan QR
- [ ] Tester enregistrement présence
- [ ] Vérifier données dans Firestore Console
- [ ] Noter bugs critiques
- [ ] Prioriser fixes

**FIN JOUR 2:** Flow QR complet fonctionne (prof crée → QR → étudiant scanne → présence enregistrée).

---

## JOUR 3 - Polish + Démo

### Dev 1 & 2 - Firebase Final

Matin:
- [ ] Vérifier Firestore Rules finales (pas de faille)
- [ ] Optimiser index si queries lentes
- [ ] Backup structure Firestore (export)

Aprem:
- [ ] Monitoring Firebase pendant tests
- [ ] S'assurer quotas OK (gratuits)
- [ ] Support debugging final

### Dev 3 - Lead Mobile Final

Toute la journée:
- [ ] Coordonner polish final
- [ ] Build APK debug puis release
- [ ] Tests sur vrais téléphones
- [ ] Fix bugs critiques
- [ ] Démo preparation

### Dev 4 & 5 - Auth + Login Final

Matin:
- [ ] UI login parfait
- [ ] Gestion erreurs complète
- [ ] Loading states propres

Aprem:
- [ ] Tests multi-users
- [ ] Logout partout
- [ ] Session persistence OK

### Dev 6 - Interface Prof Final

Matin:
- [ ] Page liste des séances créées (optionnel si temps)
- [ ] Améliorer UI QR display
- [ ] Boutons clairs

Aprem:
- [ ] Tests création multiples séances
- [ ] UI polish
- [ ] Feedback utilisateur (SnackBars)

### Dev 7 - Scanner Final

Matin:
- [ ] Améliorer feedback scan (vibration, son)
- [ ] Gérer cas QR invalide (token inexistant)
- [ ] Gérer cas déjà scanné (doublon)

Aprem:
- [ ] Messages d'erreur clairs (français)
- [ ] UI scanner propre
- [ ] Tests edge cases

### Dev 8 - Firestore Queries Final

Matin:
- [ ] Optimiser getAttendancesBySchedule (inclure nom user)
- [ ] Cache queries si possible
- [ ] Gérer erreurs réseau

Aprem:
- [ ] Tests performance
- [ ] Pagination si liste longue (optionnel)
- [ ] Documentation code

### Dev 9 - UI/UX Polish

Matin:
- [ ] Design cohérent Material Design
- [ ] Colors/Fonts propres
- [ ] Loading partout où nécessaire
- [ ] Navigation fluide

Aprem:
- [ ] Tests UX complets
- [ ] Screenshots pour démo
- [ ] Animations basiques (optionnel)

### Dev 10 - QA & Démo

Matin:
- [ ] Tests COMPLETS du scénario de démo
- [ ] Écrire scénario exact (étape par étape)
- [ ] Préparer 2-3 slides PowerPoint
- [ ] Créer données de test propres

Aprem:
- [ ] RÉPÉTITION démo avec toute l'équipe
- [ ] Chronométrer (max 5 min)
- [ ] Identifier ce qui peut bugger
- [ ] Fixes dernière minute
- [ ] Build APK release final

**LIVRABLES JOUR 3:**
- [ ] APK release signé
- [ ] README.md à jour
- [ ] Slides démo
- [ ] Scénario démo écrit
- [ ] Code push sur GitHub
- [ ] Démo prête et testée

**C'EST FINI !** 🎉

- [ ] if (role == 'ETUDIANT') → student_home
- [ ] Bouton logout

### Dev 9 - DevOps

Matin:
- [ ] Installer XAMPP ou WAMP
- [ ] Créer BDD "attendance_db"
- [ ] S'assurer que PHP 8.1+ tourne
- [ ] Tester symfony server:start

Aprem:
- [ ] Configurer le réseau local (si tests sur phones)
- [ ] Créer collection Postman avec les endpoints
- [ ] Partager collection avec l'équipe
- [ ] Initialiser repo GitHub

### Dev 10 - QA

Toute la journée:
- [ ] Documenter les endpoints (format JSON)
- [ ] Tester login avec Postman dès que dispo
- [ ] Tester création schedule
- [ ] Noter tous les bugs dans un fichier BUGS.txt
- [ ] Aider à debug

FIN JOUR 1: Login fonctionne, on peut créer une schedule basique.

---

## JOUR 2 

### Dev 1 - Lead Backend

Matin:
- [ ] composer require endroid/qr-code
- [ ] Apprendre à générer un QR code basique

Aprem:
- [ ] Modifier /api/schedule/create pour générer image QR
- [ ] Encoder le qr_token dans le QR
- [ ] Retourner image en base64
- [ ] Tester que ça marche

### Dev 2 - Backend QR Validation

Matin:
- [ ] Aider Dev 1 avec endroid/qr-code

Aprem:
- [ ] POST /api/qr/validate {qr_token}
- [ ] Chercher schedule avec ce token
- [ ] Si existe: return {success: true, schedule_id}
- [ ] Sinon: return {success: false, message: "QR invalide"}

### Dev 3 & 4 - Backend Attendance

Matin:
- [ ] Finaliser endpoint POST /api/attendance/mark
- [ ] Vérifier que schedule existe
- [ ] Vérifier que user existe
- [ ] Tester le UNIQUE constraint (double scan)

Aprem:
- [ ] Améliorer GET /api/schedule/{id}/attendances
- [ ] Retourner [{nom, created_at}]
- [ ] Tester avec données multiples
- [ ] Optimiser les requêtes si lent

### Dev 5 - Lead Mobile

Matin:
- [ ] flutter pub add qr_flutter mobile_scanner
- [ ] Configurer permissions caméra (Android: AndroidManifest.xml)
- [ ] Configurer permissions caméra (iOS: Info.plist)

Aprem:
- [ ] Créer QrService
- [ ] Tester scan de base
- [ ] Fix problèmes de permissions
- [ ] Gérer les erreurs

### Dev 6 - Mobile Prof Create Schedule

Matin:
- [ ] Créer lib/screens/create_schedule_screen.dart
- [ ] TextField pour nom de la séance
- [ ] Button "Créer"

Aprem:
- [ ] Appeler POST /api/schedule/create
- [ ] Recevoir QR en base64
- [ ] Afficher QR avec qr_flutter
- [ ] Page fullscreen pour le QR
- [ ] Tester avec vrai backend

### Dev 7 - Mobile Student Scanner

Matin:
- [ ] Créer lib/screens/scan_qr_screen.dart
- [ ] Utiliser MobileScanner widget

Aprem:
- [ ] Quand QR détecté: extraire le token
- [ ] Appeler POST /api/qr/validate
- [ ] Si OK: appeler POST /api/attendance/mark
- [ ] Afficher "Présence enregistrée" (Dialog ou SnackBar)
- [ ] Tester end-to-end

### Dev 8 - Mobile Attendance List

Matin:
- [ ] Créer lib/screens/attendance_list_screen.dart (prof)
- [ ] Dropdown pour sélectionner schedule

Aprem:
- [ ] Appeler GET /api/schedule/{id}/attendances
- [ ] Afficher liste dans ListView
- [ ] Auto-refresh toutes les 5 sec avec Timer
- [ ] Afficher nombre présents

### Dev 9 - DevOps

Toute la journée:
- [ ] S'assurer que le backend tourne sans couper
- [ ] Monitorer les logs Symfony
- [ ] Vérifier que la BDD se remplit correctement
- [ ] Aider mobile avec problèmes réseau
- [ ] Préparer laptop pour démo (installer APK)

### Dev 10 - QA

Toute la journée:
- [ ] Tester TOUT le flow:
  - Login prof
  - Créer séance
  - QR s'affiche
  - Login étudiant
  - Scanner QR
  - Présence enregistrée
  - Retour prof, voir liste
- [ ] Noter TOUS les bugs
- [ ] Prioriser bugs critiques
- [ ] Vérifier données BDD

FIN JOUR 2: Le flow complet marche au moins une fois.

---

## JOUR 3

### MATIN: FINITIONS

Tous Backend:
- [ ] Corriger bugs critiques
- [ ] Empêcher double scan (bien vérifier)
- [ ] Améliorer messages d'erreur
- [ ] S'assurer que rien plante

Tous Mobile:
- [ ] Corriger UI qui bug
- [ ] Améliorer messages (français, clairs)
- [ ] Tester sur vrai phone Android
- [ ] Fix permissions caméra si problème

Dev 9:
- [ ] Build APK: flutter build apk --debug
- [ ] Installer sur 2-3 phones de test
- [ ] Créer données de test clean en BDD
- [ ] Backup BDD

Dev 10:
- [ ] Créer PowerPoint (3 slides max)
- [ ] Écrire scénario démo détaillé
- [ ] Chronométrer démo (max 5 min)

### APREM: RÉPÉTITION DÉMO

Tout le monde:
- [ ] Nettoyer BDD (supprimer données de test moches)
- [ ] Insérer 1 prof + 3 étudiants propres
- [ ] Répéter la démo 3 fois
- [ ] Chronométrer à chaque fois
- [ ] Noter ce qui plante

### APREM (suite): DERNIERS FIXES

- [ ] Corriger ce qui plante pendant démo
- [ ] Simplifier si trop compliqué
- [ ] Préparer plan B (si scanner plante: taper token manuellement)
- [ ] Tester plan B

### SOIR: FINALISATION

- [ ] Push final sur GitHub (code + BDD dump)
- [ ] README.md avec instructions ultra basiques
- [ ] APK copié sur clé USB (backup)
- [ ] PowerPoint finalisé
- [ ] Laptop chargé
- [ ] Phone de démo chargé
- [ ] Respirer

---

## Checklist Critique Jour 3 Avant Démo

Si UN de ces trucs marche pas, on panique:

- [ ] Backend API répond (teste http://localhost:8000/api/login)
- [ ] Login prof fonctionne sur l'app
- [ ] Créer séance génère un QR
- [ ] QR s'affiche en grand
- [ ] Login étudiant fonctionne
- [ ] Scanner QR détecte le code (ou plan B ready)
- [ ] Présence s'enregistre (vérifie en BDD)
- [ ] Liste présences affiche au moins 1 nom
- [ ] APK installé sur phone de démo
- [ ] PowerPoint chargé
- [ ] Code sur GitHub

---

## Rappels Importants

1. PAS de nouvelles features après le jour 2
2. Jour 3 = polish + répétitions uniquement  
3. Si bloqué >30 min, crier à l'aide
4. Commit TOUTES les heures minimum
5. Tester après CHAQUE modification
6. Hardcoder c'est OK (on n'est pas jugés sur le code)
7. Simplifie au max (delete features si besoin)

---

Voilà. C'est serré mais faisable.

Tout le monde doit connaître son rôle.
Tout le monde aide si quelqu'un bloque.
On se fait confiance.

Bon courage.

-- Kevin

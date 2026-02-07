# Plan Version Beta - Plateforme de Présence QR Code

Salut l'équipe,

On a 3 JOURS. Pas 3 semaines, 3 JOURS.

Donc on oublie tout ce qui est fancy. On fait le strict minimum qui démontre que le concept marche.

Équipe: 10 développeurs  
Stack: **Firebase + Flutter** (bye bye Symfony)  
Deadline: 3 JOURS (72 heures)

---

## L'objectif - Version Ultra Minimaliste

3 jours = on fait UN SEUL flow qui marche de bout en bout.

CE QU'ON FAIT (le strict minimum):
1. Login basique (hardcodé en BDD si faut)
2. Un prof peut créer une séance = génère un QR code
3. Un étudiant scanne le QR = ça enregistre sa présence
4. Une page qui liste qui était présent

C'est TOUT. Le reste on s'en fout.

CE QU'ON NE FAIT PAS (liste non exhaustive):
- Dashboard fancy
- Export CSV (on verra si on a le temps)
- Gestion complète des users
- Statistiques
- Graphiques
- Notifications
- Géolocalisation
- Validation complexe
- Tests unitaires (si temps)
- Documentation complète
- Interface admin
- Multi-rôles avancé
- Backend API custom (Firebase fait tout)

On fait juste un PROOF OF CONCEPT qui marche.

---

## Organisation de l'Équipe (10 personnes)

### Squad Firebase - 2 personnes
Les plus à l'aise avec Firebase ou qui apprennent vite.

**Dev 1 - Lead Firebase**
- Créer projet Firebase Console
- Activer Authentication (Email/Password)
- Créer Firestore database (mode test)
- Structurer collections (users, schedules, attendances)
- Setup Firebase config pour Flutter

**Dev 2 - Firebase Security**  
- Écrire Firestore Security Rules
- Tester les permissions
- Setup Cloud Functions (si vraiment nécessaire)
- Créer des users de test manuellement

### Squad Flutter - 8 personnes
Tous sur Flutter, c'est plus efficace.

**Dev 3 - Lead Mobile**
- Setup Flutter project
- Architecture navigation
- Firebase SDK integration (firebase_core, firebase_auth)
- State management (Provider)
- Coordination équipe mobile

**Dev 4 - Auth Integration**
- Service Firebase Auth
- Login/Logout
- Gestion session user
- Persistence auth state

**Dev 5 - UI Login**
- Écran login
- Formulaire email/password
- Loading states
- Error handling

**Dev 6 - Interface Prof**
- Dashboard prof
- Créer séance (Firestore)
- Générer QR code (qr_flutter)
- Afficher QR fullscreen

**Dev 7 - Scanner QR Étudiant**
- Écran scan QR (mobile_scanner)
- Permissions caméra
- Parser QR token
- Appeler Firestore pour valider

**Dev 8 - Firestore CRUD**
- Service Firestore wrapper
- CRUD schedules
- CRUD attendances
- Queries (lister présences)

**Dev 9 - UI/UX Polish**
- Navigation entre écrans
- Design basique mais propre
- Loading indicators
- SnackBars erreurs/succès

**Dev 10 - QA & Tests**
- Tests manuels complets
- Documentation bugs
- Scénario de démo
- Tests sur plusieurs devices

---

## Structure Firestore - ULTRA Minimaliste

3 collections. Point.

### Collection: users
```javascript
{
  uid: "firebase_auth_uid",      // Auto-généré par Firebase Auth
  email: "prof@upc.cd",
  nom: "Kabongo",
  prenom: "Jean",
  role: "PROF" | "ETUDIANT"
}
```

### Collection: schedules
```javascript
{
  id: "auto_generated_doc_id",   // Auto par Firestore
  nomCours: "Mathématiques Info",
  createdBy: "user_uid",          // Référence au prof
  dateHeure: Timestamp,
  qrToken: "123456",              // Random string pour le QR
  qrExpires: Timestamp            // Optionnel pour la beta
}
```

### Collection: attendances
```javascript
{
  id: "auto_generated_doc_id",
  scheduleId: "schedule_doc_id",
  userId: "user_uid",
  userName: "Mukendi Pierre",     // Denormalized pour perfs
  timestamp: Timestamp
}
```

**Index Firestore:**
- attendances: (scheduleId, userId) pour éviter doublons
- schedules: (qrToken) pour recherche rapide

TERMINÉ. Pas de collection de plus.

---

## Planning - 3 Jours Chrono

### JOUR 1 : Firebase Setup + Auth

MATIN:

Firebase Lead (Dev 1):
- [ ] Créer projet Firebase Console
- [ ] Activer Authentication (Email/Password)
- [ ] Créer Firestore database (mode test au début)
- [ ] Créer collections: users, schedules, attendances
- [ ] Télécharger google-services.json + GoogleService-Info.plist

Firebase Security (Dev 2):
- [ ] Apprendre Firestore Rules basiques
- [ ] Créer 2 users de test manuellement (1 prof, 1 étudiant)
- [ ] Ajouter documents dans collection users
- [ ] Tester lecture/écriture dans Firestore Console

Mobile Lead (Dev 3):
- [ ] flutter create mobile
- [ ] flutter pub add firebase_core firebase_auth cloud_firestore
- [ ] flutter pub add provider qr_flutter mobile_scanner
- [ ] Placer google-services.json dans android/app/
- [ ] Config Firebase dans main.dart

Auth Dev (Dev 4):
- [ ] Créer lib/services/auth_service.dart
- [ ] Méthodes: signIn(), signOut(), getCurrentUser()
- [ ] Provider pour auth state

UI Login (Dev 5):
- [ ] Créer lib/screens/login_screen.dart
- [ ] TextField email + password
- [ ] Button "Se connecter"
- [ ] Wireframe basique

UI Prof (Dev 6):
- [ ] Créer lib/screens/prof_home_screen.dart (vide)
- [ ] AppBar avec titre
- [ ] Wireframe sur papier

Scanner Dev (Dev 7):
- [ ] Créer lib/screens/student_home_screen.dart (vide)
- [ ] Config permissions caméra (AndroidManifest.xml)
- [ ] Tester mobile_scanner basique

Firestore Service (Dev 8):
- [ ] Créer lib/services/firestore_service.dart
- [ ] Structure méthodes: createSchedule(), getSchedules(), markAttendance()

UI/UX (Dev 9):
- [ ] Setup navigation (routes)
- [ ] Theme basique (colors, fonts)
- [ ] Tester navigation entre écrans

QA (Dev 10):
- [ ] Documenter structure Firestore
- [ ] Créer checklist tests
- [ ] Préparer scénario de démo

APREM:

Tout le monde:
- [ ] Intégrer Firebase Auth dans l'app
- [ ] TESTER login end-to-end (email/password)
- [ ] Vérifier que user connecte dans Firebase Console
- [ ] Navigation prof vs étudiant après login
- [ ] Commit sur GitHub

FIN JOUR 1: Login fonctionne, Firebase connecté, navigation de base OK.

---

### JOUR 2 : QR Code Flow

MATIN:

UI Prof (Dev 6):
- [ ] Écran "Créer Séance" (TextField nom + bouton)
- [ ] Appeler Firestore pour créer schedule
- [ ] Générer qrToken random: Random().nextInt(999999).toString()
- [ ] Afficher QR avec qr_flutter

Scanner Dev (Dev 7):
- [ ] Écran scan QR complet avec mobile_scanner
- [ ] Parser le qrToken depuis QR
- [ ] Chercher schedule dans Firestore avec ce token
- [ ] Si trouvé: appeler markAttendance()

Firestore Service (Dev 8):
- [ ] Implémenter createSchedule(nom, qrToken, userId)
- [ ] Implémenter getScheduleByQrToken(token)
- [ ] Implémenter markAttendance(scheduleId, userId)
- [ ] Vérifier UNIQUE constraint (éviter double scan)

Firebase Security (Dev 2):
- [ ] Écrire Firestore Rules pour schedules
- [ ] Écrire Firestore Rules pour attendances
- [ ] Tester que seuls profs peuvent créer schedules
- [ ] Tester que étudiants peuvent marquer présence

UI/UX (Dev 9):
- [ ] Page liste présences par schedule
- [ ] StreamBuilder pour temps réel
- [ ] Loading states
- [ ] Messages succès/erreur

Auth Dev (Dev 4):
- [ ] Améliorer gestion erreurs Auth
- [ ] Logout functionality
- [ ] Persist auth state

Lead Mobile (Dev 3) + Lead Firebase (Dev 1):
- [ ] Aider tout le monde
- [ ] Débugger les problèmes
- [ ] Optimiser queries Firestore
- [ ] Fix les bugs critiques

QA (Dev 10):
- [ ] Tester création schedule
- [ ] Tester scan QR
- [ ] Tester enregistrement présence
- [ ] Noter tous les bugs

APREM:

Tout le monde:
- [ ] TESTER le flow complet: créer séance → QR → scan → présence enregistrée
- [ ] Vérifier données dans Firestore Console
- [ ] Corriger bugs bloquants
- [ ] Améliorer UI si temps
- [ ] Commit sur GitHub

FIN JOUR 2: Flow QR complet fonctionne (prof crée → étudiant scanne → présence enregistrée).

---

### JOUR 3 : Polish + Démo

MATIN:

Firestore Service (Dev 8):
- [ ] getAttendancesBySchedule(scheduleId) avec JOIN users
- [ ] Optimiser queries (index si besoin)
- [ ] Cache local si lent

UI Liste Présences (Dev 6 + Dev 9):
- [ ] Écran liste présences par séance
- [ ] Afficher nom + timestamp
- [ ] Tri par ordre alphabétique ou timestamp
- [ ] UI propre

Scanner + Auth (Dev 7 + Dev 4):
- [ ] Améliorer feedback scan (succès/erreur)
- [ ] Gérer cas QR invalide
- [ ] Gérer cas déjà scanné
- [ ] Messages clairs

Firebase Security (Dev 2):
- [ ] Passer Firestore en mode production (rules strictes)
- [ ] Vérifier toutes les permissions
- [ ] Tester avec différents users

Lead Mobile + Lead Firebase (Dev 3 + Dev 1):
- [ ] Débugger problèmes critiques
- [ ] Optimiser performance
- [ ] Aider les autres

QA (Dev 10):
- [ ] Tests complets du flow démo
- [ ] Écrire scénario de démo (5 min max)
- [ ] Préparer 2-3 slides PowerPoint basiques
- [ ] Noter bugs bloquants

APREM:

Mobile Dev tous:
- [ ] Build APK debug
- [ ] Tester sur vrais téléphones Android
- [ ] Fix problèmes permissions caméra
- [ ] UI cleanup final

RÉPÉTITION DÉMO:
- [ ] Tout le monde teste le scénario
- [ ] Chronométrer (max 5 min)
- [ ] Identifier ce qui peut planter

FIXES DERNIÈRE MINUTE:
- [ ] Corriger ce qui plante pendant la démo
- [ ] Simplifier si nécessaire
- [ ] Enlever features qui bug

PRÉPARATION FINALE:
- [ ] Build APK release final
- [ ] README basique
- [ ] Push final sur GitHub
- [ ] Respirer

DELIVERABLE: App déployée, APK prêt, démo fonctionnelle.

---

## Stack Technique Firebase

### Backend
```
- Firebase Authentication (Email/Password)
- Cloud Firestore (base de données NoSQL temps réel)
- Firebase Console (administration)
- Firestore Security Rules (permissions)
```

### Frontend  
```
- Flutter 3.x
- firebase_core (SDK Firebase)
- firebase_auth (authentification)
- cloud_firestore (accès BDD)
- mobile_scanner (scan QR)
- qr_flutter (générer QR)
- provider (state management simple)
```

PAS DE: Backend API custom, serveur, MySQL, JWT manuel, etc.

### Infrastructure
```
- Firebase (hébergement cloud gratuit)
- Git + GitHub (versionning)
```- [ ] Identifier ce qui peut planter

FIXES DERNIÈRE MINUTE
- [ ] Corriger ce qui plante pendant la démo
- [ ] Simplifier si nécessaire

---

## User Stories - Version Beta

On se concentre sur l'essentiel. Version minimaliste.

### Prof
1. Je me connecte avec email/password (Firebase Auth)
2. Je clique "Créer séance"
3. Je tape un nom de cours
4. Un QR code s'affiche (généré côté Flutter)
5. Les étudiants scannent
6. Je vois la liste des présents en temps réel (Firestore Stream)

### Étudiant  
1. Je me connecte avec email/password
2. Je clique "Scanner QR"
3. Je scanne le QR code du prof
4. Message: "Présence enregistrée" (écrit dans Firestore)
5. (Optionnel) Je vois mon historique de présences

UN SEUL FLOW. C'est tout.

### Scénario de Démo (5 minutes max)

1. On se log en tant que PROF (prof@upc.cd)
2. On clique "Créer séance"
3. On tape un nom "Cours de Math"
4. Un QR code s'affiche à l'écran

5. On se délog
6. On se log en tant qu'ÉTUDIANT (etudiant@upc.cd)
7. On clique "Scanner QR"
8. On scanne le QR avec la caméra
9. Message: "Présence enregistrée"

10. On retourne sur le compte PROF
11. On voit la liste: "1 présent - Nom Étudiant" (temps réel!)

FIN.

C'est TOUTE la démo. Rien d'autre.

---

## Règles de Survie - 3 Jours

### Ce qu'on accepte (pour gagner du temps):

- Firebase Auth gère les passwords (hashé automatiquement)
- Pas de validation email (on crée users manuellement)
- Pas d'expiration QR code (si temps on ajoute)
- QR token = juste un random int (123456)
- Firestore en mode test les 2 premiers jours
- Copy-paste de code entre devs (pas grave)
- Hardcoder des trucs (on refactor en prod)
- UI basique Material Design (pas de custom design)

### Ce qu'on NE fait PAS (pas le temps):

- Export CSV/PDF
- Statistiques/Dashboard fancy
- Géolocalisation campus
- Notifications push
- Graphiques
- Mode offline
- Tests unitaires (tests manuels suffisent)
- CI/CD
- Face recognition 😅

C'est un POC en 3 jours, pas une app bancaire.- [ ] Scan RFID(liste longue)

Tout ce qui prend plus de 30 minutes:

- Dashboard fancy
- Export CSV/PDF  
- Gestion users (on les crée en SQL direct)
- Statistiques
- Graphiques
- Multi-filières/promotions
- Interface Admin
- Notifications
- Géolocalisation
- Validation email
- Reset password
- Profil utilisateur
- Paramètres
- Mode sombre

Ce qu'on DOIT avoir:

1. Une démo qui marche (5 min)
   - Login prof
   - Créer séance + QR
   - Login étudiant  
   - Scanner QR
   - Voir liste présences
   
2. Code sur GitHub
   - Même sale, même commenté en français
   - Au moins ça existe

3. APK qui s'installe
   - Même en debug mode
   - Juste pour montrer sur un vrai phone

4. 3 slides PowerPoint
   - Slide 1: Le problème
   - Slide 2: Notre solution
   - Slide 3: La démo

C'est TOUT ce qu'on vise.

5. Démo
   Critères de Réussite

On a gagné SI:

1. Au moment de la démo, on peut faire tourner sans que ça plante
2. Le QR code se génère
3. Le scan fonctionne
4. La présence s'enregistre en BDD
5. On peut voir qui était là

Si UN SEUL de ces 5 points marche pas, on a raté.

Tout le reste (UI jolie, pas de bugs, etc.) c'est du bonusCSV
- LRègles de Survie - 3 Jours

### RÈGLE #1: Pas de perfectionnisme
Premier code qui marche = on garde.
Pas de refactoring, pas d'"on pourrait faire mieux".

### RÈGLE #2: Zéro meetings inutiles
Standup le matin: 5 min debout, pas assis.
Bloqué? Tu cries, on t'aide. Pas de mail.

### RÈGLE #3: Hardcoder c'est OK
Besoin de 2 users de test? Hardcode en SQL.
URL API qui change? Hardcode dans le code.
On optimise APRÈS la démo.

### RÈGLE #4: Copier-coller c'est OK
StackOverflow est ton ami.
GitHub est ton ami.
ChatGPT est ton ami.
On cite les sources plus tard.

### RÈGLE #5: Si ça prend >1h, on skip
Bloqué sur JWT? On fait un token simple.
Scanner QR plante? On tape le token à la main.
BDD qui fait chier? SQLite.
%
### RÈGLE #6: Communication non-stop
Slack/Discord ouvert H24.
Problème? Tu ping immédiatement.
1h sans update = t'es mort.

### RÈGLE #7: Commit toutes les heures
Même si c'est cassé.
Mieux vaut du code sale versionné que du code perdu.

### RÈGLE #8: Dormir (un peu)
VenAPI Endpoints - Liste Minimale

4 endpoints. C'est TOUT.

```
POST /api/login
{email, password}
→ {token, user_id, role}

POST /api/schedule/create  
{nom, user_id}
→ {schedule_id, qr_token, qr_image_base64}

POST /api/qr/scan
{qr_token, user_id}
→ {success: true/false, message}

GET /api/schedule/{id}/attendances
→ [{user_id, nom, created_at}]
```

Pas un endpoint de plus pour la démo.

---

## Check-list Finale Jour 3 Avant Démo

Avant la répétition démo:

- [ ] Backend API répond (teste avec Postman)
- [ ] App compile sans erreur
- [ ] Login fonctionne
- [ ] Création séance fonctionne
- [ ] QR s'affiche
- [ ] Scan QR fonctionne (ou fallback manuel)
- [ ] Présence s'enregistre en BDD
- [ ] Liste présences s'affiche
- [ ] 2 users de test en BDD (prof + étudiant)
- [ ] APK installé sur un phone de test
- [ ] Laptop chargé
- [ ] Code sur GitHub
- [ ] PowerPoint avec 3 slides

Si un truc sur cette liste est pas fait, TOUT LE MONDE aide à le finir.

---

## Message Final

On a 3 jours pour prouver que le concept marche.

C'est faisable SI:
- On reste focus
- On s'entraide
- On code simple
- On teste en continu
- On dort un minimum

Pas de panique. Pas de drama. On se fait confiance.

On commence fort.

Courage l'équipe.

-- Kevin
Temps réel disponible: ~145 jours-homme

Donc faut être efficace. Pas de feature inutile.

---

Voilà le plan. Simple, réaliste, faisable.

On se concentre sur faire marcher les bases correctement plutôt que d'essayer 50 features à moitié finies.

Questions? On en discute.

-- Kevin

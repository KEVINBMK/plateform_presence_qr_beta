import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:uuid/uuid.dart';
import '../providers/auth_provider.dart';
import '../services/firestore_service.dart';

class CreateScheduleScreen extends StatefulWidget {
  const CreateScheduleScreen({super.key});

  @override
  State<CreateScheduleScreen> createState() => _CreateScheduleScreenState();
}

class _CreateScheduleScreenState extends State<CreateScheduleScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nomCoursController = TextEditingController();
  final _firestoreService = FirestoreService();
  
  bool _isLoading = false;
  String? _generatedToken;
  String? _scheduleId;

  @override
  void dispose() {
    _nomCoursController.dispose();
    super.dispose();
  }

  Future<void> _createSchedule() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final authProvider = context.read<AuthProvider>();
      final userId = authProvider.currentUser?.uid;

      if (userId == null) {
        throw Exception('Utilisateur non connecté. Veuillez vous reconnecter.');
      }

      print('🔧 Création de séance par: $userId');

      // Générer un token unique (6 caractères)
      final uuid = const Uuid();
      final token = uuid.v4().substring(0, 6).toUpperCase();

      print('🎲 Token généré: $token');

      // Créer la séance dans Firestore
      final scheduleId = await _firestoreService.createSchedule(
        nomCours: _nomCoursController.text.trim(),
        qrToken: token,
        createdBy: userId,
      );

      print('✅ Séance créée avec succès: $scheduleId');

      setState(() {
        _generatedToken = token;
        _scheduleId = scheduleId;
        _isLoading = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✅ Séance créée avec succès !'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      print('❌ ERREUR création séance: $e');

      setState(() {
        _isLoading = false;
      });

      if (mounted) {
        // Afficher une boîte de dialogue avec l'erreur détaillée
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Row(
              children: [
                Icon(Icons.error, color: Colors.red),
                SizedBox(width: 8),
                Text('Erreur'),
              ],
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Impossible de créer la séance :',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    e.toString().replaceAll('Exception: ', ''),
                    style: const TextStyle(fontSize: 14),
                  ),
                  const SizedBox(height: 16),
                  const Divider(),
                  const SizedBox(height: 8),
                  const Text(
                    'Solutions possibles :',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    '• Vérifiez votre connexion Internet\n'
                    '• Vérifiez que vous êtes bien connecté\n'
                    '• Réessayez dans quelques instants\n'
                    '• Si le problème persiste, contactez l\'administrateur',
                    style: TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Fermer'),
              ),
            ],
          ),
        );

        // Afficher aussi un snackbar
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('❌ ${e.toString().replaceAll('Exception: ', '')}'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 5),
            action: SnackBarAction(
              label: 'Détails',
              textColor: Colors.white,
              onPressed: () {},
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Créer une séance'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: _generatedToken == null
            ? _buildForm()
            : _buildQrCodeDisplay(),
      ),
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Icon(
            Icons.qr_code_2,
            size: 80,
            color: Colors.blue,
          ),
          const SizedBox(height: 24),
          Text(
            'Nouvelle séance de cours',
            style: Theme.of(context).textTheme.headlineSmall,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          TextFormField(
            controller: _nomCoursController,
            decoration: const InputDecoration(
              labelText: 'Nom du cours',
              hintText: 'Ex: Mathématiques Informatiques',
              prefixIcon: Icon(Icons.book),
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Veuillez entrer le nom du cours';
              }
              if (value.trim().length < 3) {
                return 'Le nom doit contenir au moins 3 caractères';
              }
              return null;
            },
            textCapitalization: TextCapitalization.words,
            enabled: !_isLoading,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: _isLoading ? null : _createSchedule,
            icon: _isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : const Icon(Icons.qr_code),
            label: Text(_isLoading ? 'Création...' : 'Générer QR Code'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              textStyle: const TextStyle(fontSize: 16),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            color: Colors.blue.shade50,
            child: const Padding(
              padding: EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Icon(Icons.info_outline, color: Colors.blue),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Un code QR unique sera généré pour cette séance. Les étudiants pourront scanner ce code pour confirmer leur présence.',
                      style: TextStyle(fontSize: 13),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQrCodeDisplay() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Card(
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Text(
                  _nomCoursController.text,
                  style: Theme.of(context).textTheme.headlineSmall,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'Code: $_generatedToken',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),
        // QR Code
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Center(
            child: QrImageView(
              data: _generatedToken!,
              version: QrVersions.auto,
              size: 280.0,
              backgroundColor: Colors.white,
              errorCorrectionLevel: QrErrorCorrectLevel.H,
              embeddedImage: null,
            ),
          ),
        ),
        const SizedBox(height: 24),
        Card(
          color: Colors.green.shade50,
          child: const Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              children: [
                Icon(Icons.check_circle, color: Colors.green, size: 40),
                SizedBox(height: 8),
                Text(
                  'QR Code généré avec succès !',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Les étudiants peuvent maintenant scanner ce code pour confirmer leur présence.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 13),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        OutlinedButton.icon(
          onPressed: () {
            setState(() {
              _generatedToken = null;
              _scheduleId = null;
              _nomCoursController.clear();
            });
          },
          icon: const Icon(Icons.add),
          label: const Text('Créer une autre séance'),
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
          ),
        ),
        const SizedBox(height: 8),
        ElevatedButton.icon(
          onPressed: () {
            Navigator.pop(context, true); // Retour avec succès
          },
          icon: const Icon(Icons.check),
          label: const Text('Terminer'),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
          ),
        ),
      ],
    );
  }
}

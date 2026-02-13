import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../services/firestore_service.dart';

class ScanQrScreen extends StatefulWidget {
  const ScanQrScreen({super.key});

  @override
  State<ScanQrScreen> createState() => _ScanQrScreenState();
}

class _ScanQrScreenState extends State<ScanQrScreen> {
  final _firestoreService = FirestoreService();
  MobileScannerController cameraController = MobileScannerController();
  
  bool _isProcessing = false;
  bool _scanCompleted = false;
  bool _torchEnabled = false;

  @override
  void dispose() {
    cameraController.dispose();
    super.dispose();
  }

  Future<void> _onDetect(BarcodeCapture capture) async {
    if (_isProcessing || _scanCompleted) return;

    final List<Barcode> barcodes = capture.barcodes;
    if (barcodes.isEmpty) return;

    final String? qrToken = barcodes.first.rawValue;
    if (qrToken == null || qrToken.isEmpty) return;

    setState(() {
      _isProcessing = true;
    });

    try {
      final authProvider = context.read<AuthProvider>();
      final user = authProvider.currentUserProfile;

      if (user == null) {
        throw Exception('Utilisateur non connecté');
      }

      // Rechercher la séance par QR token
      final scheduleDoc = await _firestoreService.getScheduleByQrToken(qrToken);

      if (scheduleDoc == null) {
        throw Exception('Code QR invalide ou séance introuvable');
      }

      // Enregistrer la présence
      await _firestoreService.markAttendance(
        scheduleId: scheduleDoc.id,
        userId: user.uid,
        userName: user.fullName,
      );

      setState(() {
        _scanCompleted = true;
      });

      // Arrêter la caméra
      await cameraController.stop();

      if (mounted) {
        // Afficher dialogue de succès
        await showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => AlertDialog(
            icon: const Icon(
              Icons.check_circle,
              color: Colors.green,
              size: 64,
            ),
            title: const Text('Présence confirmée !'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Votre présence a été enregistrée pour la séance :',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  scheduleDoc.get('nomCours'),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Fermer le dialogue
                  Navigator.of(context).pop(); // Retourner à l'écran précédent
                },
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      setState(() {
        _isProcessing = false;
      });

      if (mounted) {
        // Afficher dialogue d'erreur
        await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            icon: const Icon(
              Icons.error_outline,
              color: Colors.red,
              size: 64,
            ),
            title: const Text('Erreur'),
            content: Text(
              e.toString().replaceAll('Exception: ', ''),
              textAlign: TextAlign.center,
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Réessayer'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Fermer le dialogue
                  Navigator.of(context).pop(); // Retourner à l'écran précédent
                },
                child: const Text('Annuler'),
              ),
            ],
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scanner QR Code'),
        actions: [
          IconButton(
            icon: Icon(
              _torchEnabled ? Icons.flash_on : Icons.flash_off,
              color: _torchEnabled ? Colors.yellow : null,
            ),
            onPressed: () {
              cameraController.toggleTorch();
              setState(() {
                _torchEnabled = !_torchEnabled;
              });
            },
            tooltip: 'Flash',
          ),
          IconButton(
            icon: const Icon(Icons.flip_camera_ios),
            onPressed: () => cameraController.switchCamera(),
            tooltip: 'Changer de caméra',
          ),
        ],
      ),
      body: Stack(
        children: [
          // Scanner de caméra
          MobileScanner(
            controller: cameraController,
            onDetect: _onDetect,
          ),
          
          // Overlay avec cadre de scan
          CustomPaint(
            painter: ScannerOverlay(),
            child: Container(),
          ),
          
          // Instructions
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.8),
                    Colors.transparent,
                  ],
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (_isProcessing)
                    const CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    )
                  else
                    const Column(
                      children: [
                        Icon(
                          Icons.qr_code_scanner,
                          color: Colors.white,
                          size: 48,
                        ),
                        SizedBox(height: 12),
                        Text(
                          'Placez le QR code dans le cadre',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Le scan se fera automatiquement',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Overlay personnalisé pour le scanner
class ScannerOverlay extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final backgroundPath = Path()
      ..addRect(Rect.fromLTWH(0, 0, size.width, size.height));

    final cutoutPath = Path()
      ..addRRect(RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset(size.width / 2, size.height / 2),
          width: size.width * 0.7,
          height: size.width * 0.7,
        ),
        const Radius.circular(16),
      ));

    final backgroundPaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.5)
      ..style = PaintingStyle.fill;

    final path = Path.combine(PathOperation.difference, backgroundPath, cutoutPath);
    canvas.drawPath(path, backgroundPaint);

    // Dessiner les coins du cadre
    final cornerPaint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;

    final cornerLength = 30.0;
    final centerX = size.width / 2;
    final centerY = size.height / 2;
    final scanSize = size.width * 0.7;
    final left = centerX - scanSize / 2;
    final top = centerY - scanSize / 2;
    final right = centerX + scanSize / 2;
    final bottom = centerY + scanSize / 2;

    // Coin supérieur gauche
    canvas.drawLine(Offset(left, top), Offset(left + cornerLength, top), cornerPaint);
    canvas.drawLine(Offset(left, top), Offset(left, top + cornerLength), cornerPaint);

    // Coin supérieur droit
    canvas.drawLine(Offset(right, top), Offset(right - cornerLength, top), cornerPaint);
    canvas.drawLine(Offset(right, top), Offset(right, top + cornerLength), cornerPaint);

    // Coin inférieur gauche
    canvas.drawLine(Offset(left, bottom), Offset(left + cornerLength, bottom), cornerPaint);
    canvas.drawLine(Offset(left, bottom), Offset(left, bottom - cornerLength), cornerPaint);

    // Coin inférieur droit
    canvas.drawLine(Offset(right, bottom), Offset(right - cornerLength, bottom), cornerPaint);
    canvas.drawLine(Offset(right, bottom), Offset(right, bottom - cornerLength), cornerPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

import 'package:flutter/material.dart';

class QrScanDialog extends StatelessWidget {
  final VoidCallback onScanSuccess;

  const QrScanDialog({super.key, required this.onScanSuccess});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.all(20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: SizedBox(
        width: 520,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // HEADER
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: const Color(0xffF2EEFF),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.qr_code_scanner,
                      color: Color(0xffB39DDB),
                    ),
                  ),

                  const SizedBox(width: 12),

                  const Expanded(
                    child: Text(
                      "Scan customer QR",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
            ),

            Divider(height: 1, color: Colors.grey.shade300),

            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  Container(
                    height: 420,
                    decoration: BoxDecoration(
                      color: const Color(0xff101114),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Center(
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            width: 320,
                            height: 320,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.white24),
                            ),
                          ),

                          SizedBox(
                            width: 340,
                            height: 340,
                            child: CustomPaint(painter: _ScannerFramePainter()),
                          ),

                          const Icon(
                            Icons.photo_camera_outlined,
                            color: Colors.white24,
                            size: 60,
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  Text(
                    "Scanning... hold the QR steady",
                    style: TextStyle(color: Colors.grey.shade700, fontSize: 15),
                  ),

                  const SizedBox(height: 20),

                  // DEMO BUTTON
                  // remove later when integrating real QR scanner
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: onScanSuccess,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xff54C7C3),
                        foregroundColor: Colors.white,
                        shape: const StadiumBorder(),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: const Text("Simulate successful scan"),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ScannerFramePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    const frameColor = Color(0xff54E2E5);

    final paint = Paint()
      ..color = frameColor
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    const corner = 28.0;

    // Top Left
    canvas.drawLine(const Offset(0, corner), const Offset(0, 0), paint);

    canvas.drawLine(const Offset(0, 0), const Offset(corner, 0), paint);

    // Top Right
    canvas.drawLine(
      Offset(size.width - corner, 0),
      Offset(size.width, 0),
      paint,
    );

    canvas.drawLine(Offset(size.width, 0), Offset(size.width, corner), paint);

    // Bottom Left
    canvas.drawLine(
      Offset(0, size.height - corner),
      Offset(0, size.height),
      paint,
    );

    canvas.drawLine(Offset(0, size.height), Offset(corner, size.height), paint);

    // Bottom Right
    canvas.drawLine(
      Offset(size.width - corner, size.height),
      Offset(size.width, size.height),
      paint,
    );

    canvas.drawLine(
      Offset(size.width, size.height - corner),
      Offset(size.width, size.height),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

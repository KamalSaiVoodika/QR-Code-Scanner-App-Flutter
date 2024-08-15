import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:qr_code_scanner_app_flutter/result_screen.dart';

const bgColor = Color(0xfffafafa);

class QrScannerWidget extends StatefulWidget {
  const QrScannerWidget({super.key});

  @override
  State<QrScannerWidget> createState() => _QrScannerWidgetState();
}

class _QrScannerWidgetState extends State<QrScannerWidget> {
  bool isScanCompleted = false;
  bool isFlashOn = false;
  bool isFrontCam = true;
  MobileScannerController mobileScannerController =
      MobileScannerController(detectionSpeed: DetectionSpeed.noDuplicates);


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                isFlashOn = !isFlashOn;
              });
              mobileScannerController.toggleTorch();
            },
            icon: Icon(
              Icons.flash_on,
              color: isFlashOn ? Colors.blue : Colors.grey,
            ),
          ),
          IconButton(
            onPressed: () {
              setState(() {
                isFrontCam = !isFrontCam;
              });
              mobileScannerController.switchCamera();
            },
            icon: Icon(
              Icons.camera_front,
              color: isFrontCam ? Colors.blue : Colors.grey,
            ),
          ),
        ],
        title: const Text(
          "QR Scanner",
          style: TextStyle(
            color: Colors.black87,
            letterSpacing: 1,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Place the QR code in the area",
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 18,
                      letterSpacing: 1,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Scanning will be started automatically",
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 16,
                      letterSpacing: 1,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 4,
              child: MobileScanner(
                controller: mobileScannerController,
                onDetect: (barcodes) {
                  if (!isScanCompleted) {
                    String code = barcodes.raw.toString();
                    isScanCompleted = true;
                    mobileScannerController.stop();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ResultWidget(
                          code: code,
                        ),
                      ),
                    ).then(
                      (value) {
                        isScanCompleted = false;
                        mobileScannerController.start();
                        return true;
                      },
                    );
                  }
                },
              ),
            ),
            Expanded(
              child: Container(
                alignment: Alignment.center,
                child: const Text(
                  "Developed By \n Kamal Sai Voodika",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 14,
                    letterSpacing: 1,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

}

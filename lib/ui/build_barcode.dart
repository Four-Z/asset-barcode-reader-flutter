import 'package:flutter/material.dart';
import 'package:inventory_barcode_scanner/ui/home_admin.dart';
import 'package:syncfusion_flutter_barcodes/barcodes.dart';
import 'package:screenshot/screenshot.dart';
import 'dart:typed_data';
import 'package:image_gallery_saver/image_gallery_saver.dart';

class BarcodeDisplayPage extends StatelessWidget {
  final String barcodeData;

  const BarcodeDisplayPage({
    super.key,
    required this.barcodeData,
  });

  @override
  Widget build(BuildContext context) {
    //Create an instance of ScreenshotController
    ScreenshotController screenshotController = ScreenshotController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Generated Barcode'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const HomeAdmin()),
            );
          },
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Barcode Display
            Screenshot(
              controller: screenshotController,
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors
                      .white, // Set white background color// Optional: add border radius
                ),
                child: SizedBox(
                  height: 200,
                  child: SfBarcodeGenerator(
                    value: barcodeData,
                    symbology: Code128A(),
                    showValue: true,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Save Button
            ElevatedButton(
              onPressed: () async {
                try {
                  // Capture the screenshot
                  Uint8List? capturedImage =
                      await screenshotController.capture();
                  if (capturedImage != null) {
                    // Save the image to gallery
                    await ImageGallerySaver.saveImage(capturedImage);
                    // Show a snackbar to indicate successful save
                    // ignore: use_build_context_synchronously
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Barcode Disimpan di Galeri!'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  }
                } catch (error) {
                  // Show a snackbar on error
                  // ignore: use_build_context_synchronously
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Gagal Menyimpan Barcode.'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                }
              },
              child: const Text('Simpan Barcode'),
            ),
          ],
        ),
      ),
    );
  }
}

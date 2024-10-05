import 'package:flutter/material.dart';
import 'package:inventory_barcode_scanner/ui/build_barcode.dart';

class BarcodeFormPage extends StatefulWidget {
  const BarcodeFormPage({
    super.key,
  });

  @override
  State<BarcodeFormPage> createState() => _BarcodeFormPageState();
}

class _BarcodeFormPageState extends State<BarcodeFormPage> {
  final _formKey = GlobalKey<FormState>();

  String _idBarcode = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Barcode Generator'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextFormField(
                decoration: const InputDecoration(labelText: 'ID Barcode'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Tolong Masukkan ID Barcode';
                  }
                  return null;
                },
                onSaved: (value) {
                  _idBarcode = value!;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    // Navigate to a new screen to display the barcode
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BarcodeDisplayPage(
                          barcodeData: _idBarcode,
                        ),
                      ),
                    );
                    // Clear the form field after submission (optional)
                    _formKey.currentState!.reset();
                  }
                },
                child: const Text('Generate Barcode'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

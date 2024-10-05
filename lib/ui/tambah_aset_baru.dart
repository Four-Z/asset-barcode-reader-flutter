// ignore_for_file: use_super_parameters, prefer_const_constructors, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';
import 'package:inventory_barcode_scanner/api_config.dart';
import 'package:inventory_barcode_scanner/ui/build_barcode.dart';

class TambahAset extends StatefulWidget {
  const TambahAset({
    Key? key,
  }) : super(key: key);

  @override
  State<TambahAset> createState() => _AssetFormPageState();
}

class _AssetFormPageState extends State<TambahAset> {
  final _formKey = GlobalKey<FormState>();

  String _idBarcode = '';
  String _namaAset = '';
  String _merkAset = '';
  int? _tahunBeli;
  int? _hargaBeli;
  int _kondisiAset = 1; // Default value kondisi aset
  String _lokasiAset = '';
  String _keterangan = '';

  final List<String> _kondisiAsetLabels = <String>[
    'Baik',
    'Rusak',
    'Usang',
    'Hilang',
  ];

  final List<int> _kondisiAsetValues = <int>[1, 2, 3, 4];

  Future<void> _submitForm() async {
    final url = Uri.parse(ApiConfig.tambahAsetUrl);
    final response = await http.post(
      url,
      body: {
        'id_barcode': _idBarcode,
        'nama_aset': _namaAset,
        'merk_aset': _merkAset,
        'tahun_beli': _tahunBeli.toString(),
        'harga_beli': _hargaBeli.toString(),
        'kondisi_aset': _kondisiAset.toString(),
        'lokasi_aset': _lokasiAset,
        'keterangan': _keterangan,
      },
    );

    if (response.statusCode == 200) {
      _showMessageDialog("Sukses", "Berhasil Menambahkan Aset");
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => BarcodeDisplayPage(
            barcodeData: _idBarcode,
          ),
        ),
      );
    } else {
      _showMessageDialog("Error", response.body);
    }
  }

  void _showMessageDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Aset'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                TextFormField(
                  decoration: const InputDecoration(labelText: 'ID Barcode'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Tolong masukkan ID Barcode';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _idBarcode = value!;
                  },
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Nama Aset'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Tolong masukkan Nama Aset';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _namaAset = value!;
                  },
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Merk Aset'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Tolong masukkan Merk Aset';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _merkAset = value!;
                  },
                ),
                TextFormField(
                  decoration:
                      const InputDecoration(labelText: 'Tahun Beli (Tahun)'),
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(4)
                  ],
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Tolong masukkan Tahun Beli';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _tahunBeli = int.tryParse(value!);
                  },
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Harga Beli'),
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Tolong masukkan Harga Beli';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _hargaBeli = int.tryParse(value!);
                  },
                ),
                DropdownButtonFormField<int>(
                  value: _kondisiAset,
                  icon: const Icon(Icons.arrow_downward),
                  isExpanded: true,
                  decoration: const InputDecoration(labelText: 'Kondisi Aset'),
                  items: _kondisiAsetLabels.asMap().entries.map((entry) {
                    return DropdownMenuItem<int>(
                      value: _kondisiAsetValues[entry.key],
                      child: Text(entry.value),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _kondisiAset = value!;
                    });
                  },
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Lokasi Aset'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Tolong masukkan Lokasi Aset';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _lokasiAset = value!;
                  },
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Keterangan'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Tolong masukkan Keterangan';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _keterangan = value!;
                  },
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      _submitForm();
                    }
                  },
                  child: const Text('Tambah Aset'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

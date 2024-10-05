// ignore_for_file: use_super_parameters, use_build_context_synchronously

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:inventory_barcode_scanner/api_config.dart';
import 'package:inventory_barcode_scanner/ui/detail_aset_admin.dart';
import 'package:simple_barcode_scanner/simple_barcode_scanner.dart';
import 'package:inventory_barcode_scanner/ui/tambah_aset_baru.dart';
import 'package:inventory_barcode_scanner/ui/barcode_generator.dart';
import 'package:inventory_barcode_scanner/ui/gudang.dart';
import 'package:inventory_barcode_scanner/ui/list_aset.dart';

class HomeAdmin extends StatefulWidget {
  const HomeAdmin({
    Key? key,
  }) : super(key: key);

  @override
  State<HomeAdmin> createState() => _HomeAdminState();
}

class _HomeAdminState extends State<HomeAdmin> {
  String? result;

  Future<void> _fetchAssetData(String idBarcode) async {
    final url = Uri.parse('${ApiConfig.getAsetbyIdUrl}$idBarcode');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailAsetAdminPage(
              idBarcode: responseData['asets']['id_barcode'],
              namaAset: responseData['asets']['nama_aset'],
              merkAset: responseData['asets']['merk_aset'],
              tahunBeli: responseData['asets']['tahun_beli'].toString(),
              hargaBeli:
                  double.parse(responseData['asets']['harga_beli'].toString()),
              kondisiAset: int.parse(responseData['asets']['kondisi_aset']),
              lokasiAset: responseData['asets']['lokasi_aset'],
              keterangan: responseData['asets']['keterangan'],
            ),
          ),
        );
      } else {
        // Handle error response
        _showMessageDialogue("Gagal mendapatkan data Aset");
      }
    } catch (e) {
      // Handle error
      _showMessageDialogue("Gagal mendapatkan data Aset");
    }
  }

  void _showMessageDialogue(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Pesan'),
          content: Text(message),
          actions: [
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
        title: const Text('Home Admin Panel'),
      ),
      backgroundColor: const Color(0xFFe5ffff), // Background color #e5ffff
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildButton(
              icon: Icons.barcode_reader,
              text: "SCAN BARCODE",
              onPressed: () async {
                var res = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SimpleBarcodeScannerPage(),
                  ),
                );
                setState(() {
                  if (res is String) {
                    result = res;
                    _fetchAssetData(res); // Fetch asset data using barcode
                  }
                });
              },
            ),
            const SizedBox(height: 20),
            _buildButton(
              icon: Icons.add,
              text: "TAMBAH ASET BARU",
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const TambahAset(),
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
            _buildButton(
              icon: Icons.qr_code,
              text: "BARCODE GENERATOR",
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const BarcodeFormPage(),
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
            _buildButton(
              icon: Icons.inventory_2_outlined,
              text: "LIHAT DAFTAR ASET",
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AssetListPage(),
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
            _buildButton(
              icon: Icons.warehouse_outlined,
              text: "LIHAT GUDANG",
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const GudangPage(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildButton(
      {required IconData icon,
      required String text,
      required VoidCallback onPressed}) {
    return SizedBox(
      width: 300, // Set width as needed
      height: 100, // Set height as needed
      child: ElevatedButton.icon(
        icon: Icon(
          icon,
          size: 80.0,
          color: const Color.fromARGB(255, 0, 94, 255), // Icon color #36b649
        ),
        label: Text(
          text,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 0, 94, 255), // Text color #36b649
          ),
        ),
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.all(20.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          backgroundColor: Colors.white, // Button background color
        ),
      ),
    );
  }
}

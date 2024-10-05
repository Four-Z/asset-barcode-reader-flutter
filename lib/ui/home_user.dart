// ignore_for_file: use_super_parameters, use_build_context_synchronously

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:inventory_barcode_scanner/api_config.dart';
import 'package:inventory_barcode_scanner/ui/detail_aset_user.dart';
import 'package:simple_barcode_scanner/simple_barcode_scanner.dart';

class HomeUser extends StatefulWidget {
  const HomeUser({
    Key? key,
  }) : super(key: key);

  @override
  State<HomeUser> createState() => _HomeUserState();
}

class _HomeUserState extends State<HomeUser> {
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
            builder: (context) => DetailAsetUserPage(
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
        title: const Text('Home User Panel'),
      ),
      backgroundColor: const Color(0xFFe5ffff), // Background color #e5ffff
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton.icon(
              icon: const Icon(Icons.barcode_reader,
                  size: 100.0,
                  color: Color.fromARGB(255, 0, 94, 255)), // Icon color #36b649
              label: const Text(
                "SCAN BARCODE",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color:
                        Color.fromARGB(255, 0, 94, 255)), // Text color #36b649
              ),
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
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(20.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                backgroundColor: Colors.white, // Button background color
              ),
            ),
          ],
        ),
      ),
    );
  }
}

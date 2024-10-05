// ignore_for_file: use_build_context_synchronously, unnecessary_string_interpolations

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:inventory_barcode_scanner/api_config.dart';
import 'package:inventory_barcode_scanner/currency_formatter.dart';

class DetailAsetAdminPage extends StatefulWidget {
  final String idBarcode;
  final String namaAset;
  final String merkAset;
  final String tahunBeli;
  final double hargaBeli;
  final int kondisiAset;
  final String lokasiAset;
  final String keterangan;

  const DetailAsetAdminPage({
    super.key,
    required this.idBarcode,
    required this.namaAset,
    required this.merkAset,
    required this.tahunBeli,
    required this.hargaBeli,
    required this.kondisiAset,
    required this.lokasiAset,
    required this.keterangan,
  });

  @override
  State<DetailAsetAdminPage> createState() => _DetailAsetAdminPageState();
}

class _DetailAsetAdminPageState extends State<DetailAsetAdminPage> {
  late TextEditingController _kondisiController;

  @override
  void initState() {
    super.initState();
    _kondisiController =
        TextEditingController(text: widget.kondisiAset.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Detail Aset'),
      ),
      body: SingleChildScrollView(
        // Menggunakan SingleChildScrollView untuk scrolling
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDetailItem(
                'ID Barcode',
                widget.idBarcode,
                Icons.qr_code_2_outlined,
              ),
              _buildDetailItem(
                'Nama Aset',
                widget.namaAset,
                Icons.local_offer_outlined,
              ),
              _buildDetailItem(
                'Merk Aset',
                widget.merkAset,
                Icons.branding_watermark_outlined,
              ),
              _buildDetailItem(
                'Tahun Beli',
                widget.tahunBeli,
                Icons.calendar_today_outlined,
              ),
              _buildDetailItem(
                'Harga Beli',
                '${CurrencyFormat.convertToIdr(widget.hargaBeli)}',
                Icons.attach_money_outlined,
              ),
              _buildEditableDetailItem(
                'Kondisi Aset',
                _buildDropdown(),
                Icons.assignment_outlined,
              ),
              _buildDetailItem(
                'Lokasi Aset',
                widget.lokasiAset,
                Icons.location_on_outlined,
              ),
              _buildDetailItem(
                'Keterangan',
                widget.keterangan,
                Icons.description_outlined,
              ),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    _editAsset(widget.idBarcode, _kondisiController.text);
                  },
                  child: const Text('Edit Aset'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailItem(String label, String value, IconData iconData) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            iconData,
            size: 24,
            color: Colors.blue, // Icon color can be customized
          ),
          const SizedBox(width: 8), // Spacing between icon and text
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEditableDetailItem(
      String label, Widget inputWidget, IconData iconData) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            iconData,
            size: 24,
            color: Colors.blue,
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 4),
              SizedBox(
                width: 300,
                child: inputWidget,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDropdown() {
    return DropdownButtonFormField<int>(
      value: _kondisiController.text != ''
          ? int.parse(_kondisiController.text)
          : 1,
      onChanged: (newValueIndex) {
        setState(() {
          _kondisiController.text = newValueIndex.toString();
        });
      },
      items: <String>['Baik', 'Rusak', 'Usang', 'Hilang']
          .asMap()
          .entries
          .map((entry) {
        return DropdownMenuItem<int>(
          value: entry.key + 1,
          child: Text(entry.value),
        );
      }).toList(),
    );
  }

  Future<void> _editAsset(String idBarcode, String newKondisi) async {
    final url = Uri.parse('${ApiConfig.editAsetUrl}$idBarcode');
    try {
      final response = await http.put(
        url,
        body: {'kondisi_aset': newKondisi},
      );
      if (response.statusCode == 200) {
        _showEditResultDialog(context, true);
      } else {
        _showEditResultDialog(context, false);
      }
    } catch (e) {
      _showEditResultDialog(context, false);
    }
  }

  void _showEditResultDialog(BuildContext context, bool isSuccess) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(isSuccess ? 'Edit Berhasil' : 'Edit Gagal'),
        content: Text(isSuccess
            ? 'Data aset berhasil diubah.'
            : 'Terjadi kesalahan saat mengedit data aset.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _kondisiController.dispose();
    super.dispose();
  }
}

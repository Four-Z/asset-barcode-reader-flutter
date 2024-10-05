// ignore_for_file: unnecessary_string_interpolations

import 'package:flutter/material.dart';
import 'package:inventory_barcode_scanner/currency_formatter.dart';

class DetailAsetUserPage extends StatelessWidget {
  final String idBarcode;
  final String namaAset;
  final String merkAset;
  final String tahunBeli;
  final double hargaBeli;
  final int kondisiAset;
  final String lokasiAset;
  final String keterangan;

  const DetailAsetUserPage({
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
  Widget build(BuildContext context) {
    final List<String> kondisiAsetLabels = <String>[
      'Baik',
      'Rusak',
      'Usang',
      'Hilang',
    ];
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Detail Aset'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDetailItem(
                  'ID Barcode', idBarcode, Icons.qr_code_2_outlined),
              _buildDetailItem(
                  'Nama Aset', namaAset, Icons.local_offer_outlined),
              _buildDetailItem(
                  'Merk Aset', merkAset, Icons.branding_watermark_outlined),
              _buildDetailItem(
                  'Tahun Beli', tahunBeli, Icons.calendar_today_outlined),
              _buildDetailItem(
                  'Harga Beli',
                  '${CurrencyFormat.convertToIdr(hargaBeli)}',
                  Icons.attach_money_outlined),
              _buildDetailItem(
                  'Kondisi Aset',
                  kondisiAsetLabels[kondisiAset - 1],
                  Icons.assignment_outlined),
              _buildDetailItem(
                  'Lokasi Aset', lokasiAset, Icons.location_on_outlined),
              _buildDetailItem(
                  'Keterangan', keterangan, Icons.description_outlined),
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
}

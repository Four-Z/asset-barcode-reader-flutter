import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:inventory_barcode_scanner/api_config.dart';

class GudangPage extends StatefulWidget {
  const GudangPage({super.key});

  @override
  State<GudangPage> createState() => _GudangPageState();
}

class Asset {
  final String idBarcode;
  final String idAset;

  Asset({
    required this.idBarcode,
    required this.idAset,
  });

  factory Asset.fromJson(Map<String, dynamic> json) {
    return Asset(
      idBarcode: json['id_barcode'],
      idAset: json['nama_aset'],
    );
  }
}

class _GudangPageState extends State<GudangPage> {
  List<Asset> _assets = [];
  bool _isLoading = true;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _fetchAssets();
  }

  Future<void> _fetchAssets() async {
    final url = Uri.parse(ApiConfig.lihatGudangUrl);
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body)['asets'];
        setState(() {
          _assets = data.map((json) => Asset.fromJson(json)).toList();
          _isLoading = false;
        });
      } else {
        setState(() {
          _hasError = true;
          _isLoading = false;
        });
        _showErrorDialog('Gagal memuat data dari server.');
      }
    } catch (e) {
      setState(() {
        _hasError = true;
        _isLoading = false;
      });
      _showErrorDialog('Terjadi kesalahan saat memuat data.');
    }
  }

  Future<void> _restoreAsset(String idBarcode) async {
    final url = Uri.parse('${ApiConfig.restoreAsetUrl}$idBarcode');
    try {
      final response = await http.put(url);
      if (response.statusCode == 200) {
        _fetchAssets(); // Refresh the list after restoring
        _showSuccessDialog('Aset berhasil direstore.');
      } else {
        _showErrorDialog(
            'Gagal restore aset. Status code: ${response.statusCode}');
      }
    } catch (e) {
      _showErrorDialog('Terjadi kesalahan saat restore aset: $e');
    }
  }

  Future<void> _deleteAssetPermanently(String idBarcode) async {
    final url = Uri.parse('${ApiConfig.hapusAsetPermanenUrl}$idBarcode');
    try {
      final response = await http.delete(url);
      if (response.statusCode == 200) {
        _fetchAssets(); // Refresh the list after deleting
        _showSuccessDialog('Aset berhasil dihapus permanen.');
      } else {
        _showErrorDialog(
            'Gagal menghapus aset secara permanen. Status code: ${response.statusCode}');
      }
    } catch (e) {
      _showErrorDialog(
          'Terjadi kesalahan saat menghapus aset secara permanen: $e');
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Error'),
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

  void _showSuccessDialog(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Sukses'),
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
        title: const Text('Gudang'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _hasError
              ? const Center(child: Text('Gagal memuat data'))
              : ListView.separated(
                  itemCount: _assets.length,
                  separatorBuilder: (context, index) => const Divider(),
                  itemBuilder: (context, index) {
                    final asset = _assets[index];
                    return ListTile(
                      title: Text('ID Barcode: ${asset.idBarcode}'),
                      subtitle: Text('Nama Aset: ${asset.idAset}'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.restore_from_trash_outlined),
                            onPressed: () {
                              _restoreAsset(asset.idBarcode);
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: const Text('Konfirmasi'),
                                    content: const Text(
                                        'Apakah Anda yakin ingin menghapus aset ini secara permanen?'),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context)
                                              .pop(); // Close dialog
                                        },
                                        child: const Text('Batal'),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context)
                                              .pop(); // Close dialog
                                          _deleteAssetPermanently(asset
                                              .idBarcode); // Delete asset permanently
                                        },
                                        child: const Text('Hapus'),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                          ),
                        ],
                      ),
                    );
                  },
                ),
    );
  }
}

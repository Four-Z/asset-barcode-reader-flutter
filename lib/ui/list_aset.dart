import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:inventory_barcode_scanner/api_config.dart';

class AssetListPage extends StatefulWidget {
  const AssetListPage({super.key});

  @override
  State<AssetListPage> createState() => _AssetListPageState();
}

class _AssetListPageState extends State<AssetListPage> {
  List<Asset> _assets = [];
  bool _isLoading = true;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _fetchAssets();
  }

  Future<void> _fetchAssets() async {
    final url = Uri.parse(ApiConfig.lihatAsetUrl);
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
        _showMessageDialogue('Gagal memuat data dari server.');
      }
    } catch (e) {
      setState(() {
        _hasError = true;
        _isLoading = false;
      });
      _showMessageDialogue('Terjadi kesalahan saat memuat data.');
    }
  }

  Future<void> _deleteAsset(int index) async {
    final asset = _assets[index];
    final url = Uri.parse('${ApiConfig.hapusAsetUrl}${asset.idBarcode}');
    try {
      final response = await http.delete(url);
      if (response.statusCode == 200) {
        setState(() {
          _assets.removeAt(index);
        });
        _showMessageDialogue('Aset berhasil dipindahkan ke gudang.');
      } else {
        _showMessageDialogue('Gagal memindahkan aset.');
      }
    } catch (e) {
      _showMessageDialogue('Terjadi kesalahan saat memindahkan aset.');
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
        title: const Text('Daftar Aset'),
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
                      title: Text('Nama Aset: ${asset.namaAset}'),
                      subtitle: Text('ID Barcode: ${asset.idBarcode}'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.content_copy),
                            onPressed: () {
                              Clipboard.setData(
                                  ClipboardData(text: asset.idBarcode));
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('ID Barcode disalin'),
                                ),
                              );
                            },
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.move_down_outlined,
                            ),
                            onPressed: () {
                              // Show confirmation dialog before deleting
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: const Text('Konfirmasi'),
                                    content: const Text(
                                        'Apakah Anda yakin ingin memindahkan aset ini ke gudang?'),
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
                                          _deleteAsset(index); // Delete asset
                                        },
                                        child: const Text('Pindahkan'),
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

class Asset {
  final String idBarcode;
  final String namaAset;

  Asset({
    required this.idBarcode,
    required this.namaAset,
  });

  factory Asset.fromJson(Map<String, dynamic> json) {
    return Asset(
      idBarcode: json['id_barcode'],
      namaAset: json['nama_aset'],
    );
  }
}

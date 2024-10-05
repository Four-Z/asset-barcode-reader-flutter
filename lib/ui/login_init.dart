import 'package:flutter/material.dart';
import 'login_admin.dart';
import 'login_user.dart';

class LoginInit extends StatelessWidget {
  const LoginInit({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              // Bagian logo dengan judul "BPJS Asset Reader"
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 50.0,
                    ), // Atur jarak antara logo dan atas
                    child: Column(
                      children: [
                        Image.asset(
                          'assets/bpjs_logo.png', // Ganti dengan path logo Anda
                          width: 150.0,
                          height: 50.0,
                        ),
                        // Judul "BPJS Asset Reader" diganti dengan gambar aplikasi_logo.png
                        Padding(
                          padding: const EdgeInsets.only(top: 50.0),
                          child: Image.asset(
                            'assets/aplikasi_logo.png', // Ganti dengan path logo aplikasi Anda
                            width: 300.0,
                            height: 200.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              // Tombol-tombol
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  // Tombol Login Admin
                  SizedBox(
                    width: 250.0,
                    height: 100.0,
                    child: Builder(
                      builder: (context) => ElevatedButton.icon(
                        icon: const Icon(
                          Icons.admin_panel_settings_outlined,
                          size: 80.0,
                          color: Colors.lightBlue, // Warna ikon biru muda
                        ),
                        label: const Text(
                          "Login as Admin",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.lightBlue, // Warna teks biru muda
                          ),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return const LoginAdmin();
                              },
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.all(20.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          foregroundColor:
                              Colors.lightBlue, // Warna ikon dan teks
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20), // Jarak antara dua tombol
                  // Tombol Login User
                  SizedBox(
                    width: 250.0,
                    height: 100.0,
                    child: Builder(
                      builder: (context) => ElevatedButton.icon(
                        icon: const Icon(
                          Icons.person_outlined,
                          size: 80.0,
                          color: Colors.lightBlue, // Warna ikon biru muda
                        ),
                        label: const Text(
                          "Login as User",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.lightBlue, // Warna teks biru muda
                          ),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return const LoginUser();
                              },
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.all(20.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          foregroundColor:
                              Colors.lightBlue, // Warna ikon dan teks
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              // Spacer untuk memberi jarak antara tombol dan footer
              const Spacer(),
              // Footer
              const Padding(
                padding:
                    EdgeInsets.only(bottom: 20.0), // Menambahkan padding bawah
                child: Text(
                  '2024 © Pratiwi Amalia • D4 TIMD • Politeknik Negeri Sriwijaya',
                  style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.w300),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

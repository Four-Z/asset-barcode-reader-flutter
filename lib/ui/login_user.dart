// ignore_for_file: use_build_context_synchronously, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:inventory_barcode_scanner/api_config.dart';
import 'package:inventory_barcode_scanner/ui/home_user.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class LoginUser extends StatefulWidget {
  const LoginUser({
    super.key,
  });

  @override
  State<LoginUser> createState() => _LoginState();
}

class _LoginState extends State<LoginUser> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  final FocusNode _focusNodePassword = FocusNode();
  final TextEditingController _controllerUsername = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();
  bool _obscurePassword = true;

  Future<void> _login() async {
    final url = Uri.parse(ApiConfig.loginUrl);
    final response = await http.post(
      url,
      body: {
        'username': _controllerUsername.text,
        'password': _controllerPassword.text,
      },
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      final role = responseData['user']['role'];

      if (role == 'user') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeUser()),
        );
      } else {
        _showErrorDialog('Role tidak valid untuk login.');
      }
    } else {
      _showErrorDialog('Username atau Password salah. Silakan coba lagi.');
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
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
        title: const Text('Login User'),
      ),
      backgroundColor: const Color(0xFFe5ffff), // Background color #e5ffff
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            children: [
              const SizedBox(height: 30),
              // Tambahkan gambar GIF di sini
              Image.asset(
                'assets/login_animation.gif', // Ganti dengan path GIF Anda
                width: 200,
                height: 200,
              ),
              const SizedBox(height: 20),
              Text(
                "USER LOGIN PANEL",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: Theme.of(context).textTheme.headline4!.fontSize,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                "Login untuk Melanjutkan",
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 60),
              TextFormField(
                controller: _controllerUsername,
                keyboardType: TextInputType.name,
                decoration: InputDecoration(
                  labelText: "Username",
                  prefixIcon: const Icon(Icons.person_outline,
                      color: Color(0xFF36b649)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return "Tolong masukkan username.";
                  }
                  return null; // Kembalikan null jika validasi berhasil
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _controllerPassword,
                focusNode: _focusNodePassword,
                obscureText: _obscurePassword,
                keyboardType: TextInputType.visiblePassword,
                decoration: InputDecoration(
                  labelText: "Password",
                  prefixIcon: const Icon(Icons.password_outlined,
                      color: Color(0xFF36b649)),
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                    icon: _obscurePassword
                        ? const Icon(Icons.visibility_outlined,
                            color: Color(0xFF36b649))
                        : const Icon(Icons.visibility_off_outlined,
                            color: Color(0xFF36b649)),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return "Tolong masukkan password.";
                  }
                  return null; // Kembalikan null jika validasi berhasil
                },
              ),
              const SizedBox(height: 60),
              Column(
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      foregroundColor: Colors.lightBlue,
                    ),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _login();
                      }
                    },
                    child: const Text("Login"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _focusNodePassword.dispose();
    _controllerUsername.dispose();
    _controllerPassword.dispose();
    super.dispose();
  }
}

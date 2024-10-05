// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'ui/login_init.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Scanner Barcode Aset BPJS Sumsel',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset('assets/splashscreen.mp4')
      ..initialize().then((_) {
        setState(() {});
        _controller.play();
      });

    // Navigate to login screen after video ends
    _controller.addListener(() {
      if (_controller.value.position == _controller.value.duration) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginInit()),
        );
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _controller.value.isInitialized
              ? Center(
                  child: AspectRatio(
                    aspectRatio: _controller.value.aspectRatio,
                    child: VideoPlayer(_controller),
                  ),
                )
              : Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }
}

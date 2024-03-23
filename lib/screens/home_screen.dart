import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:healthmate/screens/Blink.dart';
import 'package:healthmate/screens/image_detection.dart';
import 'package:healthmate/screens/mood_reports.dart';
import 'package:healthmate/screens/water_alerts.dart';
import 'package:healthmate/screens/profile_screen.dart';
import 'package:healthmate/screens/tflite_results.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _isMenuOpen = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )
      ..repeat(reverse: true);
    _animation = Tween<double>(begin: -150, end: 150).animate(_controller);
  }

  @override
  void dispose() {
    Get.find<ImageDetection>().dispose(); // Dispose controller
    _controller.dispose();
    super.dispose();
  }

  void toggleMenu() {
    setState(() {
      _isMenuOpen = !_isMenuOpen;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 160),
        child: FloatingActionButton(
          child: const Icon(Icons.camera),
          onPressed: () {
            // Trigger image capture here
            captureImage();
          },
        ),
      ),
      body: Stack(
        children: [
          GetBuilder<ImageDetection>(
            init: ImageDetection(),
            builder: (controller) {
              return controller.isCameraInitialized.value ? CameraPreview(
                  controller.cameraController) : Text("Loading Preview....");
            },
          ),
          Align(
            alignment: const Alignment(0, -0.1),
            child: Container(
              width: 250,
              height: 300,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white, width: 2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: AnimatedBuilder(
                animation: _animation,
                builder: (context, child) {
                  return Transform.translate(
                    offset: Offset(0, _animation.value),
                    child: const Divider(
                      color: Colors.white,
                      thickness: 2,
                    ),
                  );
                },
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            child: Container(
              width: MediaQuery.of(context).size.width,
              color: Colors.white, // Adjust opacity as needed
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      IconButton(
                        iconSize: 38,
                        color: const Color(0xFFC83E4D),
                        icon: _isMenuOpen ? const Icon(Icons.menu_open_rounded) : const Icon(Icons.menu_rounded),
                        onPressed: () {
                          toggleMenu();
                        },
                      ),
                      const SizedBox(height: 2),
                      const Text('Menu', style: TextStyle(color: Color(0xFFC83E4D))),
                    ],
                  ),
                  Column(
                    children: [
                      IconButton(
                        iconSize: 38,
                        color: const Color(0xFFC83E4D),
                        icon: const Icon(Icons.image_search),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const HomeScreen(),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 2),
                      const Text('Scanner', style: TextStyle(color: Color(0xFFC83E4D))),
                    ],
                  ),
                  Column(
                    children: [
                      IconButton(
                        iconSize: 38,
                        color: const Color(0xFFC83E4D),
                        icon: const Icon(Icons.person),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProfileScreen(toggleMenu: toggleMenu),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 2),
                      const Text('Profile', style: TextStyle(color: Color(0xFFC83E4D))),
                    ],
                  ),
                ],
              ),
            ),
          ),
          if (_isMenuOpen)
            Positioned(
              bottom: 112,
              left: 0,
              child: Container(
                width: 108, // Adjust width as needed
                height: 262, // Maintain 16:9 aspect ratio
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildMenuItem(Icons.insert_emoticon, 'Mood Reports', () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MoodReportsScreen(toggleMenu: toggleMenu),
                        ),
                      );
                    }),
                    _buildMenuItem(Icons.opacity, 'Water Alerts', () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => WaterAlertsScreen(toggleMenu: toggleMenu),
                        ),
                      );
                    }),
                    _buildMenuItem(Icons.remove_red_eye_outlined, 'Blink Alert', () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BlinkAlertsScreen(toggleMenu: toggleMenu),
                        ),
                      );
                    })
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(IconData icon, String label, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: onTap,
            child: Icon(
              icon,
              color: const Color(0xFFC83E4D),
              size: 32,
            ),
          ),
          const SizedBox(height: 2),
          GestureDetector(
            onTap: onTap,
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Color(0xFFC83E4D),
                fontSize: 17,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void captureImage() async {
    try {
      if (Get
          .find<ImageDetection>()
          .isCameraInitialized
          .value) {
        final controller = Get
            .find<ImageDetection>()
            .cameraController;

        final image = await controller.takePicture();
        await classifyCapturedImage(image.path);
      } else {
        print('Camera not initialized');
      }
    } catch (e) {
      print('Error capturing image: $e');
    }
  }


  Future<void> classifyCapturedImage(String imagePath) async {
    try {
      final bytes = File(imagePath).readAsBytesSync();
      final results = await Get.find<ImageDetection>().classifyImage(imagePath);

      // Navigate to the TfliteResults page with the classification results
      Get.to(
          TfliteResults(result: results.isNotEmpty ? results[0] : 'Unknown'));
    } catch (e) {
      print('Error classifying image: $e');
    }
  }

  void main() {
    runApp(const MaterialApp(
      home: HomeScreen(),
    ));
  }
}

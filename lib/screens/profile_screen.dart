import 'package:flutter/material.dart';
import 'package:healthmate/screens/mood_reports.dart';
import 'package:healthmate/screens/home_screen.dart';
import 'package:healthmate/screens/water_alerts.dart';

import 'Blink.dart';

class ProfileScreen extends StatefulWidget {
  final VoidCallback toggleMenu;

  const ProfileScreen({super.key, required this.toggleMenu});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isMenuOpen = false;


  void toggleMenu() {
    setState(() {
      _isMenuOpen = !_isMenuOpen;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: Stack(
        children: [
          const Column(
            children: [
              Center(
                child: Text('This is the Profile Screen'),
              ),
            ],
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
            onTap: onTap, // Use the same onTap callback for both icon and text
            child: Icon(
              icon,
              color: const Color(0xFFC83E4D), // Adjust color as needed
              size: 32,
            ),
          ),
          const SizedBox(height: 2),
          GestureDetector(
            onTap: onTap, // Use the same onTap callback for both icon and text
            child: Text(
              label,
              textAlign: TextAlign.center, // Optionally, you can add this line for text alignment
              style: const TextStyle(
                color: Color(0xFFC83E4D), // Adjust color as needed
                fontSize: 17,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

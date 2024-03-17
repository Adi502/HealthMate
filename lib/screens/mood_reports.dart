import 'package:flutter/material.dart';
import 'package:healthmate/screens/water_alerts.dart';
import 'package:healthmate/screens/profile_screen.dart';
import 'package:healthmate/screens/home_screen.dart';
import 'package:healthmate/screens/moodalertscreens/questions.dart';

class MoodReportsScreen extends StatefulWidget {
  final VoidCallback toggleMenu;

  const MoodReportsScreen({super.key, required this.toggleMenu});

  @override
  _MoodReportsScreenState createState() => _MoodReportsScreenState();
}

class _MoodReportsScreenState extends State<MoodReportsScreen> {
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
        leading: IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const HomeScreen(),
              ),
            );
          },
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Color(0xFFC83E4D)),
        ),
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Mental HealthMate Text with Icon
                const Row(
                  children: [
                    Text(
                      'Mental',
                      style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold, color: Color(0xFFC83E4D)),
                    ),
                    Spacer(), // Spacer to push the icon to the right
                    Icon(
                      Icons.person_rounded, // Heart icon
                      size: 50,
                      color: Color(0xFFC83E4D), // Adjust icon color as needed
                    ),
                    Icon(
                      Icons.favorite_border_rounded, // Person icon (replace with an appropriate icon)
                      size: 50, // Adjust icon size as needed
                      color: Color(0xFFC83E4D), // Adjust icon color as needed
                    ),
                  ],
                ),
                const Text(
                  'HealthMate',
                  style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold, color: Color(0xFFC83E4D)),
                ),
                const SizedBox(height: 40),
                // Questionnaire Introduction
                const Text(
                  'Mental Health Questionnaire',
                  style: TextStyle(fontSize: 20, color: Color(0xFFC83E4D), fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                const Text(
                  'This assessment uses standardized questions to give you a sense of your risk for two very common and treatable conditions -- anxiety and depression.',
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 120),
                // Call to Action Button
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => questions(toggleMenu: toggleMenu,),
                        ),
                      );
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(const Color(0xFFC83E4D)),
                      padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                        const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                      ),
                    ),
                    child: const Text('Let\'s Begin', style: TextStyle(fontSize: 18, color: Colors.white)),
                  ),
                ),
                const SizedBox(height: 70),
              ],
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
                        icon: _isMenuOpen?const Icon(Icons.menu_open_rounded):const Icon(Icons.menu_rounded),
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
              bottom: 115,
              left: 0,
              child: Container(
                width: 108, // Adjust width as needed
                height: 244, // Maintain 16:9 aspect ratio
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildMenuItem(Icons.insert_emoticon, 'Mood Reports', () {

                    }),
                    _buildMenuItem(Icons.opacity, 'Water Alerts', () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              WaterAlertsScreen(
                                toggleMenu: toggleMenu,
                              ),
                        ),
                      );
                    }),
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

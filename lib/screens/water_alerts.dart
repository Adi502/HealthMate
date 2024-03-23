import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:background_fetch/background_fetch.dart';
import 'package:healthmate/screens/profile_screen.dart';
import 'package:healthmate/screens/home_screen.dart';
import 'package:healthmate/screens/mood_reports.dart';
import 'package:cool_alert/cool_alert.dart';
import 'dart:async';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';

import 'Blink.dart';

class WaterAlertsScreen extends StatefulWidget {
  final VoidCallback toggleMenu;

  const WaterAlertsScreen({super.key, required this.toggleMenu});

  @override
  _WaterAlertsScreenState createState() => _WaterAlertsScreenState();
}

class _WaterAlertsScreenState extends State<WaterAlertsScreen> {
  bool _isMenuOpen = false;
  int _selectedHours = 1; // Default value for hours
  String _selectedNotificationType = 'Send Notification';

  late Timer _notificationTimer;

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    _initializeNotifications();
    _initializeAlarmManager();
  }

  Future<void> _initializeNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings initializationSettings =
    InitializationSettings(android: initializationSettingsAndroid);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> _initializeAlarmManager() async {
    await AndroidAlarmManager.initialize();
  }

  Future<void> _initializeBackgroundFetch() async {
    var config = BackgroundFetchConfig(
      minimumFetchInterval: 15, // Minimum fetch interval in minutes
    );
    await BackgroundFetch.configure(config, YourBackgroundFetchCallback);
  }

  void YourBackgroundFetchCallback(String taskId) async{
    // Notification logic goes here
    await _sendNotification();
    BackgroundFetch.finish(taskId);
  }

  Future<void> _sendNotification() async{
    int delayInSeconds = _selectedHours * 3600;

    // Schedule the notification
    _notificationTimer = Timer.periodic(Duration(seconds: delayInSeconds), (Timer timer) async {
      final AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'your_channel_id',
        'your_channel_name',
        importance: Importance.max,
        priority: Priority.high,
        showWhen: false,
      );
      final NotificationDetails platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);
      await flutterLocalNotificationsPlugin.show(
        0, // Notification ID
        'Reminder', // Notification title
        'Drink water', // Notification body
        platformChannelSpecifics,
      );
    });
  }


  void _cancelAlerts() {
    _notificationTimer.cancel();
  }

  void _ringAlarm() {
    int delayInSeconds = _selectedHours * 3600; // Convert hours to seconds
    AndroidAlarmManager.periodic(Duration(seconds: delayInSeconds),0, _alarmCallback);
  }

  static void _alarmCallback() {
    FlutterRingtonePlayer().play(
      android: AndroidSounds.notification,
      ios: IosSounds.glass,
      volume: 0.5,
      looping: true,
      asAlarm: true,
    );
  }

  void toggleMenu() {
    setState(() {
      _isMenuOpen = !_isMenuOpen;
    });
  }

  void _handleSubmit() async {
    CoolAlert.show(
      context: context,
      type: CoolAlertType.success,
      text: _selectedNotificationType == 'Send Notification'
          ? 'You will be notified to drink water after every $_selectedHours hours'
          : 'You will receive an alarm to drink water after every $_selectedHours hours',
    );

    if (_selectedNotificationType == 'Send Notification') {
      _sendNotification();
    } else {
      // Request permission to access the device's audio
      var status = await Permission.notification.request();
      if (status.isGranted) {
        _ringAlarm();
      } else {
        // Handle permission denied
        print('Permission denied to access the device audio.');
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'WaterAlerts',
          textAlign: TextAlign.center,
          style: TextStyle(color: Color(0xFFC83E4D), fontSize: 25, fontWeight: FontWeight.bold),
        ),
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
          Column(
            children: [
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(left: 15.0, right: 4),
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      const Text(
                        "Please select how often you'd like to receive water intake reminders and the type of alert.",
                        style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: 30),
                      Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFFC83E4D),
                          borderRadius: BorderRadius.circular(25.0), // Adjust the border radius as needed
                        ),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                      padding: const EdgeInsets.all(1.0),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFC83E4D),
                                        borderRadius: BorderRadius.circular(25.0), // Adjust the border radius as needed
                                      ),
                                      child: const Text(
                                        'Alert will be sent after every',
                                        style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10), // Add spacing between the text and dropdown
                                  Container(
                                    width: 120,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(25.0), // Adjust the border radius as needed
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.5), // Adjust shadow color as needed
                                          spreadRadius: 2,
                                          blurRadius: 3,
                                          offset: const Offset(0, 1), // changes position of shadow
                                        ),
                                      ],
                                    ),
                                    child: DropdownButton<int>(
                                      value: _selectedHours,
                                      items: const [
                                        DropdownMenuItem<int>(
                                          value: 1,
                                          child: Padding(
                                            padding: EdgeInsets.only(left: 10.0), // Adjust the left padding as needed
                                            child: Text(
                                              'hour',
                                              style: TextStyle(color: Color(0xFFC83E4D), fontSize: 18),
                                            ),
                                          ),
                                        ),
                                        DropdownMenuItem<int>(
                                          value: 2,
                                          child: Padding(
                                            padding: EdgeInsets.only(left: 10.0), // Adjust the left padding as needed
                                            child: Text(
                                              '2 hours',
                                              style: TextStyle(color: Color(0xFFC83E4D), fontSize: 18),
                                            ),
                                          ),
                                        ),
                                        DropdownMenuItem<int>(
                                          value: 3,
                                          child: Padding(
                                            padding: EdgeInsets.only(left: 10.0), // Adjust the left padding as needed
                                            child: Text(
                                              '3 hours',
                                              style: TextStyle(color: Color(0xFFC83E4D), fontSize: 18),
                                            ),
                                          ),
                                        ),
                                      ],
                                      onChanged: (value) {
                                        setState(() {
                                          _selectedHours = value!;
                                        });
                                      },
                                      dropdownColor: Colors.white, // Adjust dropdown background color if needed
                                      underline: const SizedBox(),
                                      iconSize: 30,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Center(
                              // Center the divider
                              child: SizedBox(
                                // Specify the desired length of the divider
                                width: 370, // Adjust the width of the divider as needed
                                child: Divider(
                                  color: Colors.white, // Adjust the color of the divider to match the background color
                                  thickness: 1, // Adjust the thickness of the divider as needed
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                      padding: const EdgeInsets.all(1.0),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFC83E4D),
                                        borderRadius: BorderRadius.circular(25.0), // Adjust the border radius as needed
                                      ),
                                      child: const Text(
                                        'You will be notified by',
                                        style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10), // Add spacing between the text and dropdown
                                  Container(
                                    width: 180,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(25.0), // Adjust the border radius as needed
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.5), // Adjust shadow color as needed
                                          spreadRadius: 2,
                                          blurRadius: 3,
                                          offset: const Offset(0, 1), // changes position of shadow
                                        ),
                                      ],
                                    ),
                                    child: DropdownButton<String>(
                                      value: _selectedNotificationType,
                                      items: const [
                                        DropdownMenuItem<String>(
                                          value: 'Ring Alarm',
                                          child: Padding(
                                            padding: EdgeInsets.only(left: 8.0), // Adjust the left padding as needed
                                            child: Text(
                                              'Alarm',
                                              style: TextStyle(color: Color(0xFFC83E4D), fontSize: 18),
                                            ),
                                          ),
                                        ),
                                        DropdownMenuItem<String>(
                                          value: 'Send Notification',
                                          child: Padding(
                                            padding: EdgeInsets.only(left: 8.0), // Adjust the left padding as needed
                                            child: Text(
                                              'Notification',
                                              style: TextStyle(color: Color(0xFFC83E4D), fontSize: 18),
                                            ),
                                          ),
                                        ),
                                      ],
                                      onChanged: (value) {
                                        setState(() {
                                          _selectedNotificationType = value!;
                                        });
                                      },
                                      dropdownColor: Colors.white, // Adjust dropdown background color if needed
                                      underline: const SizedBox(),
                                      iconSize: 30,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 40,),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(25.0), // Adjust the border radius as needed
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.5), // Adjust shadow color as needed
                              spreadRadius: 2,
                              blurRadius: 3,
                              offset: const Offset(0, 1), // changes position of shadow
                            ),
                          ],
                        ),
                        child: ElevatedButton(
                          onPressed: _handleSubmit,
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25.0), // Adjust the border radius as needed
                            ),
                            shadowColor: Colors.white.withOpacity(0.5), // Adjust shadow color as needed
                            elevation: 0, // Set elevation to 0 to remove shadow
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text('Submit', style: TextStyle(color: Color(0xFFC83E4D),fontSize: 18)), // Adjust text color as needed
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 40,),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(25.0), // Adjust the border radius as needed
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.5), // Adjust shadow color as needed
                              spreadRadius: 2,
                              blurRadius: 3,
                              offset: const Offset(0, 1), // changes position of shadow
                            ),
                          ],
                        ),
                        child: ElevatedButton(
                          onPressed: _cancelAlerts,
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25.0), // Adjust the border radius as needed
                            ),
                            shadowColor: Colors.white.withOpacity(0.5), // Adjust shadow color as needed
                            elevation: 0, // Set elevation to 0 to remove shadow
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text('Cancel your alerts', style: TextStyle(color: Color(0xFFC83E4D),fontSize: 18)), // Adjust text color as needed
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
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



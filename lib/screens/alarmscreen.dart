import 'package:flutter/material.dart';

import 'package:system_alert_window/system_alert_window.dart';

class AlarmScreen extends StatefulWidget {
  final VoidCallback toggleMenu;

  const AlarmScreen({super.key, required this.toggleMenu});

  @override
  _AlarmScreenState createState() => _AlarmScreenState();
}

class _AlarmScreenState extends State<AlarmScreen> {
  bool _isMenuOpen = false;
  

  void toggleMenu() {
    setState(() {
      _isMenuOpen = !_isMenuOpen;
    });
  }

  @override void initState(){
    // TODO: implement initState
    getPermission();
    super.initState();

  }

  getPermission()async{
    SystemAlertWindow.requestPermissions;
  }





  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Alarm'),
      ),
      body: Stack(
        children: [
          const Expanded(
            child: Center(
              child: Text('This is the Alarm Screen'),
            ),
          ),
          ElevatedButton(
            child:const Text('Show'),
          onPressed: (){
            SystemAlertWindow.showSystemWindow(
              gravity: SystemWindowGravity.CENTER,
              height: 500,
              notificationTitle: 'Hi this is header',
              notificationBody: "Abc"
            );
    },),
          ElevatedButton(
            child:const Text('Close'),
            onPressed: (){
              SystemAlertWindow.closeSystemWindow();
            },)

        ],
      ),
    );
  }

}

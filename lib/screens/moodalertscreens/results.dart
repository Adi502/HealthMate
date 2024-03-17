import 'package:flutter/material.dart';
import 'package:healthmate/score_report.dart'; // Import the ScoreReports class
import 'package:healthmate/screens/mood_reports.dart';
import 'package:url_launcher/url_launcher.dart'; // Import url_launcher package
import 'package:url_launcher/url_launcher_string.dart';
import 'package:vcard_maintained/vcard_maintained.dart';

class ResultsScreen extends StatelessWidget {
  final int totalScore;

  const ResultsScreen({Key? key, required this.totalScore}) : super(key: key);

  void toggleMenu() {}

  @override
  Widget build(BuildContext context) {
    String report = '';
    // Find the paragraph of text corresponding to the total score range
    for (final entry in ScoreReports.scoreReports.entries) {
      if (totalScore <= entry.key) {
        report = entry.value;
        break;
      }
    }

    Widget _buildContactCard(VCard vCard) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Doctor Contact Information:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text('Name: ${vCard.firstName} ${vCard.middleName} ${vCard.lastName}'),
              Text('Clinic: ${vCard.organization}'),
              SizedBox(height: 16),
              Row(
                children: [
                  ElevatedButton.icon(
                    onPressed: () async {
                      String telUrl = 'tel:${vCard.workPhone}';
                      if (await canLaunch(telUrl)) {
                        await launch(telUrl);
                      } else {
                        throw 'Could not launch $telUrl';
                      }
                    },
                    icon: Icon(Icons.phone),
                    label: Text('Call'),
                  ),
                  SizedBox(width: 16),
                  ElevatedButton.icon(
                    onPressed: () async {
                      String? websiteUrl = vCard.url;
                      if (await canLaunchUrlString(websiteUrl!)) {
                        await launchUrlString(websiteUrl);
                      } else {
                        throw 'Could not launch $websiteUrl';
                      }
                    },
                    icon: Icon(Icons.web),
                    label: Text('Website'),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MoodReportsScreen(toggleMenu: toggleMenu),
              ),
            );
          },
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Color(0xFFC83E4D)),
        ),
        title: const Text(
          'Mental HealthMate',
          style: TextStyle(color: Color(0xFFC83E4D), fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Results',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                children: [
                  const Spacer(),
                  Text(
                    'Total Score: $totalScore/100',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black45,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Text(
                report,
                textAlign: TextAlign.left,
                style: const TextStyle(
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                "If you are feeling low or depressed, please contact our trusted psychiatrist for support.",
                textAlign: TextAlign.left,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              // Display the contact card if the score is in the specified range
              if (totalScore <= 30) _buildContactCard(
                  VCard()
                    ..firstName = 'FirstName'
                    ..middleName = 'MiddleName'
                    ..lastName = 'LastName'
                    ..organization = 'ActivSpaces Labs'
                    ..workPhone = 'Work Phone Number'
                    ..birthday = DateTime.now()
                    ..jobTitle = 'Software Developer'
                    ..url = 'https://www.google.com/'
                    ..note = 'Notes on contact'
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:healthmate/screens/mood_reports.dart';
import 'package:healthmate/screens/moodalertscreens/results.dart';
import 'dart:math';

class questions extends StatefulWidget {
  final VoidCallback toggleMenu;

  const questions({super.key, required this.toggleMenu});

  @override
  _questionsState createState() => _questionsState();
}

class _questionsState extends State<questions> {

  @override
  void initState() {
    super.initState();
    // Shuffle the questionOptions list
    questionOptions.shuffle(Random());
  }

  bool _isMenuOpen = false;

  bool isAllQuestionsAnswered() {
    // Check if all questions have a selected option
    for (int i = 0; i < questionOptions.length-9; i++) {
      final question = questionOptions[i];
      if (question['selectedOption'] == null || question['selectedOption'] == '') {
        return false;
      }
    }
    return true;
  }

  void toggleMenu() {
    setState(() {
      _isMenuOpen = !_isMenuOpen;
    });
  }

  List<Map<String, dynamic>> questionOptions = [
    {
      'question': "How's your mood today?",
      'options': {
        'Great':10,
        'Good':8,
        'Okay':6,
        'Not so good':4,
        'Bad': 2,
      },
      'selectedOption': '',
    },
    {
      'question': "How well did you sleep last night?",
      'options': {
        'Like a baby':10,
        'Pretty well':8,
        'Okay, I guess':6,
        'Not to good':4,
        'Terribly':2,
      },
      'selectedOption': '',
    },
    {
      'question': "Feeling any physical tension or discomfort at the moment?",
      'options': {
        'None':10,
        'Mild':8,
        'Moderate':6,
        'Severe':4,
        'Very severe': 2,
      },
      'selectedOption': '',
    },
    {
      'question': "How motivated do you feel to do things today?",
      'options': {
        'Super motivated!':10,
        'Pretty motivated':8,
        'Eh, so-so':6,
        'Not very motivated':4,
        'Zero motivation':2,
      },
      'selectedOption': '',
    },
    {
      'question': "Are you experiencing any worries or anticipatory thoughts right now?",
      'options': {
        'Nope, all good!':10,
        'A little bit':8,
        'Somewhat':6,
        'Quite a bit':4,
        'Yes, very much':2,
      },
      'selectedOption': '',
    },
    {
      'question': "Feeling anxious or worried about anything today?",
      'options': {
        'Nope, all good!':10,
        'A little bit':8,
        'Somewhat':6,
        'Quite a bit':4,
        'Yes, very much':2,
      },
      'selectedOption': '',
    },
    {
      'question': "How mentally focused are you feeling today?",
      'options': {
        'Sharp-minded':10,
        'Alert':8,
        'Neutral':6,
        'Foggy':4,
        'Distracted':2,
      },
      'selectedOption': '',
    },
    {
      'question': "How's your appetite today?",
      'options': {
        'Ravenous!':10,
        'Hungry':8,
        'Not really hungry':6,
        'Barely hungry':4,
        'Not hungry at all':2,
      },
      'selectedOption': '',
    },
    {
      'question': "Feeling detached from others or emotionally numb?",
      'options': {
        'Not at all':10,
        'Rarely':8,
        'Sometimes':6,
        'Often':4,
        'Always':2,
      },
      'selectedOption': '',
    },{
      'question': "Thoughts of worthlessness or excessive guilt?",
      'options': {
        'Rarely or never':10,
        'Occasionally':8,
        'Few of the times':6,
        'Frequently':4,
        'Almost always':2,
      },
      'selectedOption': '',
    },
  ];

  // Define the scores for each option
  // static const Map<String, int> optionScores = {
  //   'Not at all': 7,
  //   'Several Days': 5,
  //   'More Than half the days': 3,
  //   'Nearly Everyday': 2,
  // };

  int calculateTotalScore() {
    int totalScore = 0;
    for (int i = 0; i < questionOptions.length; i++) {
      final selectedOption = questionOptions[i]['selectedOption'];
      final options = questionOptions[i]['options'];
      // Ensure selectedOption is not null and options is a map
      if (selectedOption != null && options is Map<String, int>) {
        // Use the selected option to retrieve the score from the options map
        totalScore += options[selectedOption] ?? 0;
      }
    }
    return totalScore;
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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(20),
            child: Text(
              'How often have the following issues disturbed you in the past two weeks?',
              style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: questionOptions.length,
              itemBuilder: (BuildContext context, int index) {
                final questionData = questionOptions[index];
                return QuestionCard(
                  questionIndex: index,
                  questionNumber: index,
                  question: questionData['question']!,
                  options: questionData['options']!,
                  selectedOption: questionData['selectedOption'],
                  onTap: (String option) {
                    setState(() {
                      questionOptions[index]['selectedOption'] = option;
                    });
                  },
                );
              },
            ),
          ),
            Center(
              child: ElevatedButton(
                onPressed: isAllQuestionsAnswered() ? _onDonePressed : null,
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.resolveWith<Color?>(
                      (Set<MaterialState> states) {
                        if (states.contains(MaterialState.disabled)) {
                          // Disabled color
                            return Colors.grey;
                        }
                        // Enabled color
                        return const Color(0xFFC83E4D);
                      },
                    ),
                    padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                ),
              ),
                child: const Text(
                  'Done',
                    style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                  ),
            ),
          ),
        ],
      ),
    );
  }
  void _onDonePressed() {
    if (isAllQuestionsAnswered()) {
      // Navigate to the desired screen
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ResultsScreen(totalScore: calculateTotalScore()),
        ),
      );
    }
  }

  String generateSampleReport() {
    // This is a placeholder method to generate a sample report
    return 'This is a sample report. Your mental health is important. Stay positive and take care of yourself!';
  }

}

class QuestionCard extends StatelessWidget {
  final int questionIndex;
  final int questionNumber;
  final String question;
  final Map<String, int> options;
  final String? selectedOption;
  final Function(String) onTap;

  const QuestionCard({
    required this.questionIndex,
    required this.questionNumber,
    required this.question,
    required this.options,
    required this.selectedOption,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      elevation: 3.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Question ${questionNumber + 1} of 10',
              style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold, color: Colors.black26),
            ),
            const SizedBox(height: 10.0),
            Text(
              question,
              style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10.0),
            // Iterate over the options map
            for (final entry in options.entries)
              OptionButton(
                option: entry.key, // Pass the option label
                optionScore: entry.value, // Pass the option score
                isSelected: selectedOption == entry.key,
                onTap: () => onTap(entry.key),
              ),
          ],
        ),
      ),
    );
  }
}



class OptionButton extends StatelessWidget {
  final String option;
  final int optionScore; // Add optionScore parameter
  final bool isSelected;
  final VoidCallback onTap;

  const OptionButton({
    required this.option,
    required this.optionScore, // Add optionScore parameter
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFC83E4D) : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(10.0),
        ),
        margin: const EdgeInsets.symmetric(vertical: 5.0),
        child: Row(
          children: [
            Icon(
              isSelected ? Icons.check_circle : Icons.radio_button_unchecked,
              color: isSelected ? Colors.white : const Color(0xFFC83E4D),
            ),
            const SizedBox(width: 10.0),
            Text(
              option,
              style: TextStyle(
                fontSize: 16.0,
                color: isSelected ? Colors.white : Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}




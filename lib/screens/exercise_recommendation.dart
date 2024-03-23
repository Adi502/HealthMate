import 'package:flutter/material.dart';
import 'package:healthmate/screens/home_screen.dart';

class ExerciseRecommendation extends StatelessWidget {
  final int requiredCalories;

  const ExerciseRecommendation({Key? key, required this.requiredCalories}) : super(key: key);

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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Total Calories to burn $requiredCalories',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            ExerciseCard(
              title: 'Walking',
              icon: Icon(Icons.directions_walk_rounded,color: Color(0xFFC83E4D), size: 130,),
              caloriesBurnedPerHour: 200, // Example value
              requiredCalories: requiredCalories, // Pass required calories to ExerciseCard
            ),
            SizedBox(height: 16),
            ExerciseCard(
              title: 'Running',
              icon: Icon(Icons.directions_run_rounded,color: Color(0xFFC83E4D), size: 130,),
              caloriesBurnedPerHour: 500, // Example value
              requiredCalories: requiredCalories, // Pass required calories to ExerciseCard
            ),
            SizedBox(height: 16),
            ExerciseCard(
              title: 'Cycling',
              icon: Icon(Icons.directions_bike_rounded,color: Color(0xFFC83E4D), size: 130,),
              caloriesBurnedPerHour: 400, // Example value
              requiredCalories: requiredCalories, // Pass required calories to ExerciseCard
            ),
          ],
        ),
      ),
    );
  }
}

class ExerciseCard extends StatelessWidget {
  final String title;
  final Icon icon;
  final int caloriesBurnedPerHour;
  final int requiredCalories;

  const ExerciseCard({
    Key? key,
    required this.title,
    required this.icon,
    required this.caloriesBurnedPerHour,
    required this.requiredCalories,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Calculate duration required to burn required calories
    int hours = (requiredCalories / caloriesBurnedPerHour).floor();
    int minutes = ((requiredCalories / caloriesBurnedPerHour) * 60).round() % 60;

    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.grey[200],
      ),
      child: Row(
        children: [
          icon,
          SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(fontSize: 25, color: Color(0xFFC83E4D), fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text('Time: $hours hr $minutes mins', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,),),
            ],
          ),
        ],
      ),
    );
  }
}






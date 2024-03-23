import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'home_screen.dart';

class TfliteResults extends StatefulWidget {
  final String result;

  const TfliteResults({Key? key, required this.result}) : super(key: key);

  @override
  _TfliteResultsState createState() => _TfliteResultsState();
}

class _TfliteResultsState extends State<TfliteResults> {
  late Future<Map<String, dynamic>> _recipeDetailsFuture;

  @override
  void initState() {
    super.initState();
    _recipeDetailsFuture = fetchRecipeDetails(widget.result);
  }

  Future<Map<String, dynamic>> fetchRecipeDetails(String foodName) async {
    final apiKey = 'b2562c5c50094b289ab0c5b3bd28a1a5';
    final baseUrl = 'https://api.spoonacular.com/recipes/complexSearch';
    final queryParameters = {
      'apiKey': apiKey,
      'query': foodName,
      'number': '1', // Limit to 1 result for simplicity
      'addRecipeInformation': 'true', // Include recipe information
      'addRecipeNutrition': 'true', // Include recipe nutrition
    };

    final uri = Uri.parse(baseUrl).replace(queryParameters: queryParameters);
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      return data;
    } else {
      throw Exception('Failed to fetch recipe details');
    }
  }

  void fetchAndDisplayRecipeDetails(String foodName) {
    fetchRecipeDetails(foodName).then((data) {
      // Parse the data and display recipe details
      // Example:
      final recipes = data['results'];
      if (recipes.isNotEmpty) {
        final recipe = recipes[0];
        final recipeTitle = recipe['title'];
        final imageUrl = recipe['image'];
        final ingredients = recipe['extendedIngredients'];
        final nutrition = recipe['nutrition'];

        print('Recipe Title: $recipeTitle');
        print('Image URL: $imageUrl');
        print('Ingredients: $ingredients');
        print('Nutrition: $nutrition');
      }
    }).catchError((error) {
      print('Error fetching recipe details: $error');
    });
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.result,
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
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: Color(0xFFC83E4D)),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Stack(
              children: [
                IconButton(
                  onPressed: () {
                    // Action when the hearts logo is pressed
                  },
                  icon: Icon(Icons.heart_broken_outlined, color: Color(0xFFC83E4D), size: 32,),
                ),
                Positioned(
                  right: 0,
                  child: Container(
                    padding: EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Color(0xFFC83E4D),
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      '1',
                      style: TextStyle(color: Colors.white,fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),

      body: FutureBuilder<Map<String, dynamic>>(
        future: _recipeDetailsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final data = snapshot.data!['results'][0];
            final imageUrl = data['image'] ?? '';
            final ingredients = data['nutrition']['ingredients'] ?? [];
            final nutritionalInfo = data['nutrition']['nutrients'] ?? [];

            return ListView(
              children: [
                // Image with rounded borders
                Container(
                  margin: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.grey[300],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      imageUrl,
                      fit: BoxFit.fill,
                      width: double.infinity,
                      height: 200, // Adjust the height as needed
                    ),
                  ),
                ),
                SizedBox(height: 20),
                // Ingredients section
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Ingredients',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8),
                      // Display ingredients in a row
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          for (var ingredient in ingredients)
                            Chip(
                              label: Text(ingredient['name']),
                              backgroundColor: Color(0xFFC83E4D).withOpacity(0.5),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                // Nutritional Information section
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Nutritional Information',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8),
                      // Display nutritional information for specific nutrients
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          for (var nutrient in nutritionalInfo)
                            if (['Carbohydrate', 'Calories', 'Protien', 'Fat', 'Sugar', 'Cholesterol'].contains(nutrient['name']))
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 4),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('${nutrient['name']}:'),
                                    Text(
                                      '${nutrient['amount']} ${nutrient['unit']}',
                                      style: TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                        ],
                      ),
                      SizedBox(height: 20),
                      Center(
                        child: ElevatedButton(
                          onPressed: () {

                          },
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(const Color(0xFFC83E4D)),
                            padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                              const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                            ),
                          ),
                          child: const Text('Burn These', style: TextStyle(fontSize: 18, color: Colors.white)),
                        ),
                      ),
                      SizedBox(height: 20),
                    ],
                  ),
                ),
              ],
            );
          } else {
            return Center(child: Text('No data available'));
          }
        },
      ),

    );
  }

}

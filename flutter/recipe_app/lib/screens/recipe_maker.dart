import 'package:flutter/material.dart';
import 'package:recipe_app/dep/showlist.dart';
import 'package:google_fonts/google_fonts.dart'; // Added import

class recipe_maker extends StatelessWidget {
  final Recipe recipe; 

  const recipe_maker({Key? key, required this.recipe}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/home.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.black.withOpacity(0.6), Colors.transparent],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SafeArea(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: Icon(Icons.arrow_back_ios, color: Colors.white),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      Text(
                        recipe.recipename,
                        style: GoogleFonts.acme( // Added GoogleFonts.acme style
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: 48), 
                    ],
                  ),
                ),
                SizedBox(height: 20),
                ClipRRect(
                  borderRadius: BorderRadius.circular(16.0),
                  child: Image.asset(
                    'assets/${recipe.image}',
                    width: double.infinity,
                    height: 250.0,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  recipe.recipename,
                  style: GoogleFonts.acme( // Added GoogleFonts.acme style
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 20),
                  Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('assets/containerimage.jpg'),
                            fit: BoxFit.cover,
                          ),
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.6), 
                          borderRadius: BorderRadius.circular(16.0),
                          boxShadow: [
                            BoxShadow(color: Colors.black26, blurRadius: 8.0),
                          ],
                        ),
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Ingredients to be added in order: \n\n',
                              style: GoogleFonts.acme( // Added GoogleFonts.acme style
                                fontSize: 18, 
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            _buildIngredientsText(),
                            SizedBox(height: 20),
                            Text(
                              'Cooking Time: ${_getCookingTime()}',
                              style: GoogleFonts.acme( // Added GoogleFonts.acme style
                                fontSize: 16, 
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIngredientsText() {
    String ingredients = '';
    switch (recipe.recipename) {
      case 'Biriyani':
        ingredients = '''        1. Basmati Rice (2 cups)
        2. Chicken (500g)
        3. Spices (as per taste)
        4. Oil (3 tbsp)
        5. Salt (to taste)
        6. Water (4 cups)
        7. Onions (2 medium, sliced)
        8. Tomatoes (2 medium, chopped)
        9. Curd (1/2 cup)
        10. Mint Leaves (a handful)''';
        break;
      case 'Pizza':
        ingredients = '''        1. Pizza Base (1)
        2. Pizza Sauce (1/2 cup)
        3. Cheese (200g)
        4. Toppings (as desired)
        5. Oregano (1 tsp)
        6. Chilli Flakes (1 tsp)
        7. Salt (to taste)
        8. Pepper (1 tsp)
        9. Olive Oil (1 tbsp)
        10. Garlic (2 cloves, minced)''';
        break;
      case 'Pasta':
        ingredients = '''        1. Pasta (200g)
        2. Olive Oil (2 tbsp)
        3. Garlic (2 cloves, minced)
        4. Onion (1 medium, chopped)
        5. Tomatoes (2, chopped)
        6. Cream (1/2 cup)
        7. Parmesan Cheese (1/4 cup)
        8. Salt (to taste)
        9. Pepper (1 tsp)
        10. Basil (a handful)''';
        break;
      case 'Burger':
        ingredients = '''        1. Burger Buns (2)
        2. Ground Beef (200g)
        3. Cheese (2 slices)
        4. Lettuce (2 leaves)
        5. Tomato (1, sliced)
        6. Onion (1, sliced)
        7. Pickles (2-3 slices)
        8. Ketchup (1 tbsp)
        9. Mayonnaise (1 tbsp)
        10. Mustard (1 tbsp)''';
        break;
      case 'Sandwich':
        ingredients = '''        1. Bread (2 slices)
        2. Cheese (2 slices)
        3. Ham (2 slices)
        4. Lettuce (2 leaves)
        5. Tomato (1, sliced)
        6. Cucumber (1/2, sliced)
        7. Mayonnaise (1 tbsp)
        8. Mustard (1 tbsp)
        9. Salt (to taste)
        10. Pepper (1 tsp)''';
        break;
      case 'Noodles':
        ingredients = '''        1. Noodles (200g)
        2. Oil (2 tbsp)
        3. Garlic (2 cloves, minced)
        4. Onion (1 medium, chopped)
        5. Carrot (1, julienned)
        6. Bell Pepper (1, sliced)
        7. Soy Sauce (2 tbsp)
        8. Salt (to taste)
        9. Pepper (1 tsp)
        10. Green Onion (1 stalk, chopped)''';
        break;
      case 'Fried Rice':
        ingredients = '''        1. Rice (2 cups, cooked)
        2. Oil (2 tbsp)
        3. Eggs (2, scrambled)
        4. Onion (1 medium, chopped)
        5. Carrot (1, chopped)
        6. Green Peas (1/2 cup)
        7. Soy Sauce (2 tbsp)
        8. Salt (to taste)
        9. Pepper (1 tsp)
        10. Spring Onion (1 stalk, chopped)''';
        break;
      case 'Pancake':
        ingredients = '''        1. Flour (1 cup)
        2. Eggs (2)
        3. Milk (1 cup)
        4. Baking Powder (1 tsp)
        5. Sugar (2 tbsp)
        6. Salt (1/2 tsp)
        7. Butter (2 tbsp, melted)
        8. Vanilla Extract (1 tsp)
        9. Maple Syrup (for serving)
        10. Blueberries (1/2 cup)''';
        break;
      case 'Dosa':
        ingredients = '''        1. Rice (2 cups)
        2. Urad Dal (1 cup)
        3. Fenugreek Seeds (1 tsp)
        4. Water (as needed)
        5. Salt (to taste)
        6. Oil (for frying)
        7. Tamarind (1 tbsp)
        8. Jaggery (1 tbsp)
        9. Coconut (grated, for chutney)
        10. Cumin Seeds (1 tsp)''';
        break;
      case 'Idli':
        ingredients = '''        1. Rice (2 cups)
        2. Urad Dal (1 cup)
        3. Water (as needed)
        4. Salt (to taste)
        5. Oil (for greasing)
        6. Mustard Seeds (1/2 tsp)
        7. Curry Leaves (a few)
        8. Coconut (grated, for chutney)
        9. Ginger (1 tsp, chopped)
        10. Green Chilies (2, chopped)''';
        break;
      default:
        ingredients = 'Ingredients not available for this recipe';
        break;
    }
    return Text(
      ingredients,
      style: GoogleFonts.acme( // Added GoogleFonts.acme style
        fontSize: 16,
      ),
    );
  }

  String _getCookingTime() {
    switch (recipe.recipename) {
      case 'Biriyani': return '45 minutes';
      case 'Pizza': return '15-20 minutes';
      case 'Pasta': return '20 minutes';
      case 'Burger': return '15 minutes';
      case 'Sandwich': return '5 minutes';
      case 'Noodles': return '10 minutes';
      case 'Fried Rice': return '15 minutes';
      case 'Pancake': return '10 minutes';
      case 'Dosa': return '30 minutes';
      case 'Idli': return '15-20 minutes';
      default: return 'Time not available';
    }
  }
}

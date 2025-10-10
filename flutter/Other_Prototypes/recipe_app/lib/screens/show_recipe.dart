import 'package:flutter/material.dart';
import 'package:recipe_app/dep/showlist.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:recipe_app/screens/recipe_maker.dart';

class ShowRecipe extends StatefulWidget {
  const ShowRecipe({super.key});

  @override
  State<ShowRecipe> createState() => _ShowRecipeState();
}

class _ShowRecipeState extends State<ShowRecipe> {
  List<Recipe> Recipes = [
    Recipe(recipename: 'Biriyani', image: 'biriyani.jpg'),
    Recipe(recipename: 'Pizza', image: 'pizza.jpg'),
    Recipe(recipename: 'Pasta', image: 'pasta.jpg'),
    Recipe(recipename: 'Burger', image: 'burger.jpg'),
    Recipe(recipename: 'Sandwich', image: 'sandwich.jpg'),
    Recipe(recipename: 'Noodles', image: 'noodles.jpg'),
    Recipe(recipename: 'Fried Rice', image: 'fried_rice.jpg'),
    Recipe(recipename: 'Pancake', image: 'pancake.jpg'),
    Recipe(recipename: 'Dosa', image: 'dosa.jpg'),
    Recipe(recipename: 'Idli', image: 'idli.jpg'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
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
                colors: [Colors.black.withOpacity(0.5), Colors.transparent],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          Positioned(
            top: 20.0,
            left: 10.0,
            child: IconButton(
              icon: Icon(Icons.arrow_back_ios),
              iconSize: 30.0,
              color: Colors.white,
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 40.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GridView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 15.0,
                        mainAxisSpacing: 15.0,
                        childAspectRatio: 1.2,
                      ),
                      itemCount: Recipes.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => recipe_maker(recipe: Recipes[index]),
                                ),
                              );
                            },
                            child: Card(
                              color: Colors.white.withOpacity(0.8),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              elevation: 10.0,
                              child: Column(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(20.0),
                                    child: Image.asset(
                                      'assets/${Recipes[index].image}',
                                      width: double.infinity,
                                      height: 120.0,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      Recipes[index].recipename,
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.acme(
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

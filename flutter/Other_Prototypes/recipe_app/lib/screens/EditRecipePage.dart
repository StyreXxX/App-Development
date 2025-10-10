import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:google_fonts/google_fonts.dart';
import 'package:recipe_app/screens/add_recipe.dart';

class EditRecipePage extends StatelessWidget {
  final Map<String, dynamic> task;
  final Function(Map<String, dynamic>)
      onSave; 

  const EditRecipePage({super.key, required this.task, required this.onSave});

  @override
  Widget build(BuildContext context) {
    final TextEditingController nameController =
        TextEditingController(text: task['name']);
    final TextEditingController descriptionController =
        TextEditingController(text: task['description'] ?? '');
    final XFile? image = task['image'];

    return Scaffold(
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/home.jpg'),
              fit: BoxFit.cover,
            ),
          ),
          child: Stack(
            children: [
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
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 40.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Edit Recipe',
                            style: GoogleFonts.oxygen(
                              textStyle: TextStyle(
                                color: Colors.white,
                                fontSize: 32.0,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 40),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: image != null
                            ? Image.file(
                                File(image.path),
                                width: MediaQuery.of(context).size.width * .9,
                                height: 200.0,
                                fit: BoxFit.cover,
                              )
                            : Image.asset(
                                'assets/placeholder.jpg',
                                width: 200.0,
                                height: 200.0,
                                fit: BoxFit.cover,
                              ),
                      ),
                      SizedBox(height: 20),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 8.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Text(
                          task['name'],
                          style: TextStyle(
                              fontSize: 30.0, fontWeight: FontWeight.normal),
                        ),
                      ),
                      SizedBox(height: 20),
                      SizedBox(
                        height: 200,
                        child: TextField(
                          controller: descriptionController,
                          maxLines: null,
                          minLines: 12,
                          decoration: const InputDecoration(
                            hintText: 'Enter Recipe Description',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                bottom: 40.0,
                left: MediaQuery.of(context).size.width * 0.3,
                child: ElevatedButton(
                  onPressed: () {
                    // Save the changes and update the parent widget
                    task['description'] = descriptionController.text;
                    task['name'] = nameController.text;
                    onSave(task); // Call the callback function
                    Navigator.pop(context);
                  },
                  child: Text('Save Changes'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white.withOpacity(0.6),
                    padding: EdgeInsets.symmetric(
                      horizontal: 50.0,
                      vertical: 15.0,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

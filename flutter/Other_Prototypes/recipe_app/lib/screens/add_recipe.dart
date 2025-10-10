import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:recipe_app/screens/EditRecipePage.dart';
import 'package:recipe_app/dep/taskCard.dart';

class AddRecipe extends StatefulWidget {
  const AddRecipe({super.key});

  @override
  State<AddRecipe> createState() => _AddRecipeState();
}

class _AddRecipeState extends State<AddRecipe> {
  final List<Map<String, dynamic>> tasks = [];
  final TextEditingController taskController = TextEditingController();
  XFile? _image;
  final ImagePicker _picker = ImagePicker();

  void addTask() {
    if (taskController.text.isNotEmpty && _image != null) {
      setState(() {
        tasks.add({
          'name': taskController.text,
          'image': _image,
        });
        taskController.clear();
        _image = null;
      });
    }
  }

  Future<void> _pickImage() async {
    try {
      final XFile? pickedImage =
          await _picker.pickImage(source: ImageSource.gallery);
      if (pickedImage != null) {
        setState(() {
          _image = pickedImage;
        });
      }
    } catch (e) {
      print("Error picking image: $e");
    }
  }

  void navigateToEditPage(Map<String, dynamic> task) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditRecipePage(
          task: task,
          onSave: (updatedTask) {
            setState(() {
              final index =
                  tasks.indexWhere((item) => item['name'] == task['name']);
              if (index != -1) {
                tasks[index] = updatedTask;
              }
            });
          },
        ),
      ),
    );
  }

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
                colors: [Colors.black.withOpacity(0.4), Colors.transparent],
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
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 75.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: taskController,
                          decoration: const InputDecoration(
                            hintText: 'Enter your Recipe Name',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      GestureDetector(
                        onTap: _pickImage,
                        child: Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: _image == null
                              ? Icon(Icons.add_a_photo, color: Colors.grey)
                              : Image.file(File(_image!.path),
                                  fit: BoxFit.cover),
                        ),
                      ),
                      const SizedBox(width: 16),
                      FloatingActionButton(
                        mini: true,
                        backgroundColor: Colors.white.withOpacity(0.5),
                        onPressed: addTask,
                        child: const Icon(Icons.add, color: Colors.black),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Expanded(
                    child: ListView.builder(
                      itemCount: tasks.length,
                      itemBuilder: (context, index) {
                        final task = tasks[index];
                        return TaskCard(
                          task: task,
                          onDelete: () {
                            setState(() {
                              tasks.removeAt(index);
                            });
                          },
                          onEdit: () {
                            navigateToEditPage(task);
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

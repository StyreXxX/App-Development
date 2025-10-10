import 'package:flutter/material.dart';
import 'dart:io';

class TaskCard extends StatelessWidget {
  final Map<String, dynamic> task;
  final VoidCallback onDelete;
  final VoidCallback onEdit;

  const TaskCard({
    Key? key,
    required this.task,
    required this.onDelete,
    required this.onEdit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white.withOpacity(0.5),
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12), // Increased margin
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20), // Increased padding
        title: Text(
          task['name'],
          style: TextStyle(
            fontSize: 18, 
            fontWeight: FontWeight.normal,
          ),
        ),
        leading: task['image'] != null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(12.0), 
                child: Image.file(
                  File(task['image'].path),
                  width: 70,
                  height: 70,
                  fit: BoxFit.cover,
                ),
              )
            : const Icon(Icons.photo, color: Colors.grey, size: 40),
        trailing: IconButton(
          icon: const Icon(Icons.delete, size: 30.0, color: Colors.red), 
          onPressed: onDelete,
        ),
        onTap: onEdit,
      ),
    );
  }
}

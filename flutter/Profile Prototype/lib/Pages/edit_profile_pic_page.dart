import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../auth/supabase_auth.dart';

class EditProfilePicPage extends StatefulWidget {
  const EditProfilePicPage({super.key});

  @override
  State<EditProfilePicPage> createState() => _EditProfilePicPageState();
}

class _EditProfilePicPageState extends State<EditProfilePicPage> {
  File? _imageFile;
  bool _isLoading = false;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null && mounted) {
      setState(() => _imageFile = File(pickedFile.path));
    }
  }

  Future<void> _uploadImage() async {
    if (_imageFile == null || !mounted) return;

    setState(() => _isLoading = true);
    try {
      await SupabaseAuth().updateProfilePic(_imageFile!);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile picture updated successfully')),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update profile picture: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Profile Picture')),
      body: AnimatedOpacity(
        opacity: 1.0,
        duration: const Duration(milliseconds: 500),
        child: Center(
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (_imageFile != null)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.file(_imageFile!, height: 200, fit: BoxFit.cover),
                    ),
                  const SizedBox(height: 16),
                  AnimatedScale(
                    scale: _isLoading ? 0.8 : 1.0,
                    duration: const Duration(milliseconds: 200),
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _pickImage,
                      child: const Text('Pick Image from Gallery'),
                    ),
                  ),
                  if (_imageFile != null) ...[
                    const SizedBox(height: 16),
                    _isLoading
                        ? const CircularProgressIndicator()
                        : AnimatedScale(
                            scale: 1.0,
                            duration: const Duration(milliseconds: 200),
                            child: ElevatedButton(
                              onPressed: _uploadImage,
                              child: const Text('Upload Image'),
                            ),
                          ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
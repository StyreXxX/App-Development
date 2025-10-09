import 'package:flutter/material.dart';
import 'package:profile_app4/components/app_drawer.dart';
import 'package:profile_app4/components/sliding_background.dart';
import 'package:profile_app4/services/profile_fetcher.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with ProfileFetcher {
  final List<String> backgroundImages = [
    'assets/image1.jpg',
    'assets/image2.jpg',
    'assets/image3.jpg',
    'assets/image4.jpg',
  ];

  @override
  void initState() {
    super.initState();
    fetchProfile(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      drawer: const AppDrawer(),
      body: Stack(
        children: [
          SlidingBackground(
            imagePaths: backgroundImages,
            imageCount: backgroundImages.length,
            slideDuration: const Duration(seconds: 5),
          ),
          Column(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                color: Colors.transparent,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Builder(
                      builder: (context) => IconButton(
                        icon: const Icon(Icons.menu, size: 30),
                        onPressed: () => Scaffold.of(context).openDrawer(),
                      ),
                    ),
                    Text(
                      isLoading
                          ? 'Loading profile...'
                          : profile != null
                              ? 'Welcome, ${profile!['name']}!'
                              : 'No profile data available',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    IconButton(
                      icon: buildProfileAvatar(profile, radius: 20),
                      onPressed: () async {
                        await Navigator.pushNamed(context, '/profile');
                        await fetchProfile(context);
                      },
                    ),
                  ],
                ),
              ),
             // const Expanded(child: NewsGrid()),
            ],
          ),
        ],
      ),
    );
  }
}
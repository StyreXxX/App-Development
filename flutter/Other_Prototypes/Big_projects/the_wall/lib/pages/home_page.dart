import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:the_wall/components/drawer.dart';
import 'package:the_wall/components/text_field.dart';
import 'package:the_wall/components/wall_post.dart';
import 'package:the_wall/helper/helper_methods.dart';
import 'package:the_wall/pages/profile_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  void signOut() {
    FirebaseAuth.instance.signOut();
  }

  void postMessege() {
    //only post if there is something in the textfield
    if (textController.text.isNotEmpty) {
      FirebaseFirestore.instance.collection("User Posts").add({
        'UserEmail': currentUser.email,
        'Messege': textController.text,
        'TimeStamp': Timestamp.now(),
        'Likes': [],
      });
    }

    setState(() {
      textController.clear();
    });
  }

  void goToProfilePage() {
    Navigator.pop(context);
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const ProfilePage()));
  }

  final textController = TextEditingController();
  final currentUser = FirebaseAuth.instance.currentUser!;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        appBar: AppBar(
          iconTheme: IconThemeData(color: Theme.of(context).colorScheme.inversePrimary),
          title: Text(
            "Facebook Ultra Lite",
            style: TextStyle(color: Theme.of(context).colorScheme.inversePrimary),
          ),
          centerTitle: true,
        ),
        drawer: MyDrawer(
          onProfileTap: goToProfilePage,
          onSignOut: signOut,
        ),
        body: Center(
          child: Column(
            children: [
              // the wall
              Expanded(
                  child: StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('User Posts')
                          .orderBy("TimeStamp", descending: false)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return ListView.builder(
                              itemCount: snapshot.data!.docs.length,
                              itemBuilder: (context, index) {
                                final post = snapshot.data!.docs[index];
                                return WallPost(
                                  messege: post['Messege'],
                                  user: post['UserEmail'],
                                  time: formatDate(post['TimeStamp']),
                                  postId: post.id,
                                  likes: List<String>.from(post['Likes'] ?? []),
                                );
                              });
                        } else if (snapshot.hasError) {
                          return Center(
                            child: Text("Error: ${snapshot.error}"),
                          );
                        }
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      })),
              //post messege
              Padding(
                padding: const EdgeInsets.all(25),
                child: Row(
                  children: [
                    Expanded(
                        child: MyTextField(
                            controller: textController,
                            hintText: "Write something on the Wall",
                            obscureTest: false)),
                    IconButton(
                        onPressed: postMessege,
                        icon: const Icon(Icons.arrow_circle_up))
                  ],
                ),
              ),
              //logged in as
              Text(
                "Logged in as ${currentUser.email!}",
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(
                height: 50,
              ),
            ],
          ),
        ));
  }
}

import 'package:flutter/material.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  List<String> notifications = [
    "New message from Admin",
    "Your order has been shipped",
    "Reminder: Meeting at 3 PM",
    "Update available for your app",
  ];

  void removeNotification(int index) {
    String removedItem = notifications[index];
    setState(() {
      notifications.removeAt(index);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Notification removed"),
        action: SnackBarAction(
          label: "UNDO",
          onPressed: () {
            setState(() {
              notifications.insert(index, removedItem);
            });
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Notification Page",
          style: TextStyle(color: Colors.white), 
        ),
      ),
      body: notifications.isEmpty
          ? Center(
              child: Text(
                "No notifications available",
                style: TextStyle(fontSize: 16),
              ),
            )
          : ListView.builder(
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                return Dismissible(
                  key: ValueKey(notifications[index]), // Unique key
                  direction: DismissDirection.endToStart,
                  background: Container(
                    color: Colors.red, // Use a bright color for testing
                    alignment: Alignment.centerRight,
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Icon(Icons.delete, color: Colors.white),
                  ),
                  onDismissed: (direction) {
                    removeNotification(index);
                  },
                  child: MyNotificationTile(
                    title: notifications[index],
                    onRemove: () => removeNotification(index),
                  ),
                );
              },
            ),
    );
  }
}

class MyNotificationTile extends StatelessWidget {
  final String title;
  final VoidCallback onRemove;

  const MyNotificationTile({required this.title, required this.onRemove, super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      leading: Icon(Icons.notifications),
      trailing: IconButton(
        onPressed: onRemove,
        icon: Icon(Icons.remove),
      ),
    );
  }
}
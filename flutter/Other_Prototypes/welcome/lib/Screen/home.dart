import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  int counter = 0;
    void increment() {
      setState(() {
        counter++;
      });
    }
  Widget build(BuildContext context) {
    final items = List.generate(50, (index) => "Item ${index + 1}");

    return Scaffold(
      appBar: AppBar(title: const Text("Long List")),
      body: ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          return Card(
            margin: EdgeInsets.all(10),
            child: ListTile(
              leading: const Icon(Icons.star),
              title: Text(items[index]),
              trailing: FloatingActionButton(
                onPressed: increment,
                mini: true,
                child: Text("$counter"),
              ),
            ),
          );
        },
      ),
    );
  }
}

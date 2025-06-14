import 'package:flutter/material.dart';

void main() => runApp(BicycleNav());

class BicycleNav extends StatelessWidget {
  const BicycleNav({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "bicycle_nav_sg",
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.pink),
      ),
      home: HomePage(),
    );
  }
}

// Define a custom Form widget.
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

// Define a corresponding State class.
// This class holds the data related to the Form.
class _HomePageState extends State<HomePage> {
  // Create a text controller and use it to retrieve the current value
  // of the TextField.
  final myController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // What we want here is for the text field to slide over the background minimap whenever we click it
      // I.e. searchbar and keyboard covering bottom part of screen, and a useable minimap in the background before typing starts
      // When there has been input, cover the minimap with recommendations instead
      // Text field is to show a back button on the left and a clear button on the right once clicked.

      // Aside: Is custom android back management required? Testing will need to be done on android back button vs app back button
      body: Container(
        height: double.maxFinite,
        child: Stack(
          children: [
            Positioned(
              child: Align(
                alignment: FractionalOffset.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: TextField(
                    controller: myController,
                    //TODO onChanged: Onemap.updateLocationSearch(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

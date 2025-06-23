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

  Iterable<Widget> clearSearch(SearchController controller) {
    if (!controller.isOpen) {
      return [const SizedBox.shrink()];
    }
    return [
      Tooltip(
        message: "Clear Search",
        child: IconButton(
          onPressed: () => controller.clear(),
          icon: Icon(Icons.clear),
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // What we want here is for the text field to slide over the background minimap whenever we click it, and for the minimap to fade out
      // Text field is to show a button to clear on the right once clicked. On the left is a search button that will change into a back button
      // Aside: Is custom android back management required? Testing will need to be done on android back button vs app back button
      body: SizedBox(
        height: double.maxFinite,
        child: Stack(
          children: [
            Positioned(
              child: Align(
                alignment: FractionalOffset.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: SearchAnchor(
                    builder: (_, SearchController controller) {
                      return SearchBar(
                        controller: controller,
                        onTap: () => controller.openView(),
                        onChanged: (_) => controller.openView(),
                        leading: const Icon(Icons.search),
                        trailing: clearSearch(controller),
                      );
                    },
                    suggestionsBuilder: (_, SearchController controller) {
                      //TODO onChanged: Onemap.updateLocationSearch(),
                      return List<ListTile>.generate(5, (int index) {
                        final String item = 'item $index';
                        return ListTile(
                          title: Text(item),
                          onTap: () {
                            setState(() {
                              controller.closeView(item);
                            });
                          },
                        );
                      });
                    },
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

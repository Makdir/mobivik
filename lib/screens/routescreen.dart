
import 'package:flutter/material.dart';

class RouteScreen extends StatelessWidget {

  // Create list
  List<Widget> myItems = new List();


  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(title: new Text("Маршрут"),),
      body: ListView.builder(
        // Let the ListView know how many items it needs to build
        itemCount: myItems.length,
        // Provide a builder function. This is where the magic happens! We'll
        // convert each item into a Widget based on the type of item it is.
        itemBuilder: (context, index) {
          final item = myItems[index];


        },
      ),
    );
  }

}

import 'package:flutter/material.dart';

class RouteScreen extends StatelessWidget {

  // Create list
  List<String> myItems = ["1","2","Third","4"];


  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(title: new Text("Маршрут"),actions: <Widget>[
          IconButton(
            icon: Icon(Icons.import_export),
            tooltip: 'Air it',
            onPressed: (){Navigator.of(context).pushNamed("/sync");},
      ),],),
      body: ListView.builder(
        padding: EdgeInsets.all(8.0),
        //itemExtent: 20.0,
        itemCount: myItems.length,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
              leading: Icon(Icons.photo_album),
              title:Text(myItems[index]),
              onTap: (){Navigator.of(context).pushNamed("/sync");},
          );
        },
      )
    );
  }

}
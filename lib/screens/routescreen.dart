
import 'package:flutter/material.dart';
import 'package:mobivik/helpers/filedbhelper.dart';

class RouteScreen extends StatelessWidget {

  List route = FileDBHelper().getRoute();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(title: new Text("Маршрут"),actions: <Widget>[
          IconButton(
            icon: Icon(Icons.import_export),
            tooltip: 'Air it',
            onPressed: (){Navigator.of(context).pushNamed("/sync");},
      ),],),
//      body: ListView.builder(
//        padding: EdgeInsets.all(8.0),
//        //itemExtent: 20.0,
//        itemCount: route.length,
//        itemBuilder: (BuildContext context, int index) {
//          return ListTile(
//              leading: Icon(Icons.photo_album),
//              title:Text(route[index]),
//              onTap: (){Navigator.of(context).pushNamed("/sync");},
//          );
//        },
//      )
    );
  }

}
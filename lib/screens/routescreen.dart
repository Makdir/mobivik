
import 'package:flutter/material.dart';
import 'package:mobivik/dao/RouteDAO.dart';
import 'package:mobivik/models/Client.dart';
import 'package:mobivik/screens/outlet.dart';

class RouteScreen extends StatefulWidget {
  @override
  _RouteScreenState createState() {
    return _RouteScreenState();
  }

}

class _RouteScreenState extends State {

  List<Client> route = List();

  @override
  void initState() {
    super.initState();
    getData();
  }

  Future getData() async{

    List<Client> routeList = await RouteDAO().getRoute();
    //List<dynamic> jsonData = json.decode(textData);

    setState(() {
      route.addAll(routeList);
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(title: new Text("Маршрут"),actions: <Widget>[
          IconButton(
            icon: Icon(Icons.import_export),
            tooltip: 'Air it',
            onPressed: (){Navigator.of(context).pushNamed("/sync");},
      ),],),
        body:ListView.builder(

          padding: EdgeInsets.all(8.0),

          //itemExtent: 20.0,
          itemCount: route.length,
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
              trailing: Icon(Icons.arrow_forward_ios),
              title:Text(route[index].name),
              subtitle: Text(route[index].address),
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => OutletScreen(outlet: route[index]),
                ),
                );},
            );
          },
        )
    );
  }

}
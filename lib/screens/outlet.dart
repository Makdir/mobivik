import 'package:flutter/material.dart';
import 'package:mobivik/models/Client.dart';

class OutletScreen extends StatefulWidget {
  final Client outlet;
  OutletScreen({Key key, @required  this.outlet}) : super(key: key);

  @override
  _OutletScreenState createState() {
    return _OutletScreenState(outlet);
  }

}

class _OutletScreenState extends State {
  final Client outlet;


  _OutletScreenState(this.outlet);


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: new AppBar(title: new Text(outlet.name)),
        body: Container(),
    );
  }
}
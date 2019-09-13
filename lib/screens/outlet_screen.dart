import 'package:flutter/material.dart';
import 'package:mobivik/models/client_model.dart';

import 'buy_order.dart';

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
        body: Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
              children:[
                RaisedButton(
                  child: const Text("Заказ"),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => BuyOrder(outlet: outlet) ),
                    );
                  },
                ),
                Expanded(),
              ]),
        ),
    );
  }
}
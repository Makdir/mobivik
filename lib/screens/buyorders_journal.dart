
import 'package:flutter/material.dart';
import 'package:mobivik/services/buyorders_service.dart';
import 'package:mobivik/models/client_model.dart';
import 'package:mobivik/screens/outlet_screen.dart';

class BuyordersJournal extends StatefulWidget {
  @override
  _BuyordersJournal createState() {
    return _BuyordersJournal();
  }

}

class _BuyordersJournal extends State {

  List buyorders = List();

  @override
  void initState() {
    super.initState();
    getData();
  }

  Future getData() async{

    List buyordersList = await BuyOrders.getBuyorders();
    setState(() {
      buyorders.addAll(buyordersList);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: new Text("Журнал заказов")),
        body:ListView.builder(
          padding: EdgeInsets.all(8.0),
          itemCount: buyorders.length,
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
              trailing: Icon(Icons.arrow_forward_ios),
              title:Text(buyorders[index]["doc_id"]),
              subtitle: Text(buyorders[index]["table"].toString()),
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => OutletScreen(outlet: buyorders[index]),
                ),
                );},
            );
          },
        )
    );
  }

}
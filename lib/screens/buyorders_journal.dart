
import 'package:flutter/material.dart';
import 'package:mobivik/screens/reopened_buyorder.dart';
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

  final double _totalFontSize = 16;

  @override
  void initState() {
    super.initState();
    getData();
  }

  Future getData() async{

    List buyordersList = await BuyOrders.getBuyorderHeaders();
    setState(() {
      buyorders.addAll(buyordersList);
    });
  }

  @override
  Widget build(BuildContext context) {
    double _totalSum = 0;
    return Scaffold(
      appBar: AppBar(title: new Text("Журнал заказов")),
        body:Container(
          color: Colors.black,
          child: ListView.builder(
            padding: EdgeInsets.all(8.0),
            itemCount: buyorders.length,
            itemBuilder: (BuildContext context, int index) {
              double sum = double.parse(buyorders[index]["total_sum"]);
              _totalSum += sum;
              return Column(
                children: <Widget>[
                    Container(

                        padding: EdgeInsets.fromLTRB(8, 3, 8, 3),
                    //EdgeInsets.all(5),

                        decoration: BoxDecoration(
                          color: Colors.orangeAccent,
                          shape: BoxShape.rectangle,
                          border: Border.all(style: BorderStyle.solid, width: 1.0, color: Colors.white70),
                          borderRadius: BorderRadius.all(Radius.circular(5.0))
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text("Итоговая сумма:", style: TextStyle(fontSize: _totalFontSize),),
                            Text("$_totalSum", style: TextStyle(fontSize: _totalFontSize, fontWeight: FontWeight.bold),),
                          ],
                        ),
                      ),
                  Card(
                    elevation: 3,
                    child: ListTile(
                      trailing: Icon(Icons.arrow_forward_ios),
                      title: Text(buyorders[index]["outlet"].toString()),
                      subtitle: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(buyorders[index]["date_time"].toString()),
                            Text(buyorders[index]["total_sum"].toString(),
                              style: TextStyle(
                                fontSize: _totalFontSize,
                                fontWeight: FontWeight.w700,
                                color: Colors.redAccent
                              ),
                            ),
                          ],
                      ),
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => ReopenedBuyOrder(order: buyorders[index]),
                        ),
                        );},
                    ),
                  ),
                ],
              );
            },
          ),
        )
    );
  }

}

import 'package:flutter/material.dart';
import 'package:mobivik/screens/reopened_buyorder.dart';
import 'package:mobivik/services/buyorders_service.dart';

class BuyordersJournal extends StatefulWidget {
  @override
  _BuyordersJournal createState() {
    return _BuyordersJournal();
  }
}

class _BuyordersJournal extends State {

  List buyorders = List();
  double _totalSum = 0;
  String _sumRepresentation = '0.00';
  final double _totalFontSize = 16;

  @override
  void initState() {
    super.initState();
    getData();
    //SchedulerBinding.instance.addPostFrameCallback((_) => afterLayoutWidgetBuild());
  }

  Future getData() async{
    List buyordersList = await BuyOrders.getBuyorderHeaders();
    buyordersList.forEach((item){
      double sum = double.parse(item["total_sum"]);
      _totalSum += sum;

    });

    setState(() {
      buyorders.addAll(buyordersList);
      _sumRepresentation = _totalSum.toStringAsFixed(2);
    });
  }

  @override
  Widget build(BuildContext context) {
    //executeAfterBuild();
    //_tempSum = 0;
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(title: Text("Журнал заказов")),
        body:Column(
          children: <Widget>[
              Container(
                margin: EdgeInsets.all(5.0),
                padding: EdgeInsets.fromLTRB(8, 3, 8, 3),
                decoration: BoxDecoration(
                    color: Colors.orangeAccent,
                    shape: BoxShape.rectangle,
                    border: Border.all(style: BorderStyle.solid, width: 1.0, color: Colors.white70),
                    borderRadius: BorderRadius.all(Radius.circular(5.0))
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text("Итоговая сумма:",     style: TextStyle(fontSize: _totalFontSize),),
                    Text("$_sumRepresentation", style: TextStyle(fontSize: _totalFontSize, fontWeight: FontWeight.bold),),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.all(8.0),
                  itemCount: buyorders.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Card(
                          elevation: 3,
                          child: ListTile(
                            trailing: Icon(Icons.arrow_forward_ios),
                            title: Text(buyorders[index]["outlet"].toString()),
                            subtitle: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(buyorders[index]["date_time"].toString()),
                                  Text(buyorders[index]["actype"].toString()),
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
                              Navigator.push(context, MaterialPageRoute(builder: (context) => ReopenedBuyOrder(order: buyorders[index]), ),);},
                          ),
                        );
                  },
                ),
              ),
          ],
        )
    );
  }



}
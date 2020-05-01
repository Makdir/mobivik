
import 'package:flutter/material.dart';
import 'package:mobivik/screens/repayment.dart';
import 'package:mobivik/services/payments.dart';

class PaymentsJournal extends StatefulWidget {
  @override
  _PaymentsJournalState createState() {
    return _PaymentsJournalState();
  }
}

class _PaymentsJournalState extends State {

  List headers = List();
  double _totalSum = 0;
  String _sumRepresentation = '0.00';
  final double _totalFontSize = 16;

  @override
  void initState() {
    super.initState();
    getData();
  }

  Future getData() async{
    List paymentsList = await Payments.getHeaders();
    paymentsList.forEach((item){
      double sum = double.parse(item["sum"].toString());
      _totalSum += sum;

    });

    setState(() {
      headers.addAll(paymentsList);
      _sumRepresentation = _totalSum.toStringAsFixed(2);
    });
  }

  Future reload() async {
    headers.clear();
    await getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(title: Text("Принятые оплаты")),
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
                  itemCount: headers.length,
                  itemBuilder: (BuildContext context, int index) {
                    String orderSum = double.parse( headers[index]["sum"].toString() ).toStringAsFixed(2);
                    return Card(
                          elevation: 3,
                          child: ListTile(
                            trailing: Icon(Icons.arrow_forward_ios),
                            title: Text(headers[index]["outlet_name"].toString()),
                            subtitle: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(headers[index]["docname"].toString()),
                                  //Text(buyorders[index]["actype"].toString()),
                                  Text(orderSum,
                                    style: TextStyle(
                                      fontSize: _totalFontSize,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.redAccent
                                    ),
                                  ),
                                ],
                            ),
                            onTap: () async {
                                //Navigator.push(context, MaterialPageRoute(builder: (context) => ReopenedBuyOrder(order: buyorders[index]), ), );
                                await Navigator.push(context, MaterialPageRoute(builder: (context) => Repayment(paymentId: headers[index]["paydate"]), ));
                                reload();
                              },

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
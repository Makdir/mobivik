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

  List debtlist = List();
  Map<String, TextEditingController> _controllers = Map();

  _OutletScreenState(this.outlet);

  void initState(){
    super.initState();
    debtlist = outlet.debtlist;

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: new AppBar(title: Text(outlet.name)),
        body: Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
              children:[
                RaisedButton(
                  child: const Text("Заказ"),
                  onPressed: () {
                    savePayments();
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => BuyOrder(outlet: outlet) ),
                    );
                  },
                ),
                Expanded(
                  child:ListView.builder(
                    itemCount: debtlist.length,
                    itemBuilder: (BuildContext context, int index) {
                      String docId = debtlist[index]["date"]+"_"+debtlist[index]["docname"];
                      return Container(
                        decoration: BoxDecoration(
                          border: Border.all(width: 0.5, style: BorderStyle.solid),
                        ),
                        child: ListTile(
                          title: Text("Долг ${debtlist[index]["debt"]} (cумма заказа: ${debtlist[index]["summ"]})"),
                          subtitle: Text("${debtlist[index]["date"]} ${debtlist[index]["docname"]} №${debtlist[index]["number"]}"),

                          trailing: Container(
                            width: 100,
                            decoration: BoxDecoration(
                              border: Border.all(width: 0.5, style: BorderStyle.solid),
                            ),
                            child: new Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                new Expanded(
                                  //flex: 3,
                                  child: new TextField(
                                    readOnly:   debtlist[index]["debt"]<0,
                                    controller: _controllers[docId],
                                    textAlign:    TextAlign.end,
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                        hintText: "${debtlist[index]["debt"]}",
                                        fillColor: Color.fromARGB(50, 200, 0,0),
                                        filled: debtlist[index]["debt"]<0,
                                        helperText: (debtlist[index]["debt"]<0) ? " переплата" : " введите оплату",
                                        //helperMaxLines: 1,
                                        helperStyle: TextStyle()

                                    ),
                                  ),
                                ),

                              ],
                            ),
                          )
                        ),
                      );
                    },
                  )
                ),
              ]),
        ),
    );
  }

  void savePayments() {
    List payments = List();
    _controllers.forEach((docId, controler){
      double value = num.parse(controler.text).toDouble();

      if(0 < value){
        Map payment = {
          'doc_id':docId,

        };
      };
    });


  }
}
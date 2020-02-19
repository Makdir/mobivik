import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mobivik/common/user_interface.dart';
import 'package:mobivik/models/client_model.dart';
import 'package:mobivik/services/payments.dart';

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
    debtlist.forEach((item){
      String docId = _getDocID(item);
      _controllers[docId] = TextEditingController();

    });
    Payments.setPayment(_controllers);
  }

  gotoNewBuyOrder() {

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => BuyOrder(outlet: outlet) ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (debtlist.length==0)
      return Scaffold(
          appBar: AppBar(title: Text(outlet.name)),
          body: Center(
              child: Column(
                children:[
                  StandartButton(caption: "Новый заказ", onPressedAction: gotoNewBuyOrder),
                  Padding(
                      padding: const EdgeInsets.fromLTRB(0, 10, 0, 5),
                      child: const Text("На данный момент у клиента нет долгов", style: TextStyle(fontWeight: FontWeight.bold),)
                  ),
                ]

            )
          )
      );

    return WillPopScope(
      onWillPop: () {
        _savePayments();
        return Future(() => true);
      },
      child: Scaffold(
          appBar: new AppBar(title: Text(outlet.name)),
          body: Padding(
            padding: EdgeInsets.all(8.0),
            child: Column(

                children:[
                  StandartButton(caption: "Новый заказ", onPressedAction: gotoNewBuyOrder),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 10, 0, 5),
                    child: const Text("Долги и оплаты", style: TextStyle(fontWeight: FontWeight.bold),),
                  ),
                  Expanded(

                      child: ListView.builder(
                            itemCount: debtlist.length,
                            itemBuilder: (BuildContext context, int index) {
                              //String docId = debtlist[index]["date"]+"_"+debtlist[index]["docname"];

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
                                            controller: _controllers[_getDocID(debtlist[index])],
                                            textAlign:    TextAlign.end,
                                            keyboardType: TextInputType.number,
                                            decoration: InputDecoration(
                                                hintText: "${debtlist[index]["debt"]}",
                                                fillColor: Color.fromARGB(50, 200, 0,0),
                                                filled: debtlist[index]["debt"]<0,
                                                helperText: (debtlist[index]["debt"]<0) ? " переплата" : " введите оплату",
                                                //helperMaxLines: 1,
                                                helperStyle: TextStyle(),
                                            ),
                                          ),
                                        ),

                                      ],
                                    ),
                                  )
                                ),
                              );
                            },
                          ),
                  ),
                ]),
          ),
      ),
    );
  }

  String _getDocID(debtDoc){
    String result = '';
    try{
      result = debtDoc["date"] +"_"+ debtDoc["number"];
    }
    catch(e){}
    return result;
  }

  void _savePayments() {
    List payments = List();
     String outletId = this.outlet.id.trim();
     _controllers.forEach((docId, controller){
        double value;
        try {
          value = num.parse(controller.text).toDouble();
        }catch(e){
          value = 0;
        }

          Map item = this.debtlist.firstWhere(
              ((entry)=> entry["date"]+"_"+entry["number"]==docId)
          );

          Map payment = {
            'doc_id':docId,
            'date':    item["date"],
            'number':  item["number"],
            'docname': item["docname"],
            'sum': value
          };
          payments.add(payment);

        //}
    });
    Payments.save(payments);

  }
}

//class NewBuyOrderButton extends StatelessWidget {
//  const NewBuyOrderButton({
//    Key key,
//    @required this.outlet,
//  }) : super(key: key);
//
//  final Client outlet;
//
//  @override
//  Widget build(BuildContext context) {
//    return MaterialButton(
//      minWidth: 200,
//      child: const Text("Новый заказ", style: TextStyle(fontWeight: FontWeight.bold),),
//      color: Colors.amber,
//      //padding: EdgeInsets.fromLTRB(90, 9, 90, 10),
//      shape: RoundedRectangleBorder(
//        borderRadius: BorderRadius.only(
//            bottomLeft: Radius.circular(10.0),
//            bottomRight: Radius.circular(10.0),
//            topLeft: Radius.circular(10.0),
//            topRight: Radius.circular(10.0)),
//      ),
//      splashColor: Colors.limeAccent,
//      elevation: 3,
//      onPressed: () {
//
//        Navigator.push(
//          context,
//          MaterialPageRoute(builder: (context) => BuyOrder(outlet: outlet) ),
//        );
//      },
//    );
//  }
//}
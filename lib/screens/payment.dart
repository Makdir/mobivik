import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mobivik/common/user_interface.dart';
import 'package:mobivik/models/client_model.dart';
import 'package:mobivik/services/payments.dart';

class Payment extends StatefulWidget {
  final Client outlet;
  Payment({Key key, @required  this.outlet}) : super(key: key);

  @override
  _PaymentState createState() {
    return _PaymentState(this.outlet);
  }
}

class _PaymentState extends State {
  final Client outlet;

  double totalDebtSum = 0;
  double totalPaymentSum = 0;
  final double _totalFontSize = 16;

  List debtlist = List();
  Map<String, TextEditingController> _controllers = Map();

  _PaymentState(this.outlet);

  void initState(){
    super.initState();
    debtlist = outlet.debtlist;
    debtlist.forEach((item){
      String docId = _getDocID(item);
      _controllers[docId] = TextEditingController();
      totalDebtSum += double.parse(item["debt"].toString());
    });
    //Payments.setPaymentControllers(_controllers);
  }

  void totalSumRecalc(){
    totalPaymentSum = 0;
    _controllers.forEach((docId, controller){
      totalPaymentSum += double.parse(controller.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onExit,
      child: Scaffold(
        appBar: new AppBar(title: Text(outlet.name)),
        body: Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
              children:[
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 10, 0, 5),
                  child: const Text("Долги и оплаты", style: TextStyle(fontWeight: FontWeight.bold),),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text("Долг:",     style: TextStyle(fontSize: _totalFontSize),),
                      Text("${totalDebtSum.toStringAsFixed(2)}. ",   style: TextStyle(fontSize: _totalFontSize+1, fontWeight: FontWeight.bold),),
                      Text("Принято:",     style: TextStyle(fontSize: _totalFontSize),),
                      Text("${totalPaymentSum.toStringAsFixed(2)}. ", style: TextStyle(fontSize: _totalFontSize+1, fontWeight: FontWeight.bold),),
                    ],
                  ),
                ),
                Expanded(

                  child: ListView.builder(
                    itemCount: debtlist.length,
                    itemBuilder: (BuildContext context, int index) {
                      DateTime dateOfDebt = DateTime.parse(debtlist[index]["date"]);
                      String debtDate = DateFormat('dd.MM.yy').format(dateOfDebt);
                      return Container(
                        decoration: BoxDecoration(
                          border: Border.all(width: 0.5, style: BorderStyle.solid),
                        ),
                        child: ListTile(
                            title: Text("Долг ${debtlist[index]["debt"]} (cумма заказа: ${debtlist[index]["sum"]})"),
                            subtitle: Text("$debtDate ${debtlist[index]["docname"]} №${debtlist[index]["number"]}"),

                            trailing: Container(
                              width: 100,
                              decoration: BoxDecoration(
                                border: Border.all(width: 0.5, style: BorderStyle.solid),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  Expanded(
                                    //flex: 3,
                                    child: TextField(
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
                                      onChanged: (text){
                                        setState(() {
                                          totalSumRecalc();
                                        });
                                      },
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
    //String outletId = this.outlet.id.trim();
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

      String payDate = DateTime.now().toIso8601String();
      DateTime dateOfDebt = DateTime.parse(item["date"]);
      String debtDate = DateFormat('dd.MM.yyyy').format(dateOfDebt);

      Map payment = {
        'paydate': payDate,
        //'doc_id':  docId,
        'date':      item["date"],
        'number':    item["number"],
        'docname':   '${item["docname"]} № ${item["number"]}',
        'debt_date': '$debtDate',
        'sum': value,
        'outlet_name': outlet.name,
        'start_sum': item["sum"],
        'debt_sum': item["debt"]
      };
      payments.add(payment);
      //}
    });
    Payments.save(payments);

  }

  Future<bool> _onExit() async{

    bool shouldExit = await GraphicalUI.confirmDialog(context,'Закрыть оплаты?');
    if ((shouldExit)&&(totalPaymentSum == null)) {
      return true;
    }
    if ((shouldExit)&&(totalPaymentSum > 0)) {
      bool mustSaved = await GraphicalUI.confirmDialog(context, 'Сохранить оплаты?');
      if (mustSaved) _savePayments();
    }

    return shouldExit;
  }

}
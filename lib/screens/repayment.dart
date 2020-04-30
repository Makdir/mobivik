import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mobivik/common/user_interface.dart';
import 'package:mobivik/models/client_model.dart';
import 'package:mobivik/services/payments.dart';

class Repayment extends StatefulWidget {
  final String paymentId;
  Repayment({Key key, @required  this.paymentId}) : super(key: key);

  @override
  _RepaymentState createState() {
    return _RepaymentState(this.paymentId);
  }
}

class _RepaymentState extends State {
  final String paymentId;
  final double _totalFontSize = 16;

  Map payment;
  
  String outletName = '';
  String payDate;

  double totalDebtSum = 0;
  double totalPaymentSum = 0;


  List debtlist = List();
  TextEditingController _controller = TextEditingController();

  _RepaymentState(this.paymentId);

  void initState(){
      super.initState();
      _getData();
  }

  Future _getData() async{
    print("-----------------------------------------------=");
    print("paymentId=" + paymentId);
    payment = await Payments.getById(paymentId);
    print("payment==$payment");
    this.payDate = paymentId;
    this.outletName = payment['outlet_name'];
    _controller.text = payment['sum'].toString();

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onExit,
        child: Scaffold(
          appBar: AppBar(title: Text(outletName)),
          body: Padding(
            padding: EdgeInsets.all(8.0),
            child: Card(
                child: Column(
                  children: <Widget>[
                    Text("Основание: ${payment['docname']} "),
                    Text("Сумма заказа (начальная сумма долга): ${payment['start_sum']} "),
                    Text("Долг (по состоянию на последнюю синхронизацию): ${payment['debt_sum']}"),
                    TextField(
                          controller: _controller,
                          textAlign:    TextAlign.end,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration( labelText: 'Сумма оплаты: ' ),
                        ),
                  ],
                )
            )
          )
            
        ),
    );
  }
//  @override
//  Widget build(BuildContext context) {
//    return WillPopScope(
//      onWillPop: _onExit,
//      child: Scaffold(
//        appBar: AppBar(title: Text(outletName)),
//        body: Padding(
//          padding: EdgeInsets.all(8.0),
//          child: Column(
//              children:[
//                Padding(
//                  padding: const EdgeInsets.fromLTRB(0, 10, 0, 5),
//                  child: const Text("Долги и оплаты", style: TextStyle(fontWeight: FontWeight.bold),),
//                ),
//                Padding(
//                  padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
//                  child: Row(
//                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                    children: <Widget>[
//                      Text("Долг:",     style: TextStyle(fontSize: _totalFontSize),),
//                      Text("${totalDebtSum.toStringAsFixed(2)}. ",   style: TextStyle(fontSize: _totalFontSize+1, fontWeight: FontWeight.bold),),
//                      Text("Принято:",     style: TextStyle(fontSize: _totalFontSize),),
//                      Text("${totalPaymentSum.toStringAsFixed(2)}. ", style: TextStyle(fontSize: _totalFontSize+1, fontWeight: FontWeight.bold),),
//                    ],
//                  ),
//                ),
//                Expanded(
//
//                  child: ListView.builder(
//                    itemCount: debtlist.length,
//                    itemBuilder: (BuildContext context, int index) {
//                      DateTime dateOfDebt = DateTime.parse(debtlist[index]["date"]);
//                      String debtDate = DateFormat('dd.MM.yy').format(dateOfDebt);
//                      return Container(
//                        decoration: BoxDecoration(
//                          border: Border.all(width: 0.5, style: BorderStyle.solid),
//                        ),
//                        child: ListTile(
//                            title: Text("Долг ${debtlist[index]["debt"]} (cумма заказа: ${debtlist[index]["sum"]})"),
//                            subtitle: Text("$debtDate ${debtlist[index]["docname"]} №${debtlist[index]["number"]}"),
//
//                            trailing: Container(
//                              width: 100,
//                              decoration: BoxDecoration(
//                                border: Border.all(width: 0.5, style: BorderStyle.solid),
//                              ),
//                              child: Row(
//                                mainAxisAlignment: MainAxisAlignment.end,
//                                children: <Widget>[
//                                  Expanded(
//                                    //flex: 3,
//                                    child: TextField(
//                                      readOnly:   debtlist[index]["debt"]<0,
//                                      controller: _controllers[_getDocID(debtlist[index])],
//                                      textAlign:    TextAlign.end,
//                                      keyboardType: TextInputType.number,
//                                      decoration: InputDecoration(
//                                        hintText: "${debtlist[index]["debt"]}",
//                                        fillColor: Color.fromARGB(50, 200, 0,0),
//                                        filled: debtlist[index]["debt"]<0,
//                                        helperText: (debtlist[index]["debt"]<0) ? " переплата" : " введите оплату",
//                                        //helperMaxLines: 1,
//                                        helperStyle: TextStyle(),
//                                      ),
//                                      onChanged: (text){
//                                        setState(() {
//                                          totalSumRecalc();
//                                        });
//                                      },
//                                    ),
//                                  ),
//
//                                ],
//                              ),
//                            )
//                        ),
//                      );
//                    },
//                  ),
//                ),
//              ]),
//        ),
//      ),
//    );
//  }

  String _getDocID(debtDoc){
    String result = '';
    try{
      result = debtDoc["date"] +"_"+ debtDoc["number"];
    }
    catch(e){}
    return result;
  }

  void _savePayments() {

    double value = 0;
    try {
      value = num.parse(_controller.text).toDouble();
    }catch(e){
      value = 0;
    }

    payment['sum'] = value;
    
    List payments;
    payments.add(payment);

    Payments.save(payments);

  }

  void _delete() async{
    bool shouldDelete = await GraphicalUI.confirmDialog(context,'Удалить оплату?');
    if (!shouldDelete) {
      return;
    }

//    await Payments.deleteById(payDate);
//    Navigator.of(context).pop();
  }


  Future<bool> _onExit() async{

    bool shouldExit = await GraphicalUI.confirmDialog(context,'Закрыть оплату?');
    if ((shouldExit)&&(totalPaymentSum == null)) {
      return true;
    }
    if ((shouldExit)&&(totalPaymentSum > 0)) {
      bool mustSaved = await GraphicalUI.confirmDialog(context, 'Сохранить оплату?');
      if (mustSaved) _savePayments();
    }

    return shouldExit;
  }

}
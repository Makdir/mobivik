import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
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
  final double _totalFontSize = 18;

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
    payment = await Payments.getById(paymentId);
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                       padding: EdgeInsets.all(3.0),
                       child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children:[
                            Text("Основание: ${payment['docname']} ", style: TextStyle(fontSize: _totalFontSize)),
                            Text("${payment['debt_date']} ", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.indigo[900], fontSize: _totalFontSize),),
                          ]
                        )
                    ),
                    Padding(
                        padding: EdgeInsets.all(3.0),
                        child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children:[
                          Text("Сумма заказа (начальная сумма долга): " , style: TextStyle(fontSize: _totalFontSize),),
                          Text("${payment['start_sum']} ", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.indigo[900], fontSize: _totalFontSize),),
                        ]
                    )),
                    Padding(
                        padding: EdgeInsets.all(3.0),
                        child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children:[
                          Text('Долг (на последнюю синхронизацию): ' , style: TextStyle(fontSize: _totalFontSize),),
                          Text("${payment['debt_sum']} ", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red[900], fontSize: _totalFontSize),),
                        ]
                    )),
                    TextField(
                          controller: _controller,
                          textAlign:    TextAlign.end,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration( labelText: 'Сумма оплаты: ' ),
                        ),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children:[
                          OrderButton(text: 'Сохранить', onPressedAction: _save),
                          OrderButton(text: 'Удалить',   onPressedAction: _delete),
                          OrderButton(text: 'Выйти',     onPressedAction:(){Navigator.pop(context);}),
                        ]

                    ),
                  ],
                )
            )
          )
            
        ),
    );
  }


  void _save() {
    //print("---------------------------------------");
    double value = 0;
    try {
      value = num.parse(_controller.text).toDouble();
    }catch(e){
      value = 0;
    }
    print("value = $value");
    payment['sum'] = value;
    
    List payments = List();
    payments.add(payment);

    Payments.save(payments);

  }

  void _delete() async{

    bool shouldDelete = await GraphicalUI.confirmDialog(context,'Удалить оплату?');
    if (!shouldDelete) {
      return;
    }


    bool deleted = await Payments.deleteById(payDate);
    print("deleted = $deleted");
    if(deleted) Navigator.of(context).pop();
  }


  Future<bool> _onExit() async{

    bool shouldExit = await GraphicalUI.confirmDialog(context,'Закрыть оплату?');
    if ((shouldExit)&&(totalPaymentSum == null)) {
      return true;
    }
    if ((shouldExit)&&(totalPaymentSum > 0)) {
      bool mustSaved = await GraphicalUI.confirmDialog(context, 'Сохранить оплату?');
      if (mustSaved) _save();
    }

    return shouldExit;
  }



}


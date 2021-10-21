import 'package:flutter/material.dart';
import 'package:mobivik/common/user_interface.dart';
import 'package:mobivik/models/client_model.dart';
import 'package:mobivik/screens/payment.dart';

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

  double totalDebtSum = 0;
  double totalPaymentSum = 0;
  final double _totalFontSize = 16;

  List debtlist = [];

  _OutletScreenState(this.outlet);

  void initState() {
    super.initState();
    debtlist = outlet.debtlist;
    debtlist.forEach((item) {
      totalDebtSum += double.parse(item["debt"].toString());
    });
  }

  gotoNewBuyOrder() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => BuyOrder(outlet: outlet)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text(outlet.name)),
        body: Center(
            child: Column(
                children:[
                  StandardButton(text: "Новый заказ", onPressedAction: gotoNewBuyOrder),
                  CreditInfo(outlet: outlet),
                  _debtInfo(),
                  _newPaymentData()
        ]
    )));
  }

  Widget _debtInfo() {
    Widget debtText = Text('На данный момент у клиента нет долгов', style: TextStyle(fontWeight: FontWeight.bold, fontSize: _totalFontSize),);

    if(totalDebtSum != 0){
      debtText = RichText(
        text: TextSpan(
            text: ' Итоговая сумма взаиморасчетов по состоянию на время последней синхронизации: ',
            style: TextStyle(
                color: Colors.black, fontSize: 18),
            children: <TextSpan>[
              TextSpan(text: ' ${totalDebtSum.toStringAsFixed(2)} грн',
                  style: TextStyle(
                      color: Colors.indigo, fontSize: 18, fontWeight: FontWeight.bold),

              )
            ]
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(10),
      child: debtText,
    );

  }

  Widget _newPaymentData() {

    if(totalDebtSum != 0){
      return StandardButton(text: "Долги и оплата", onPressedAction: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Payment(outlet: outlet)),
        );
      });
    }
    return const Text('');

  }
}

class CreditInfo extends StatelessWidget {
  const CreditInfo({
    Key key,
    @required this.outlet,
  }) : super(key: key);

  final Client outlet;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(9.0),
      decoration: BoxDecoration(
        border: Border.all( width: 2.0 ),
        borderRadius: BorderRadius.all( Radius.circular(10.0) ),
      ),
      child: Column(
        children:[
          Text("Максимальная сумма кредита: ${outlet.creditLimit}"),
          Text("Максимальный срок кредита: ${outlet.creditTerm}")
        ]
      ),
    );
  }
}
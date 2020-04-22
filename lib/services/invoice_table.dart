

import 'package:flutter/material.dart';
import 'package:mobivik/models/goods_model.dart';
import 'package:mobivik/screens/buy_order.dart';

/// Part of buy order screen with ordered goods
class Invoice extends StatefulWidget {
  Map<String, TextEditingController> goodsControllers;
  List<Goods> goodsList;
  InvoiceTable invoiceTable;
  BuyOrderState summoner;

  Invoice({
    Key key,
    @required this.goodsControllers,
    @required this.goodsList,
    @required this.invoiceTable,
    @required this.summoner
  }) :  super(key: key);

  @override
  _InvoiceState createState() {
    return _InvoiceState(goodsControllers:goodsControllers, goodsList:goodsList, invoiceTable:invoiceTable, summoner: summoner);
  }
}

class _InvoiceState extends State {
  Map<String, TextEditingController> goodsControllers;
  List<Goods> goodsList;
  InvoiceTable invoiceTable;
  BuyOrderState summoner;

  double _totalSum = 0;
  Map<String, double> goodsSum = {};

  _InvoiceState({
    Key key,
    @required this.goodsControllers,
    @required this.goodsList,
    @required this.invoiceTable,
    @required this.summoner
  });

//  void totalSumRecalc(){
//
//    _totalSum = 0;
//    goodsSum.forEach((id, sum){
//      _totalSum += sum;
//
//    });
//    invoiceTable.totalSum = _totalSum;
//    //summoner.totalSum = _totalSum;
//    summoner.setState(()=>summoner.totalSum = _totalSum);
//  }
  totalSumRecalc(){

    List<Goods> goodsList = summoner.goodsList;
    double totalSum = 0;
    goodsControllers.forEach((id, controller){

      try {
        double amount = double.parse(controller.text);
        double price = goodsList.firstWhere((goods)=>goods.id==id).price;
        totalSum += price*amount;
      }catch(e){}

    });
    summoner.setState(
            ()=>summoner.totalSum = totalSum
    );
  }

  @override
  Widget build(BuildContext context) {
    //List<DataRow> InvoiceRows = List();
    _totalSum = 0;
    //invoiceTable.totalSum = 0;
    invoiceTable.rows.clear();
    goodsControllers.forEach((id,_controller){
      //print("$id=${_controller.text}");
      var value;
      try {
        value = num.parse(_controller.text);
      } catch (e) {
        value = 0;
      }
      if (value>0) {
        Goods goods = goodsList.firstWhere((item)=> item.id==id);
        double sum = (num.parse(_controller.text)*goods.price);
        _totalSum += sum;
        DataRow newRow = DataRow(
            cells:[
              DataCell(Text("${goods.name}")),
              DataCell(Text("${goods.price.toStringAsFixed(2)}")),
              DataCell(TextField(
                controller: _controller,
                keyboardType: TextInputType.numberWithOptions(decimal: true,signed: false),
                onChanged: (text){
                  double amount = num.parse(text).toDouble();
                  double sum = amount*goods.price;
                  goodsSum[id] = sum;

                  setState(() {
                    totalSumRecalc();
                  });
                },
                textAlign: TextAlign.end,
              )),
              DataCell(Text("${goods.unit}")),
              //DataCell(Text("${goods.coef}")),
              DataCell(Text("${sum.toStringAsFixed(2)}")),
            ]);
        //newRow.cells.add(DataCell())
        //InvoiceRows.add(newRow);
        invoiceTable.rows.add(newRow);
      }
    });
    invoiceTable.totalSum = _totalSum;

    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                child: RichText(
                  text: TextSpan(text: "Итоговая сумма заказа:", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                    children: <TextSpan>[
                      TextSpan(text: " ${_totalSum.toStringAsFixed(2)}", style: TextStyle(fontSize: 16.0),),
                    ],
                  ),
                  //text: TextSpan("Итоговая сумма заказа: $_totalSum", style: TextStyle(fontWeight: FontWeight.bold),),
                ),
                margin: EdgeInsets.all(10.0),
              ),
            ],
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Container(
              color: Colors.white,
              child: DataTable (
                columnSpacing: 10,
                columns: [
                  DataColumn(label: const Text('Товар'),),
                  DataColumn(label: const Text('Цена'), numeric: true,
                    tooltip: "Цена за базовую единицу",
                  ),
                  DataColumn(label: const Text('Количество'), numeric: true),
                  DataColumn(label: const Text('Ед. изм.'),   numeric: false),
                  //DataColumn(label: const Text('Коэф.'),      numeric: true),
                  DataColumn(label: const Text('Сумма'),      numeric: true),
                ],
                rows: invoiceTable.rows,
//                  sortAscending: true,
//                  sortColumnIndex: 0,
              ),
            ),
          )
        ],


      ),
    );
  }
}

class InvoiceTable{
  double totalSum;
  List<DataRow> rows = [];
  InvoiceTable();

}
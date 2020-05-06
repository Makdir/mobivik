

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

  @override
  Widget build(BuildContext context) {
    _totalSum = 0;
    invoiceTable.rows.clear();
    goodsControllers.forEach((id,_controller){
      var value;
      try {
        value = num.parse(_controller.text);
      } catch (e) {
        value = 0;
      }
      if (value>0) {
        Goods goods = goodsList.firstWhere((item)=> item.id==id);
        double sum = (num.parse(_controller.text)*goods.price*goods.coef);
        _totalSum += sum;
        DataRow newRow = DataRow(
            //key: ,
            cells:[
              DataCell(Text("${goods.name}")),
              DataCell(Text("${goods.price.toStringAsFixed(2)}")),
              DataCell(TextField(
                  controller: _controller,
                  keyboardType: TextInputType.numberWithOptions(decimal: true,signed: false),
                  onEditingComplete: (){
                    setState(() {
                      totalSumRecalc(summoner, goodsControllers);
                    });
                  },
                  textAlign: TextAlign.end,
                )),
              DataCell(Text("${goods.unit}")),
              DataCell(Text("${sum.toStringAsFixed(2)}")),
              //DataCell(IconButton(icon: Icon(Icons.clear), onPressed: _deleteRow,)),
            ]);
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
                  DataColumn(label: const Text('Сумма'), numeric: true),
                  //DataColumn(label: const Text(''),     numeric: true)
                ],
                rows: invoiceTable.rows,
              ),
            ),
          )
        ],
      ),
    );
  }

//  void _deleteRow() {
//
//  }
}


class InvoiceTable{
  double totalSum;
  List<DataRow> rows = [];
  InvoiceTable();

}
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:koukicons/error.dart';
import 'package:mobivik/common/user_interface.dart';

import 'package:mobivik/dao/goods_dao.dart';
import 'package:mobivik/screens/buy_order.dart';
import 'package:mobivik/services/goods_entries.dart';
import 'package:mobivik/models/goods_model.dart';

import 'package:koukicons/save.dart';
import 'package:koukicons/genericSortingAsc.dart';
import 'package:koukicons/flipboard2.dart';
import 'package:mobivik/services/buyorders_service.dart';
import 'package:mobivik/services/invoice_table.dart';


class ReopenedBuyOrder extends StatefulWidget {
  final Map order;

  ReopenedBuyOrder({Key key, @required this.order}) : super(key: key);

  @override
  _ReopenedBuyOrderState createState() {
    return _ReopenedBuyOrderState(order);
  }

}

class _ReopenedBuyOrderState extends State implements BuyOrderState {
  final Map order;
  String _outlet;
  List<Goods> goodsList = List();
  List<Entry> _goodsWidget = List();
  List<Entry> _entries = List();

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  final List<String> _accountingTypes = ['УУ', 'БУ'];
  String _docId;
  String _creationDateTime;
  TextEditingController commentController = TextEditingController();

  Map<String, TextEditingController> _goodsControllers = Map();
  String _selectedAT = 'УУ';

  InvoiceTable _invoiceTable = InvoiceTable(); /// _goodsSum is a list of sums of chosen goods. It has format Map<"Goods id", "Sum">

  _ReopenedBuyOrderState(this.order);

  @override
  void initState() {
    super.initState();
    _getData();

  }

  Future _getData() async{

    // Loading list of all goods and controller initialisation
    goodsList = await GoodsDAO().getItems();
    goodsList.forEach((item){_goodsControllers[item.id] = TextEditingController(); });

    // Getting order data
    _docId = order['doc_id'];

    _outlet = order['outlet'];
    _creationDateTime = order['date_time'];
    totalSum = double.parse(order['total_sum']);
    _invoiceTable.totalSum = totalSum;  // maybe _invoiceTable.totalSum is unused and it can be deleted

    Map buyorder = await BuyOrders.getBuyorderById(_docId);
    List rows = buyorder['table'];

    rows.forEach((item){
      _goodsControllers[item['id']].text = item['qty'];
    });

    // Loading and forming hierarchcal structure of goods
      goodsList.forEach((item){
      Entry newEntry = Entry(item: item);
      _entries.add(newEntry);
    });
    // Item can not have empty id. It is wrong.
    _entries.removeWhere((entry) => entry.id.isEmpty);

    _entries.forEach((item){
      try {
        String parentId = item.parent_id.toString().trim();
        Entry parentEntry = _entries.firstWhere((entry) => entry.id == parentId);
        parentEntry.children.add(item);
      } catch (e) {}
    });
    // Deleting items without paren. (But also this may be due to wrong data.)
    _entries.removeWhere((entry) => entry.parent_id != "");

    setState(() {
      _goodsWidget.addAll(_entries);
    });

  }


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onExit,
      child: Scaffold(
            key: _scaffoldKey,
            appBar: AppBar(
                title: Text('$_outlet'),
                //bottom: PreferredSizeWidget ,
                actions: <Widget>[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 3, 5, 3),
                    child:
                      FlatButton(
                          child: Column(children: [
                            KoukiconsSave(height: 35.0),
                            const Text("Save"),
                          ]),
                          onPressed: _saveOrder,
                      ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(5, 3, 35, 2),
                    child:
                    FlatButton(
                      child: Column(children: [
                        KoukiconsError(height: 35.0),
                        const Text("Delete"),
                      ]),
                      onPressed: _deleteOrder,
                    ),
                  ),
                ],
            ),
            body:Column(
              children: <Widget>[
                HeaderOfOrder(),
                Expanded(
                    child:DefaultTabController(
                      length: 2,
                      child: Scaffold(
                        appBar: TabBar(
                          labelColor: Colors.black,
                          unselectedLabelColor: Colors.grey,
                          indicatorColor: Colors.orange,
                          //onTap: onTabTap,
                          tabs: [
                              Tab(child: KoukiconsGenericSortingAsc() ),
                              Tab(child: KoukiconsFlipboard2() ),
                          ],
                        ),

                        body: Container(
                          color: Colors.grey[300],
                          child: TabBarView(
                            children: [
                              TreeList(goodsWidget: _goodsWidget, goodsControllers:_goodsControllers, summoner: this),
                              Invoice(goodsControllers: _goodsControllers, goodsList: goodsList, invoiceTable: _invoiceTable, summoner: this),

                            ]
                          ),
                        ),
                      ),
                  ),
                ),
              ],
            )
        ),
    );
  }

  void _saveOrder() {

    Map order = Map();
    order["doc_id"] = _docId;
    if(_selectedAT == 'УУ') {
      order["actype"] = 0;
    }
    else{
      order["actype"] = 1;
    }
    order["comment"] = commentController.text;
    List<Map> docTable = List();

    _goodsControllers.forEach((id,_controller){
        var value;
        try {
          value = num.parse(_controller.text);
        } catch (e) {
          value = 0;
        }
        if (value>0) {
          //Goods goods = goodsList.firstWhere((item)=> item.id==id);
          Map row = Map();
          row["id"] = id;
          row["qty"] = _controller.text;
          docTable.add(row);
        }
    });
    order["table"] = docTable;
    BuyOrders.save(order);

    // Data for journal
    Map header = Map();
    header["doc_id"] = _docId;
    header["outlet"] = _outlet;
    header["date_time"] = _creationDateTime.trim();
    header["actype"] = _selectedAT;
    header["total_sum"] = _invoiceTable.totalSum.toStringAsFixed(2);
    header["can_be_changed"] = true;
    BuyOrders.saveHeader(header);

    GraphicalUI.showSnackBar(scaffoldKey: _scaffoldKey, context: context, actionLabel:"Close settings", resultMessage: "Заказ сохранен");
  }

  void _deleteOrder() {

  }

  Future<bool> _onExit() async{
    //print('_goodsSum = ${_invoiceTable.totalSum}');
    bool shouldExit = await GraphicalUI.confirmDialog(context,'Закрыть форму заказа?');
    if ((shouldExit)&&(_invoiceTable.totalSum == null)) {
      return true;
    }
    if ((shouldExit)&&(_invoiceTable.totalSum > 0)) {
      bool mustSaved = await GraphicalUI.confirmDialog(context, 'Сохранить заказ?');
      if (mustSaved) _saveOrder();
    }

    return shouldExit;
  }

  @override
  double totalSum;

  @override
  Widget HeaderOfOrder() {
    return Column(children: <Widget>[
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
        Row(
          //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(3.0),
              child: const Text("Вид учета", style: TextStyle(fontWeight: FontWeight.w700),),
            ),
            DropdownButton<String>(
              underline: Container(decoration: BoxDecoration(border: Border.all(width: 0.5, style: BorderStyle.solid))),
              value: _selectedAT,
              items: _accountingTypes.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (selectedAT) {
                setState(() {
                  _selectedAT = selectedAT;
                });
              },
            ),
            Padding(
                padding: const EdgeInsets.all(3.0),
                child: Text('Сумма ${totalSum.toStringAsFixed(2)}', style: TextStyle(fontWeight: FontWeight.w700),)
            ),
          ],
        ),

        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text('Дата создания ${_creationDateTime}'),
        )
      ],

    ),
      Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            //const Text('Комментарий'),
            Expanded(
              child: TextField(
                decoration: InputDecoration(labelText: 'Комментарий', ),
                controller: commentController,
              ),
            )
          ]
      )],
    );
  }
}

///// Part of buy order screen with ordered goods
//class Invoice extends StatefulWidget {
//  Map<String, TextEditingController> goodsControllers;
//  List<Goods> goodsList;
//
//  InvoiceTable invoiceTable;
//
//  Invoice({
//    Key key,
//    @required this.goodsControllers,
//    @required this.goodsList,
//    @required this.invoiceTable
//  }) :  super(key: key);
//
//   @override
//   _InvoiceState createState() {
//     return _InvoiceState(goodsControllers:goodsControllers, goodsList:goodsList, invoiceTable:invoiceTable);
//   }
//}
//
//class _InvoiceState extends State {
//  Map<String, TextEditingController> goodsControllers;
//  List<Goods> goodsList;
//  InvoiceTable invoiceTable;
//
//  double _totalSum = 0;
//  Map<String, double> goodsSum = {};
//
//  _InvoiceState({
//    Key key,
//    @required this.goodsControllers,
//    @required this.goodsList,
//    @required this.invoiceTable
//  });
//
//  void totalSumRecalc(){
//
//      _totalSum = 0;
//      goodsSum.forEach((id, sum){
//        _totalSum += sum;
//        print("$id=$sum");
//      });
//      invoiceTable.totalSum = _totalSum;
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    //List<DataRow> InvoiceRows = List();
//    _totalSum = 0;
//    //invoiceTable.totalSum = 0;
//    invoiceTable.rows.clear();
//    goodsControllers.forEach((id,_controller){
//      //print("$id=${_controller.text}");
//      var value;
//      try {
//        value = num.parse(_controller.text);
//      } catch (e) {
//        value = 0;
//      }
//      if (value>0) {
//        Goods goods = goodsList.firstWhere((item)=> item.id==id);
//        double sum = (num.parse(_controller.text)*goods.price);
//        _totalSum += sum;
//        DataRow newRow = DataRow(
//            cells:[
//              DataCell(Text("${goods.name}")),
//              DataCell(Text("${goods.price.toStringAsFixed(2)}")),
//              DataCell(TextField(
//                controller: _controller,
//                keyboardType: TextInputType.numberWithOptions(decimal: true,signed: false),
//                onEditingComplete: (){print("onEditingComplete = ${_controller.text}");},
//                onChanged: (text){
//                  double amount = num.parse(text).toDouble();
//                  double sum = amount*goods.price;
//                  goodsSum[id] = sum;
//
//                  setState(() {
//                    totalSumRecalc();
//                  });
//                },
//                textAlign: TextAlign.end,
//
//              )),
//              DataCell(Text("${goods.unit}")),
//              //DataCell(Text("${goods.coef}")),
//              DataCell(Text("${sum.toStringAsFixed(2)}")),
//        ]);
//        //newRow.cells.add(DataCell())
//        //InvoiceRows.add(newRow);
//        invoiceTable.rows.add(newRow);
//      }
//    });
//    invoiceTable.totalSum = _totalSum;
//
//    return SingleChildScrollView(
//        child: Column(
//          children: <Widget>[
//            Row(
//              children: <Widget>[
//                Container(
//                    child: RichText(
//                      text: TextSpan(text: "Итоговая сумма заказа:", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
//                        children: <TextSpan>[
//                          TextSpan(text: " ${_totalSum.toStringAsFixed(2)}", style: TextStyle(fontSize: 16.0),),
//                        ],
//                      ),
//                      //text: TextSpan("Итоговая сумма заказа: $_totalSum", style: TextStyle(fontWeight: FontWeight.bold),),
//                    ),
//                  margin: EdgeInsets.all(10.0),
//                ),
//               ],
//            ),
//            SingleChildScrollView(
//              scrollDirection: Axis.horizontal,
//              child: Container(
//                color: Colors.white,
//                child: DataTable (
//                  columnSpacing: 10,
//                  columns: [
//                    DataColumn(label: const Text('Товар'),),
//                    DataColumn(label: const Text('Цена'), numeric: true,
//                        tooltip: "Цена за базовую единицу",
//                        ),
//                    DataColumn(label: const Text('Количество'), numeric: true),
//                    DataColumn(label: const Text('Ед. изм.'),   numeric: false),
//                    //DataColumn(label: const Text('Коэф.'),      numeric: true),
//                    DataColumn(label: const Text('Сумма'),      numeric: true),
//                  ],
//                  rows: invoiceTable.rows,
////                  sortAscending: true,
////                  sortColumnIndex: 0,
//                ),
//              ),
//            )
//          ],
//
//
//        ),
//      );
//  }
//}

//class TreeList extends StatelessWidget {
//
//  final List<Entry> goodsWidget;
//  final Map<String, TextEditingController> goodsControllers;
//
//  TreeList({
//    Key key,
//    @required this.goodsWidget,
//    @required this.goodsControllers,
//  });
//
//  @override
//  Widget build(BuildContext context) {
//    return ListView.builder(
//      padding: EdgeInsets.all(3.0),
//      itemCount: goodsWidget.length,
//      itemBuilder: (BuildContext context, int index) {
//        return EntryItem(goodsWidget[index], goodsControllers, this);
//      },
//    );
//  }
//}
//
//class InvoiceTable{
//  double totalSum;
//  List<DataRow> rows = [];
//  InvoiceTable();
//
//}
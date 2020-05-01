import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mobivik/common/user_interface.dart';

import 'package:mobivik/dao/goods_dao.dart';
import 'package:mobivik/models/client_model.dart';
import 'package:mobivik/services/goods_entries.dart';
import 'package:mobivik/services/invoice_table.dart';
import 'package:mobivik/models/goods_model.dart';

import 'package:koukicons/save.dart';
import 'package:koukicons/genericSortingAsc.dart';
import 'package:koukicons/flipboard2.dart';
import 'package:mobivik/services/buyorders_service.dart';


class BuyOrder extends StatefulWidget {
  final Client outlet;

  BuyOrder({Key key, @required this.outlet}) : super(key: key);

  @override
  BuyOrderState createState() {
    return BuyOrderState(outlet);
  }

}

/// _goodsList is all goods available for salling
///
///
///
class BuyOrderState extends State {
  final Client _outlet;
  List<Goods> goodsList = List();
  List<Entry> _goodsWidget = List();
  List<Entry> _entries = List();

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  final List<String> _accountingTypes = ['УУ', 'БУ'];
  final DateTime _creationDateTime = DateTime.now();
  TextEditingController commentController = TextEditingController();

  //String invoiceNumber = "Заказ № "+DateTime.now().millisecondsSinceEpoch.toString();
  Map<String, TextEditingController> _goodsControllers = new Map();
  String _selectedAT = 'УУ';

  InvoiceTable _invoiceTable = InvoiceTable();
  double totalSum = 0;

  /// _goodsSum is a list of sums of chosen goods. It has format Map<"Goods id", "Sum">

  BuyOrderState(this._outlet);

  @override
  void initState() {
    super.initState();
    _getData();

  }

  Future _getData() async{

    goodsList = await GoodsDAO().getItems();
    goodsList.forEach((item){_goodsControllers.putIfAbsent(item.id, ()=> TextEditingController());});

    // Forming hierarchcal structure
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
                title: Text(_outlet.name),
                //bottom: PreferredSizeWidget ,
                actions: <Widget>[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 3, 35, 0),
                    child:
                      FlatButton(
                          child: Column(children: [
                            KoukiconsSave(height: 35.0),
                            const Text("Save"),
                          ]),
                          onPressed: _saveOrder,
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

  Widget HeaderOfOrder(){
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Row(
              //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Padding(
                  child: const Text("Вид учета", style: TextStyle(fontWeight: FontWeight.w700),),
                  padding: const EdgeInsets.all(3.0),

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
              ],
            ),

            Padding(
                padding: const EdgeInsets.all(3.0),
                child: Text('Сумма ${totalSum.toStringAsFixed(2)}', style: TextStyle(fontWeight: FontWeight.w700),)
            ),

            Padding(
              padding: const EdgeInsets.all(3.0),
              child: Text(DateFormat('dd.MM.yyyy HH:mm').format(_creationDateTime)),
            ),

          ],

        ),
        Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              
              Expanded(
                child: TextField(
                  decoration: InputDecoration(labelText: 'Комментарий', ),
                  controller: commentController,
                ),
              )
            ]
        ),
      ],
    );
  }
  
  void _saveOrder() {
    String docId = _creationDateTime.toIso8601String();

    Map order = Map();
    order["doc_id"] = docId;
    order["outlet_id"] = _outlet.id;
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
    header["doc_id"] = docId;
    header["outlet"] = _outlet.name;
    header["date_time"] = DateFormat('dd.MM.yyyy HH:mm').format(_creationDateTime);
    header["actype"] = _selectedAT;
    header["total_sum"] = totalSum;
    header["can_be_changed"] = 1;
    BuyOrders.saveHeader(header);

    GraphicalUI.showSnackBar(scaffoldKey: _scaffoldKey, context: context, actionLabel:"", resultMessage: "Заказ сохранен");
  }

  Future<bool> _onExit() async{

    bool shouldExit = await GraphicalUI.confirmDialog(context,'Закрыть форму заказа?');
    if ((shouldExit)&&(totalSum == null)) {
      return true;
    }
    if ((shouldExit)&&(totalSum > 0)) {
      bool mustSaved = await GraphicalUI.confirmDialog(context, 'Сохранить заказ?');
      if (mustSaved) _saveOrder();
    }

    return shouldExit;
  }
}

totalSumRecalc(summoner, goodsControllers){

    List<Goods> goodsList = summoner.goodsList;
    double totalSum = 0;
    goodsControllers.forEach((id, controller){

      try {
        double amount = double.parse(controller.text);
        Goods ware = goodsList.firstWhere((goods)=>goods.id==id);
        double price = ware.price;
        double coef = ware.coef;

        totalSum += price*coef*amount;
      }catch(e){}

    });
    summoner.setState(
            ()=>summoner.totalSum = totalSum
    );
}

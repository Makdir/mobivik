import 'package:flutter/material.dart';

import 'package:mobivik/common/user_interface.dart';

import 'package:mobivik/dao/goods_dao.dart';
import 'package:mobivik/screens/buy_order.dart';
import 'package:mobivik/services/goods_entries.dart';
import 'package:mobivik/models/goods_model.dart';

import 'package:mobivik/services/buyorders_service.dart';
import 'package:mobivik/fragments/invoice_table.dart';

import 'package:mobivik/common/project_icons.dart';

class ReopenedBuyOrder extends StatefulWidget {
  //final Map order;
  //ReopenedBuyOrder({Key key, @required this.order}) : super(key: key);

  final docId;
  ReopenedBuyOrder(this.docId);

  @override
  _ReopenedBuyOrderState createState() {
    return _ReopenedBuyOrderState(docId);
  }

}

class _ReopenedBuyOrderState extends State implements BuyOrderState {

  Map order;
  String _outlet;
  String _outletId;
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
  ///
  @override
  double totalSum = 0.0;

  //_ReopenedBuyOrderState(this.order);
  _ReopenedBuyOrderState(this._docId);

  @override
  void initState() {
    super.initState();
    _getData();

  }

  Future _getData() async{
    // Getting order data
    List buyordersList = await BuyOrders.getHeaders();

    this.order = buyordersList.firstWhere((header)=>header['doc_id']==_docId, orElse: null);
    if(this.order==null) return;

    _outlet = order['outlet'];
    _outletId = order['outlet_id'];
    _creationDateTime = order['date_time'];
    totalSum = double.parse(order['total_sum'].toString());
    _invoiceTable.totalSum = totalSum;  // maybe _invoiceTable.totalSum is unused and it can be deleted
    commentController.text = order['comment'].toString().trim();

    Map buyorder = await BuyOrders.getBuyorderById(_docId);
    List rows = buyorder['table'];

    // Loading list of all goods and controller initialisation
    goodsList = await GoodsDAO().getItems();
    goodsList.forEach((item){_goodsControllers[item.id] = TextEditingController(); });

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
                    padding: const EdgeInsets.fromLTRB(0, 3, 5, 0),
                    child:
                      FlatButton(
                          child: Column(
                              children: [
                                Container(
                                  height: 35,
                                  child: ProjectIcons.save,
                                ),
                                const Text("Save"),
                              ]
                          ),
                          onPressed: _saveOrder,
                      ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(5, 3, 20, 0),
                    child: FlatButton(
                          child: Column(
                              children: [
                                Container(
                                  height: 35,
                                  child: ProjectIcons.trash,
                                ),
                                const Text("Delete"),
                              ]
                          ),
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
                              Tab(child: ProjectIcons.goodsList,),
                              Tab(child:  ProjectIcons.invoice,),
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

  Future _saveOrder() async {
    totalSumRecalc(this, _goodsControllers);
    //print('2 _outletId = $_outletId');
    Map order = Map();
    order["doc_id"] = _docId;
    order["outlet_id"] = _outletId;
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
    //print('3 _outletId = $_outletId');
    // Data for journal
    Map header = Map();
    header["doc_id"] = _docId;
    header["outlet"] = _outlet;
    header["outlet_id"] = _outletId;
    header["date_time"] = _creationDateTime.trim();
    header["actype"] = _selectedAT;
    header["total_sum"] = totalSum;
    header["can_be_changed"] = 1;
    header["comment"] = commentController.text;
    await BuyOrders.saveHeader(header);

    GraphicalUI.showSnackBar(scaffoldKey: _scaffoldKey, context: context, actionLabel:"", resultMessage: "Заказ сохранен");
  }

  void _deleteOrder() async{
    bool shouldDelete = await GraphicalUI.confirmDialog(context,'Удалить заказ?');
    if (!shouldDelete) {
      return;
    }

    await BuyOrders.deleteBuyorderById(_docId);
    Navigator.of(context).pop();
  }

  Future<bool> _onExit() async{
    //print('_goodsSum = ${_invoiceTable.totalSum}');
    bool shouldExit = await GraphicalUI.confirmDialog(context,'Закрыть форму заказа?');
    if ((shouldExit)&&(totalSum == null)) {
      return true;
    }
    if ((shouldExit)&&(totalSum > 0)) {
      bool mustBeSaved = await GraphicalUI.confirmDialog(context, 'Сохранить заказ?');
      if (mustBeSaved) {
        await _saveOrder();
      }
      return true;
    }

    return shouldExit;
  }

  @override
  Widget HeaderOfOrder() {
    return Column(children: <Widget>[
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
        Row(
          //
          mainAxisAlignment: MainAxisAlignment.spaceAround,
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

          ],
        ),

        Padding(
            padding: const EdgeInsets.all(3.0),
            child: Text('Сумма ${totalSum.toStringAsFixed(2)}', style: TextStyle(fontWeight: FontWeight.w700),)
        ),

        Padding(
          padding: const EdgeInsets.all(3.0),
          child: Text('Дата: $_creationDateTime'),
        )
      ],

    ),
      Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
          Expanded(
              child: TextField(
                decoration: InputDecoration(labelText: 'Комментарий: ', ),
                controller: commentController,
              ),
            )
          ]
      )],
    );
  }
}
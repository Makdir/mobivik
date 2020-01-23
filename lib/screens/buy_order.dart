import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobivik/common/user_interface.dart';

import 'package:mobivik/dao/goods_dao.dart';
import 'package:mobivik/models/client_model.dart';
import 'package:mobivik/models/goods_model.dart';

import 'package:koukicons/save.dart';
import 'package:koukicons/genericSortingAsc.dart';
import 'package:koukicons/flipboard2.dart';
import 'package:mobivik/services/buy_orders.dart';


class BuyOrder extends StatefulWidget {
  final Client outlet;

  BuyOrder({Key key, @required this.outlet}) : super(key: key);

  @override
  _BuyOrderState createState() {
    return _BuyOrderState(outlet);
  }

}

class _BuyOrderState extends State {
  final Client _outlet;
  List<Goods> _goodsList = List();
  List _goodsWidget = List();
  List<Entry> entries = List();

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  final List<String> accountingTypes = ['УУ', 'БУ'];
  String _invoiceNumber = "Заказ № "+DateTime.now().millisecondsSinceEpoch.toString();//invoiceNumber = invoiceNumber + DateTime.now().millisecondsSinceEpoch.toString();
  
  Map<String, TextEditingController> _goodsControllers = new Map();

  
  String _selectedAT = 'УУ';

  Map<String, double> _goodsSum = Map(); // Sums of selected goods. It has format Map<"Goods id", "Sum">
  


  _BuyOrderState(this._outlet);

  @override
  void initState() {
    super.initState();
    getData();

  }

  Future getData() async{

    _goodsList = await GoodsDAO().getItems();
    _goodsList.forEach((item){_goodsControllers.putIfAbsent(item.id, ()=> TextEditingController());});

    // Forming hierarchcal structure
    _goodsList.forEach((item){
      Entry newEntry = Entry(item: item);
      entries.add(newEntry);
    });

    entries.forEach((item){
      try {
        String parentId = item.parent_id.toString().trim();
        Entry parentEntry = entries.firstWhere((entry) => entry.id == parentId);
        parentEntry.children.add(item);
      } catch (e) {}
    });

    entries.removeWhere((entry) => entry.parent_id != "");

    setState(() {
      _goodsWidget.addAll(entries);
    });

  }


  
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onExit,

      child: Scaffold(
          appBar: AppBar(
              title: Text(_outlet.name),
              //bottom: PreferredSizeWidget ,
              actions: <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 3, 35, 2),
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
              FlatButton(
                child: Column(children: [
                  KoukiconsSave(height: 35.0),
                  const Text("Save"),
                ]),
                onPressed: _onExit,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                    Row(
                      //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: const Text("Вид учета", style: TextStyle(fontWeight: FontWeight.w700),),
                        ),
                        DropdownButton<String>(
                          underline: Container(decoration: BoxDecoration(border: Border.all(width: 0.5, style: BorderStyle.solid))),
                          value: _selectedAT,
                          items: accountingTypes.map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (selectedAT) {
                            setState(() {
                              _selectedAT=selectedAT;
                            });
                          },
                        ),
                      ],
                    ),

                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(_invoiceNumber),
                    )
                ],

                  ),

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
                            TreeList(goodsWidget: _goodsWidget, goodsControllers:_goodsControllers),
                            Invoice(goodsControllers: _goodsControllers, goodsList: _goodsList, goodsSum: _goodsSum),

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
    order["doc_id"] = DateTime.now();
    //order["_id"] = DateTime.now();


    BuyOrders.save(order);
    GraphicalUI.showSnackBar(scaffoldKey: _scaffoldKey, context: context, actionLabel:"Close settings", resultMessage: "Заказ сохранен");

  }

  Future<bool> _onExit() async{
    bool shouldExit = await GraphicalUI.confirmDialog1(context,'Закрыть форму заказа?');
    if (shouldExit) {
      bool mustSaved = await GraphicalUI.confirmDialog1(context, 'Сохранить заказ?');
      //print("mustSaved $mustSaved");
      if (mustSaved) _saveOrder();
    }
    //print("shouldExit $shouldExit");

    //
    return shouldExit;
  }



}

class Invoice extends StatefulWidget {
  Map<String, TextEditingController> goodsControllers;
  List<Goods> goodsList;

  Map<String, double> goodsSum;

  Invoice({
    Key key,
    @required this.goodsControllers,
    @required this.goodsList,
    @required this.goodsSum
  }) :  super(key: key);

   @override
   _InvoiceState createState() {
     return _InvoiceState(goodsControllers:goodsControllers, goodsList:goodsList, goodsSum:goodsSum);}}

class _InvoiceState extends State {
  Map<String, TextEditingController> goodsControllers;
  List<Goods> goodsList;
  //List<Goods> choosedGoods = List();

  double _totalSum = 0;
  Map<String, double> goodsSum;

  _InvoiceState({
    Key key,
    @required this.goodsControllers,
    @required this.goodsList,
    @required this.goodsSum
  });

  void totalSumRecalc(){

      _totalSum = 0;
      goodsSum.forEach((id, sum){
        _totalSum += sum;
        print("$id=$sum");
      });

      setState(() {});
  }

//  recalcRow(Goods goods, String text) {
//    double amount = num.parse(text).toDouble();
//    double summ = amount*goods.price;
//    _goodsSumm.putIfAbsent(goods.id, ()=>summ);
//    totalAmountRecalc();
//
//  }

  @override
  Widget build(BuildContext context) {
    List<DataRow> InvoiceRows = List();
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
        DataRow newRow = DataRow(

            cells:[
              DataCell(Text("${goods.name}")),
              DataCell(Text("${goods.price.toStringAsFixed(2)}")),
              DataCell(TextField(
                controller: _controller,
                keyboardType: TextInputType.numberWithOptions(decimal: true,signed: false),
                onEditingComplete: (){print("onEditingComplete = ${_controller.text}");},
                onChanged: (text){
                  double amount = num.parse(text).toDouble();
                  double sum = amount*goods.price;
                  goodsSum[id] = sum;
                  totalSumRecalc();

                },
                textAlign: TextAlign.end,

              )),
              DataCell(Text("${goods.unit}")),
              DataCell(Text("${goods.coef}")),
              //DataCell(Text("${(num.parse(_controller.text)*goods.price).toStringAsFixed(2)}")),
              DataCell(Text("${(num.parse(_controller.text)*goods.price).toStringAsFixed(2)}")),
        ]);

        //newRow.cells.add(DataCell())
        InvoiceRows.add(newRow);
      }
    });
    return SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Row(children: <Widget>[Text("Итоговая сумма заказа: $_totalSum")],),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Container(
                color: Colors.white,
                child: DataTable (
                  columnSpacing: 10,
                  columns: [
                    DataColumn(
                        label: const Text('Товар'),
                    ),
                    DataColumn(
                        label: const Text('Цена'),
                        numeric: true,
                        tooltip: "Цена за базовую единицу",

                        ),

                    DataColumn(label: const Text('Количество'), numeric: true),
                    DataColumn(label: const Text('Ед. изм.'), numeric: true),
                    DataColumn(label: const Text('Коэф.'), numeric: true),
                    DataColumn(label: const Text('Сумма'),      numeric: true),
                  ],
                  rows: InvoiceRows,
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


class TreeList extends StatelessWidget {

  final List _goodsWidget;
  Map<String, TextEditingController> goodsControllers;

  TreeList({
    Key key,
    @required List goodsWidget,
    @required Map<String, TextEditingController> this.goodsControllers,
  }) : _goodsWidget = goodsWidget, super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.all(3.0),
      itemCount: _goodsWidget.length,
      itemBuilder: (BuildContext context, int index) {
        return EntryItem(_goodsWidget[index], goodsControllers);
      },

    );
  }
}

// One entry in the multilevel list displayed by this app.
class Entry {
//, [this.children = <Entry>[]]);
  final Goods item;
  String id;
  String parent_id;
  final List<Entry> children = <Entry>[];

  Entry({this.item}){
    this.id = this.item.id;
    this.parent_id = this.item.parent_id;
  }

}

// Displays one Entry. If the entry has children then it's displayed
// with an ExpansionTile.
class EntryItem extends StatelessWidget {
  Map<String, TextEditingController> _goodsControllers;

  //final List<Entry> resultGoodsList;
  EntryItem(this.entry, this._goodsControllers);

  final Entry entry;

  Widget _buildTiles(Entry root) {
    var itemID = root.id;

    if (root.children.isEmpty)
      return Card(
        //color: Colors.white30,
        //borderOnForeground: false,
        child: ListTile(
          title: Text(root.item.name),

          subtitle: Text("Цена ${root.item.price} грн. Остаток ${root.item.balance} ${root.item.unit}"),
            trailing: Container(
              width: 75,
              decoration: BoxDecoration(
                border: Border.all(width: 0.5, style: BorderStyle.solid),
              ),
              child: new Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Expanded(
                    //flex: 3,
                    child: TextField(
                      key: PageStorageKey(itemID),
                      controller: _goodsControllers[itemID],
                      textAlign: TextAlign.end,
                      keyboardType: TextInputType.numberWithOptions(signed: false, decimal: true),
                      decoration: InputDecoration(
                        hintText: "заказ",
                      ),
                        inputFormatters: [
                          WhitelistingTextInputFormatter(RegExp("[0-9.]")),
                          //BlacklistingTextInputFormatter(RegExp(".."))
                        ]
                    ),
                  ),

                ],
              ),
            )
        ),
      );
    return Card(
      elevation: 3,
      child: Container(
        decoration: new BoxDecoration(
          border: Border.all(width: 0.5, style: BorderStyle.solid),
          borderRadius: BorderRadius.all( Radius.circular(3.0)),
        ),
        child: ExpansionTile(
          key: PageStorageKey<Entry>(root),
          title: Text("${root.item.name}", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.brown)),

          children: root.children.map(_buildTiles).toList(),
          leading: Icon(Icons.arrow_right),

          //backgroundColor: Colors.orangeAccent[100],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildTiles(entry);
  }

}
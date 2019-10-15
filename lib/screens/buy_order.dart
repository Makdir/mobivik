import 'dart:collection';
import 'dart:wasm';

import 'package:flutter/material.dart';
import 'package:mobivik/dao/GoodsDAO.dart';
import 'package:mobivik/models/client_model.dart';
import 'package:mobivik/models/goods_model.dart';

import 'package:koukicons/save.dart';
import 'package:koukicons/genericSortingAsc.dart';
import 'package:koukicons/flipboard2.dart';

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

  final List<String> accountingTypes = ['УУ', 'БУ'];

  //List<Entry> resultGoodsList;

  Map<String, TextEditingController> _goodsControllers = new Map();

  String _selectedAT = 'УУ';


  _BuyOrderState(this._outlet);

  @override
  void initState() {
    super.initState();
    getData();
  }

  Future getData() async{

    _goodsList = await GoodsDAO().getItems();
    _goodsList.forEach((item){_goodsControllers.putIfAbsent(item.id, ()=> TextEditingController());});
    //_controllers.length = goodsList.length;
    //goodsList.forEach((item){print("Controller ${item.id}=${_goodsControllers[item.id].text}");});

    //TODO: dynamic leveling needed
    Goods item;
    //int index = 0;
    for(item in _goodsList){
      String parentId = item.parent_id.toString().trim();
      Entry newEntry = Entry(item: item);
      if((parentId!="")||(parentId.isNotEmpty))
      {
        Entry parentEntry;
        try {
          // 2 level of expanded list
          parentEntry = entries.firstWhere((entry) => entry.id == parentId);
          parentEntry.children.add(newEntry);
        } on StateError catch(e) {
          if(e.message=="No element"){
            entries.forEach((entry){
              try {
                // 3 level of expanded list
                parentEntry = entry.children.firstWhere((entry)=>entry.id==parentId);
                parentEntry.children.add(newEntry);
              } on StateError catch(e) {
              } catch (e) {}});
          }
        //TODO: catch handling needed
        } catch (e) {}
      }else{
        // top (first) level of expanded list
        entries.add(newEntry);
      }
      //index++;
    }

    setState(() {
      _goodsWidget.addAll(entries);
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: AppBar(
            title: new Text("Заказ покупателя"),
            //bottom: PreferredSizeWidget ,
            actions: <Widget>[

                //padding: const EdgeInsets.fromLTRB(0, 8, 25, 8),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 3, 35, 2),
                child: FlatButton(
                      child: Column(children: [
                        KoukiconsSave(height: 35.0),
                        const Text("Save"),
                      ]),
                  ),
              ),



            ],
        ),
        body:Column(
          children: <Widget>[
//            Text(_outlet.name, style: TextStyle(fontWeight: FontWeight.bold),),
//            Row(
//              mainAxisAlignment: MainAxisAlignment.spaceAround,
//              children: <Widget>[
//                RaisedButton(child: const Text("Save"),),
//                RaisedButton(child: const Text("Cancel"),),
//
//              ],),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                const Text("Вид учета"),
                DropdownButton<String>(
                  value: _selectedAT,
                  items: accountingTypes.map((String value) {
                    return new DropdownMenuItem<String>(
                      value: value,
                      child: new Text(value),
                    );
                  }).toList(),
                  onChanged: (selectedAT) {
                    setState(() {
                      _selectedAT=selectedAT;
                    });
                  },
                )

              ],),

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
                          Invoice(goodsControllers: _goodsControllers, goodsList: _goodsList),

                        ]
                      ),
                    ),
                  ),
              ),
            ),
          ],
        )
    );
  }

//  void onTabTap(int value) {
//    //print(value);
//  }
}

class Invoice extends StatefulWidget {
  Map<String, TextEditingController> goodsControllers;
  List<Goods> goodsList;

  Invoice({
    Key key,
    @required this.goodsControllers,
    @required this.goodsList,
  }) :  super(key: key);

   @override
   _InvoiceState createState() {
     return _InvoiceState(goodsControllers:goodsControllers, goodsList:goodsList);}}

class _InvoiceState extends State {
  Map<String, TextEditingController> goodsControllers;
  List<Goods> goodsList;

  _InvoiceState({
    Key key,
    @required this.goodsControllers,
    @required this.goodsList,
  });

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
              DataCell(Text("${goods.price}")),
              DataCell(TextField(
                controller: _controller,
              )),
              DataCell(Text("${goods.unit}")),
              DataCell(Text("?")),
              DataCell(Text("${num.parse(_controller.text)*goods.price}")),
        ]);

        //newRow.cells.add(DataCell())
        InvoiceRows.add(newRow);
      }
    });
    return SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Row(children: <Widget>[RaisedButton()],),
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
                    DataColumn(label: const Text('Коэффициент'), numeric: true),
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
  //TextEditingController controller = TextEditingController();
//  final String title;
  final List<Entry> children = <Entry>[];

  Entry({this.item}){
    this.id = this.item.id;
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
      return Container(
        color: Colors.white30,
        child: ListTile(
          title: Row(
            children: <Widget>[
              Text(root.item.name),
              //TextField(),
            ],
          ),
          subtitle: Text("Balance ${root.item.balance} ${root.item.unit}"),
            trailing: Container(
              width: 100,
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
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: "заказ",
                      ),
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
          title: Text("${root.item.name}", style: TextStyle(fontWeight: FontWeight.bold)),
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
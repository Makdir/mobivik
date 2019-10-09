import 'dart:collection';
import 'dart:wasm';

import 'package:flutter/material.dart';
import 'package:mobivik/dao/GoodsDAO.dart';
import 'package:mobivik/models/client_model.dart';
import 'package:mobivik/models/goods_model.dart';

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
  List _goodsWidget = List();
  List<Entry> entries = List();

  //List<Entry> resultGoodsList;

  Map<String, TextEditingController> _goodsControllers = new Map();


  _BuyOrderState(this._outlet);

  @override
  void initState() {
    super.initState();
    getData();
  }

  Future getData() async{

    List<Goods> goodsList = await GoodsDAO().getItems();
    goodsList.forEach((item){_goodsControllers.putIfAbsent(item.id, ()=> TextEditingController());});
    //_controllers.length = goodsList.length;
    //goodsList.forEach((item){print("Controller ${item.id}=${_goodsControllers[item.id].text}");});

    //TODO: dynamic leveling needed
    Goods item;
    //int index = 0;
    for(item in goodsList){
      String parentId = item.parent_id.toString().trim();
      Entry newEntry = Entry(item: item, controller: _goodsControllers[item.id]);
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
        appBar: AppBar(title: new Text("Заказ покупателя")),
        body:Column(
          children: <Widget>[
            Text(_outlet.name, style: TextStyle(fontWeight: FontWeight.bold),),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                RaisedButton(child: const Text("Save"),),
                RaisedButton(child: const Text("Cancel"),),

              ],),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                const Text("Вид учета"),
                DropdownButton<String>(

                  items: <String>['УУ', 'БУ'].map((String value) {
                    return new DropdownMenuItem<String>(
                      value: value,
                      child: new Text(value),
                    );
                  }).toList(),
                  onChanged: (_) {},
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
                          Tab(text: "Catalog"),
                          Tab(text: "Invoice"),
                      ],
                      ),

                    body: Container(
                      color: Colors.grey[300],
                      child: TabBarView(
                        children: [
                          TreeList(goodsWidget: _goodsWidget, goodsControllers:_goodsControllers),
                          Invoice(goodsControllers: _goodsControllers),

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

class Invoice extends StatelessWidget {
  Map<String, TextEditingController> goodsControllers;

  Invoice({
    Key key,
    @required Map<String, TextEditingController> this.goodsControllers,
  }) :  super(key: key);



  @override
  Widget build(BuildContext context) {
    List<DataRow> InvoiceRows = List();
    goodsControllers.forEach((k,v){
      print("$k=,${v.text}");
      double value;
      try {
        value = num.parse(v.text);
      } catch (e) {
        value = 1;
      }
      if (value>0) {
        DataRow newRow = DataRow(
            cells:[
              DataCell(Text("1")),
              DataCell(Text("1")),
              DataCell(Text("1")),

        ]);
        
        //newRow.cells.add(DataCell())
        InvoiceRows.add(newRow);
      }
    });
    return Column(
      children: <Widget>[
        Row(children: <Widget>[RaisedButton()],),
        DataTable(
          columns: [
            DataColumn(label: Text('Товар')),
            DataColumn(label: Text('Цена')),
            DataColumn(label: Text('Количество')),
          ],
          rows: InvoiceRows,
        )
      ],


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
  TextEditingController controller = TextEditingController();
//  final String title;
  final List<Entry> children = <Entry>[];

  Entry({this.item, this.controller}){
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
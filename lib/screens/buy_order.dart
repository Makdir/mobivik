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

  _BuyOrderState(this._outlet);

  @override
  void initState() {
    super.initState();
    getData();
  }

  Future getData() async{

    List<Goods> goodsList = await GoodsDAO().getItems();

    Goods item;
    for(item in goodsList){
      String parentId = item.parent_id.toString().trim();
      if((parentId!="")||(parentId.isNotEmpty))
      {
        Entry parentEntry = entries.firstWhere((entry)=>entry.id==parentId);
        parentEntry.children.add(Entry(item));
      }else{
        entries.add(Entry(item));
      }

    }

    setState(() {
      _goodsWidget.addAll(entries);
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(title: new Text("Заказ покупателя")),
        body:Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              Text(_outlet.name, style: TextStyle(fontWeight: FontWeight.bold),),
              Expanded(

                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,

                  child: Container(
                    width: 500.0,
                    decoration: BoxDecoration(
                        border: Border.all(width: 0.5, style: BorderStyle.solid),

                      ),
                    child: ListView.builder(
                      padding: EdgeInsets.all(8.0),
                      //itemExtent: 20.0,
                      itemCount: _goodsWidget.length,
                      itemBuilder: (BuildContext context, int index) {
                        return EntryItem(_goodsWidget[index]);
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        )
    );
  }
}

// One entry in the multilevel list displayed by this app.
class Entry {
//, [this.children = <Entry>[]]);
  final Goods item;
  String id;
//  final String title;
  final List<Entry> children = <Entry>[];

  Entry(this.item){
    this.id = this.item.id;
  }

}

// Displays one Entry. If the entry has children then it's displayed
// with an ExpansionTile.
class EntryItem extends StatelessWidget {
  const EntryItem(this.entry);

  final Entry entry;

  Widget _buildTiles(Entry root) {
    if (root.children.isEmpty)
      return Container(
        color: Colors.white30,
        child: ListTile(
          title: Row(
            children: <Widget>[
              Text(root.item.name),
              TextField(),
            ],
          ),
          subtitle: Text("Balance ${root.item.balance} ${root.item.unit}"),
        ),
      );
    return Card(
      elevation: 3,
      child: Container(
        decoration: new BoxDecoration(
          border: Border.all(width: 1.0, style: BorderStyle.solid),
          borderRadius: BorderRadius.all( Radius.circular(3.0)),
        ),
        child: ExpansionTile(
          key: PageStorageKey<Entry>(root),
          title: Text(root.item.name),
          children: root.children.map(_buildTiles).toList(),
          leading: Icon(Icons.arrow_right),
          backgroundColor: Colors.orangeAccent[100],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildTiles(entry);
  }
}
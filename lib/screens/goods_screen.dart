import 'package:flutter/material.dart';
import 'package:mobivik/dao/GoodsDAO.dart';
import 'package:mobivik/models/goods_model.dart';

class GoodsScreen extends StatefulWidget {
  @override
  _GoodsScreenState createState() {
    return _GoodsScreenState();
  }

}

class _GoodsScreenState extends State {
  List goodsWidget = List();

  List<Entry> entries = List();

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
      goodsWidget.addAll(entries);
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(title: new Text("Каталог товаров")),
        body:ListView.builder(
          padding: EdgeInsets.all(8.0),
          //itemExtent: 20.0,
          itemCount: goodsWidget.length,
          itemBuilder: (BuildContext context, int index) {
            return EntryItem(goodsWidget[index]);
          },
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
          title: Text(root.item.name),
          subtitle: Text("Balance ${root.item.balance} ${root.item.unit}"),
          leading: Icon(Icons.linear_scale),
        ),
      );
    return Card(
      elevation: 3,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(width: 0.5, style: BorderStyle.solid),
          borderRadius: BorderRadius.all( Radius.circular(3.0)),
        ),
        child: ExpansionTile(
          key: PageStorageKey<Entry>(root),
          title: Text(root.item.name, style: TextStyle(fontWeight: FontWeight.bold),),
          children: root.children.map(_buildTiles).toList(),
          leading: Icon(Icons.folder_open),
          backgroundColor: Colors.black38,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildTiles(entry);
  }
}
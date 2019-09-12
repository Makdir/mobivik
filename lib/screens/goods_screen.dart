import 'package:flutter/material.dart';
import 'package:mobivik/dao/GoodsDAO.dart';
import 'package:mobivik/models/Goods.dart';

class GoodsScreen extends StatefulWidget {
  @override
  _GoodsScreenState createState() {
    return _GoodsScreenState();
  }

}

class _GoodsScreenState extends State {
  List goods = List();

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
//      _widgetList.add(GoodsListRow(item));
      String parentId = item.parent_id.toString().trim();
      if((parentId!="")||(parentId.isNotEmpty))
      {
        Entry parentEntry = entries.firstWhere((entry)=>entry.id==parentId);
        parentEntry.children.add(Entry(item.id, item.name));
      }else{
        entries.add(Entry(item.id, item.name));
      }

    }

    setState(() {
      goods.addAll(goodsList);
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(title: new Text("Каталог товаров")),
        body:SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: SizedBox(
            width: 1000.0,
            child: ListView.builder(

              padding: EdgeInsets.all(8.0),

              //itemExtent: 20.0,
              itemCount: goods.length,
              itemBuilder: (BuildContext context, int index) {
                return EntryItem(goods[index]);
              },
            ),
          ),
        )
    );
  }

  ExpansionTile GoodsListRow(Goods item) {
    return ExpansionTile(
      key: Key(item.id),
      trailing: Icon(Icons.arrow_forward_ios),
      title:Row(
        children: [
          Text("${item.name} (${item.unit})"),
          Text(item.price.toString()),

        ]),
//      subtitle: Text("Остаток: ${item.balance.toString()}"),
//      onTap: (){
//        Navigator.push(context, MaterialPageRoute(builder: (context) => GoodsScreen(),
//        ),
//        );},
    );





  }

  Row GoodsListRowFolder(int index) =>

        Row(
          children: [
            Text("${goods[index].name} (${goods[index].unit})"),
            Text(goods[index].price.toString()),

        ]);
}


// One entry in the multilevel list displayed by this app.
class Entry {
  Entry(this.id, this.title, [this.children = const <Entry>[]]);
  final String id;
  final String title;
  final List<Entry> children;
}

// Displays one Entry. If the entry has children then it's displayed
// with an ExpansionTile.
class EntryItem extends StatelessWidget {
  const EntryItem(this.entry);

  final Entry entry;

  Widget _buildTiles(Entry root) {
    if (root.children.isEmpty) return ListTile(title: Text(root.title));
    return ExpansionTile(
      key: PageStorageKey<Entry>(root),
      title: Text(root.title),
      children: root.children.map(_buildTiles).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildTiles(entry);
  }
}
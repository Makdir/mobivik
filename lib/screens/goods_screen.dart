import 'package:flutter/material.dart';
import 'package:mobivik/dao/goods_dao.dart';
import 'package:mobivik/models/goods_model.dart';
import 'package:mobivik/services/goods_entries.dart';

class GoodsScreen extends StatefulWidget {
  @override
  _GoodsScreenState createState() {
    return _GoodsScreenState();
  }

}

class _GoodsScreenState extends State {
  List<Entry> _goodsWidget = [];
  List<Goods> goodsList = [];
  List<Entry> entries = [];

  @override
  void initState() {
    super.initState();
    _getData();
  }

  Future _getData() async{

    goodsList = await GoodsDAO().getItems();
    // Forming hierarchcal structure
    goodsList.forEach((item){
      Entry newEntry = Entry(item: item);
      entries.add(newEntry);
    });

    // Item can not have empty id. It is wrong.
    entries.removeWhere((entry) => entry.id.isEmpty);

    entries.forEach((item){
      try {
        String parentId = item.parentId.toString().trim();
        Entry parentEntry = entries.firstWhere((entry) => entry.id == parentId);
        //print('${parentEntry.item.name}: ${parentEntry.level}');
        parentEntry.children.add(item);
        // calcing of level
        try {
          item.level = parentEntry.level + 1;
          //print(' ${item.item.name}: ${item.level}');
        } catch (e) {}

      } catch (e) {}
    });
    // Deleting items without paren. (But also this may be due to wrong data.)
    entries.removeWhere((entry) => entry.parentId != "");

    setState(() {
      _goodsWidget.addAll(entries);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black54,
        appBar: new AppBar(title: new Text("Каталог товаров")),
        body: TreeList(goodsWidget: _goodsWidget,),
    );
  }
}

class EntryItem extends StatelessWidget {

  final Entry entry;

  EntryItem(this.entry);

  Widget buildTiles(Entry root) {

    int isFolder = root.item.isFolder;
    int level = root.level;
    if ((root.children.isEmpty)&&(isFolder==0)){
      double balance = root.item.balance;
      return Card(
        child: ListTile(
            title: Text(root.item.name),
            //subtitle: Text("Цена ${root.item.price} грн. Остаток $balance ${root.item.unit}"),
            trailing: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text("Цена: ${root.item.price.toStringAsFixed(2)} грн."),
                  Text("Остаток: $balance ${root.item.unit}"),
                ],
              ),
            )
        ),
      );}
    if (isFolder==1)
      return Card(
        color: Color.fromARGB(255-50*level, 230+2*level, 230+4*level, 230+8*level ),
        elevation: 3,
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(width: 0.5, style: BorderStyle.solid),
            borderRadius: BorderRadius.all( Radius.circular(3.0)),
          ),
          child: ExpansionTile(
            key: PageStorageKey<Entry>(root),
            title: Text("${root.item.name}", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
            children: root.children.map(buildTiles).toList(),
            leading: Icon(Icons.arrow_right),
          ),
        ),
      );
    return const Text('');
  }

  @override
  Widget build(BuildContext context) {
    return buildTiles(entry);
  }

}

class TreeList extends StatelessWidget {

  final List<Entry> goodsWidget;
  //final Map<String, TextEditingController> goodsControllers;
  //BuyOrderState summoner;

  TreeList({
    Key key,
    @required this.goodsWidget,
    //@required this.goodsControllers,
    //@required this.summoner,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.all(3.0),
      itemCount: goodsWidget.length,
      itemBuilder: (BuildContext context, int index) {
        return EntryItem(goodsWidget[index]);
      },
    );
  }
}
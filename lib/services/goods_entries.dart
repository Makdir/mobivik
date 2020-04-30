import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobivik/screens/buy_order.dart';
import '../models/goods_model.dart';

/// One entry in the multilevel list displayed by this app.
class Entry {

  final Goods item;
  String id;
  String parent_id;
  final List<Entry> children = <Entry>[];

  Entry({this.item}){
    this.id = this.item.id;
    this.parent_id = this.item.parentId;
  }

}

/// Displays one Entry. If the entry has children then it's displayed
/// with an ExpansionTile.
class EntryItem extends StatelessWidget {

  final Entry entry;
  final Map<String, TextEditingController> goodsControllers;
  BuyOrderState summoner;

  EntryItem(this.entry, this.goodsControllers, this.summoner);

  Widget buildTiles(Entry root) {
    var itemID = root.id;
    int isFolder = root.item.isFolder;
    if ((root.children.isEmpty)&&(isFolder==0)){
      double balance = root.item.balance;
      return Card(
        child: ListTile(
            title: Text(root.item.name),
            subtitle: Text("Цена ${root.item.price} грн. Остаток $balance ${root.item.unit}"),
            trailing: Container(
              width: 75,
              decoration: BoxDecoration(
                border: Border.all(width: 0.5, style: BorderStyle.solid),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Expanded(
                    //flex: 3,
                    child: TextField(
                        key: PageStorageKey(itemID),
                        controller: goodsControllers[itemID],
                        onChanged: (text){
                          totalSumRecalc(summoner, goodsControllers);
                          },
                        textAlign: TextAlign.end,
                        keyboardType: TextInputType.numberWithOptions(signed: false, decimal: true),
                        decoration: InputDecoration(
                          hintText: (balance>0) ? "заказ" : "-",
                          fillColor: Colors.grey,
                          filled: balance<=0,
                        ),
                        //readOnly: balance<=0,
                        inputFormatters: [
                          WhitelistingTextInputFormatter(RegExp("[0-9]")),
                          //BlacklistingTextInputFormatter(RegExp(".."))
                        ]
                    ),
                  ),

                ],
              ),
            )
        ),
      );}
    if (isFolder==1)
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
            //backgroundColor: Colors.lightGreenAccent,
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
  final Map<String, TextEditingController> goodsControllers;
  BuyOrderState summoner;

  TreeList({
    Key key,
    @required this.goodsWidget,
    @required this.goodsControllers,
    @required this.summoner,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.all(3.0),
      itemCount: goodsWidget.length,
      itemBuilder: (BuildContext context, int index) {
        return EntryItem(goodsWidget[index], goodsControllers, summoner);
      },
    );
  }
}
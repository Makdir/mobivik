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

  List<ExpansionTile> _widgetList = List();

  @override
  void initState() {
    super.initState();
    getData();
  }

  Future getData() async{

    List<Goods> goodsList = await GoodsDAO().getItems();
    //List<dynamic> jsonData = json.decode(textData);
    Goods item;
    for(item in goodsList){
      _widgetList.add(GoodsListRow(item));

    }

    setState(() {
      goods.addAll(_widgetList);
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
                return _widgetList[index];
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


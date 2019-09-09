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
  List<Goods> goods = List();

  @override
  void initState() {
    super.initState();
    getData();
  }

  Future getData() async{

    List<Goods> goodsList = await GoodsDAO().getItems();
    //List<dynamic> jsonData = json.decode(textData);

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
                return ListTile(
                  trailing: Icon(Icons.arrow_forward_ios),
                  title:GoodsListRow(index),
                  subtitle: Text("Остаток: ${goods[index].balance.toString()}"),
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => GoodsScreen(),
                    ),
                    );},
                );
              },
            ),
          ),
        )
    );
  }

  Row GoodsListRow(int index) => Row(
      children: [
        Text(goods[index].name),
        Text(goods[index].unit),
        Text(goods[index].brand),
        Text(goods[index].price.toString()),
        Text(goods[index].balance.toString()),
      ]);
}


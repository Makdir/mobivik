import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mobivik/common/file_provider.dart';
import 'package:mobivik/models/client_model.dart';
import 'package:mobivik/screens/buy_order.dart';

class SalesHistoryFragment extends StatefulWidget{
  final Client outlet;

  SalesHistoryFragment({@required this.outlet});

  @override
  _SalesHistoryFragmentState createState() {
    return _SalesHistoryFragmentState(outlet: outlet);
  }

}

class _SalesHistoryFragmentState extends State{
  final Client outlet;

  _SalesHistoryFragmentState({@required this.outlet});

  List salesList = [];

  @override
  void initState(){
    super.initState();
    getData();

  }

  getData() async {
    File salesFile = await FileProvider.openInputFile('sales');
    String content = await salesFile.readAsString();
    //print('content =  $content');
    try{
        salesList = await json.decode(content);
    }catch (e) {
        print('Wrong content of sales history.');
    }
    //print('salesList =  $salesList');
    String outletId = outlet.id;
    salesList =  salesList.where((element) => element['id']==outletId).toList();
    //print('2 salesList =  $salesList');
    setState(() {

    });

  }

  @override
  Widget build(BuildContext context) {
    //double iconSize = 40;
    return ListView.builder(
      padding: EdgeInsets.all(1.0),
      itemCount: salesList.length,
      itemBuilder: (BuildContext context, int index) {
        return Card(
          child: ListTile(
            title:Text(salesList[index]['doc']),
            subtitle: HistorySalesTable(salesList[index]['table']),
          ),
        );
      },
    );
  }

  Widget HistorySalesTable(List saleDoc){
    TextStyle headerTextStyle = TextStyle(color: Colors.black, fontWeight: FontWeight.w500);
    TextStyle rowTextStyle = TextStyle(color: Colors.black);
    List<TableRow> sales = [];
    sales.add(
        TableRow(
          decoration: BoxDecoration(color: Colors.grey),
            children: [
              Text('Товар', style: headerTextStyle, textAlign: TextAlign.center,),
              Text('Кол-во', style: headerTextStyle, textAlign: TextAlign.center,),
              Text('Ед. изм.', style: headerTextStyle, textAlign: TextAlign.center,),
              Text('Цена', style: headerTextStyle, textAlign: TextAlign.center,),
            ]
        )
    );

    for(Map sale in saleDoc) {
      String price = double.parse(sale['price'].toString()).toStringAsFixed(2);
      sales.add(
          TableRow(
              children: [
                Text(' ${sale['name']}', style: rowTextStyle, textAlign: TextAlign.start),
                Text(' ${sale['number']} ', style: rowTextStyle, textAlign: TextAlign.center),
                Text(' ${sale['unit']}',  style: rowTextStyle, textAlign: TextAlign.start),
                Text(' $price', style: rowTextStyle, textAlign: TextAlign.start),
              ],
          )
      );
    }

    return Table(
      border: TableBorder.all(),
      defaultColumnWidth: IntrinsicColumnWidth(),
      children: sales,
    );
  }


}


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
    print('content =  $content');
    try{
        salesList = await json.decode(content);
    }catch (e) {
        print('Wrong content of sales history.');
    }
    print('salesList =  $salesList');
    String outletId = outlet.id;
    salesList =  salesList.where((element) => element['id']==outletId).toList();
    print('2 salesList =  $salesList');
    setState(() {

    });

  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.all(1.0),
      itemCount: salesList.length,
      itemBuilder: (BuildContext context, int index) {
        return Card(
          child: ListTile(
            //trailing: Icon(Icons.arrow_forward_ios),
            title:Text(salesList[index]['doc']),
            subtitle: Text(salesList[index]['table'].toString()),
          ),
        );
      },
    );
  }




}


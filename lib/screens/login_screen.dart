import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return new Scaffold( // 1
      appBar: new AppBar(
        title: new Text("Please, login"), // screen title

      ),
      body: new Center(
        child: new Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            new Container(
              padding: const EdgeInsets.all(16.0),
              child: new TextField(
                keyboardType: TextInputType.number,
                //controller: _controller,
                decoration: new InputDecoration(
                  hintText: 'Zip Code',
                ),
                onSubmitted: (string) {
                  return string;
                },
              ),
            ),

            new RaisedButton(onPressed: () {
              button1(context);
              }, child: new Text("Go to Screen 2"),
            )
          ],
        ),
      ) ,
    );
  }

  void button1(BuildContext context){
    print("Button 1");
    Navigator.of(context).pushNamed('/screen2');
  }
}
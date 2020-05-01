import 'package:flutter/material.dart';

class GraphicalUI{
  static showSnackBar({@required scaffoldKey, @required context, String actionLabel, String resultMessage}){
    final snackBar = SnackBar(
      content: Text(resultMessage),
      elevation: 5,
      action: SnackBarAction(
        label: actionLabel,
        onPressed: () {
          Navigator.pop(context);
        },

      ),
    );

    scaffoldKey.currentState.showSnackBar(snackBar);
  }

  static Future<bool> confirmDialog(BuildContext context, String message) async{
    return await showDialog<bool>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(message),
            actions: <Widget>[
              FlatButton(
                child: const Text('YES'),
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
              ),
              FlatButton(
                child: const Text('NO'),
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
              ),
            ],
          );
        });
  }

}

/// General theme button
/// @param caption - title of button
/// @param onPressedAction - event of button clicking

class StandardButton extends StatelessWidget {
  final String text;
  final onPressedAction;

  StandardButton({
    Key key,
    this.text,
    this.onPressedAction
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      minWidth: 200,
      child: Text(text, style: TextStyle(fontWeight: FontWeight.bold),),
      color: Colors.amber,
      //padding: EdgeInsets.fromLTRB(90, 9, 90, 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(10.0),
            bottomRight: Radius.circular(10.0),
            topLeft: Radius.circular(10.0),
            topRight: Radius.circular(10.0)),
      ),
      splashColor: Colors.limeAccent,
      elevation: 3,
      onPressed: onPressedAction,
    );
  }
}

class OrderButton extends StatelessWidget {
  final String text;
  final onPressedAction;

  const OrderButton({
    Key key,
    this.text,
    this.onPressedAction
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(top: 25),
        child: RaisedButton(
          child: Text('$text'),
          onPressed: onPressedAction,
          shape: StadiumBorder(),
          elevation: 5.0,
        )

    );

  }
}
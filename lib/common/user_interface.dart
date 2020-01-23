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

  static Future<bool> confirmDialog1(BuildContext context, String message) async{
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


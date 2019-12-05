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
}
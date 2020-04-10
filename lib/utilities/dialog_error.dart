import 'package:flutter/material.dart';
showErrorDialog({BuildContext context,String errorMessage}) {
  showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('An error occured!'),
        content: Text(errorMessage),
        actions: <Widget>[
          FlatButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Ok')),
        ],
      ));
}
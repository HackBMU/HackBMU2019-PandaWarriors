import 'package:flutter/material.dart';

class Security extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('firebase'),
        ),
        body: Center(
          child: RaisedButton(onPressed: () => Navigator.pop(context))
        ),
      ),
    );
  }

}
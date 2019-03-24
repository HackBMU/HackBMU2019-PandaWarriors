import 'package:flutter/material.dart';
import 'security.dart';

class drawer extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Drawer(
        child: ListView(
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: Text("Nalin Luthra"),
            accountEmail: Text("nalin.luthra@gmail.com"),
            currentAccountPicture: CircleAvatar(
              backgroundColor:
              Theme.of(context).platform == TargetPlatform.iOS
                  ? Colors.red
                  : Colors.white,
              child: Text(
                "N",
                style: TextStyle(fontSize: 40.0),
              ),
            ),
          ),
          ListTile(
            title: Text('Usage Division'),
            trailing: Icon(Icons.arrow_forward),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (BuildContext context) => Security()));
            },
          ),
          ListTile(
            title: Text('Security'),
            trailing: Icon(Icons.arrow_forward),
          ),
        ],
      ),
    );
  }

}
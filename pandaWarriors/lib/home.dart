import 'package:flutter/material.dart';
import 'resource.dart';
import 'dart:core';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_circular_chart/flutter_circular_chart.dart';
import "package:pull_to_refresh/pull_to_refresh.dart";
import'security.dart';
import 'package:splashscreen/splashscreen.dart';
import 'drawer.dart';

class Home extends StatefulWidget{

  @override
  HomeState createState() => HomeState();

}

class HomeState extends State<Home> {

  static List<myData> allData = [];

  @override
  void initState () {
    DatabaseReference ref = FirebaseDatabase.instance.reference();
    var devices = ref.child('bmu-hackathon').child('temperature');
    devices.once().then((DataSnapshot snap) {
      var keys = snap.value.keys;
      var data = snap.value;
      allData.clear();
      for (var key in keys) {
        myData d = new myData(
          data[key]['date'],
          data[key]['time'],
          data[key]['value'],
        );
        allData.add(d);
      }
      setState(() {
        print('Length : ${allData.length}');
      });
    });
  }

  static double size = double.parse(allData[2].value);

  @override
  Widget build (BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.red,
          title: Text('firebase'),
        ),
        drawer: drawer(),
          body: allData.length == 0 ?
          new SplashScreen(
          seconds: 10,
//          title: new Text('Welcome In SplashScreen'),
          image: Image.asset('panda_warriors.png', height: 500.0, width: 500.0,),
          backgroundColor: Colors.white,
          styleTextUnderTheLoader: new TextStyle(),
          photoSize: 100.0,
          loaderColor: Colors.red
          ):
          RefreshIndicator(
              onRefresh: refresh,
              child: ListView(
                  shrinkWrap: true,
                  children: [
                    Container(
                      height: 500.0,
                      child: Stack(
                        children: <Widget>[
                          new Positioned(
                            child: new CircleButton(
                                onTap: () => print(size.runtimeType),
                                iconLabel: 'bulb',
                                size: size),
                            top: 10.0,
                            right: 30.0,
                          ),
                          new Positioned(
                            child: new CircleButton(
                                onTap: () => print(size.runtimeType),
                                iconLabel: 'bulb',
                                size: size),
                            top: 100.0,
                            left: 30.0,
                          ),
                          new Positioned(
                            child: new CircleButton(onTap: () => print("Cool"),
                                iconLabel: 'charger',
                                size: 100.0),
                            top: 300.0,
                            left: 10.0,
                          ),
                          new Positioned(
                            child: new CircleButton(onTap: () => print("Cool"),
                                iconLabel: 'hair dryer',
                                size: 100.0),
                            top: 200.0,
                            right: 10.0,
                          ),
                        ],
                      ),
                    ),
                    ListTile(
                      trailing: Text('$size'),
                      leading: Text('$size'),
                    ),
                    new ListView.builder(
                      shrinkWrap: true,
                      itemBuilder: (_, index) {
                        return UI(allData[index].date, allData[index].time,
                            allData[index].value);
                      }, itemCount: 4,
                    )
                  ]
              )
          )
      ),
    );
  }

  Widget UI (String date, String time, String value) {
    return new Card(
      child: new Container(
        child: new Column(
          children: <Widget>[
            new Text('date: $date'),
            new Text('time: $time'),
            new Text('vale: $value'),
          ],
        ),
      ),
    );
  }


  Widget bigCircle = new Container(
    width: 300.0,
    height: 300.0,
    child: Center(child: Text('bulb')),
    decoration: new BoxDecoration(
      color: Colors.orange,
      shape: BoxShape.circle,
    ),
  );



}

class CircleButton extends StatelessWidget {
  final GestureTapCallback onTap;
  final String iconLabel;
  final double size;


  const CircleButton({Key key, this.onTap, this.iconLabel, this.size}) : super(key: key);

  @override
  Widget build(BuildContext context) {
//    double size = 100.0;
    return new InkResponse(
      onTap: onTap,
      child: new Container(
        width: size,
        height: size,
        decoration: new BoxDecoration(
          color: Color.fromRGBO(176, 0, 32, 1.0),
          shape: BoxShape.circle,
        ),
        child: Center(child: Text('$iconLabel')),
      ),
    );
  }


}



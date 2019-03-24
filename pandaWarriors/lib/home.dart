import 'package:flutter/material.dart';
import 'resource.dart';
import 'dart:core';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_circular_chart/flutter_circular_chart.dart';
import "package:pull_to_refresh/pull_to_refresh.dart";
import'security.dart';
import 'package:splashscreen/splashscreen.dart';
import 'drawer.dart';
import 'dart:math';

class Home extends StatefulWidget{

  @override
  HomeState createState() => HomeState();

}

class HomeState extends State<Home> {

  static List<myData> allData = [];

  @override
  void initState () {
    DatabaseReference ref = FirebaseDatabase.instance.reference();
    var devices = ref.child('devices');
    devices.once().then((DataSnapshot snap) {


      var data = snap.value;
      var keys = snap.value.keys;
      print(data);
      allData.clear();
      for (var key in keys) {
        print(key);
        myData d = new myData(
          data[key]['status'],
          data[key]['color'],
          data[key]['power'],
        );
        allData.add(d);
      }
      setState(() {
        print('Length : ${allData.length}');
      });
    });
  }

  static int size0 = allData[0].power;
  static int size1 = allData[1].power;
  static int size2 = allData[2].power;

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
                      height: 800.0,
                      child: Stack(
                        children: <Widget>[
                          new Positioned(
                            child: new CircleButton(
                                onTap: () => print(Usage(size0).toInt()),
                                iconLabel: 'Laptop',
                                size: (Usage(size0).toInt())*20),
                            top: 10.0,
                            right: 30.0,
                          ),
                          new Positioned(
                            child: new CircleButton(
                                onTap: () => print(Usage(size1).toInt()),
                                iconLabel: 'bulb',
                                size: (Usage(size1).toInt())*20),
                            top: 100.0,
                            left: 30.0,
                          ),
//                          new Positioned(
//                            child: new CircleButton(onTap: () => print("Cool"),
//                                iconLabel: 'charger',
//                                size: 100),
//                            top: 300.0,
//                            left: 10.0,
//                          ),
                          new Positioned(
                            child: new CircleButton(onTap: () => print(Usage(size2).toInt()),
                                iconLabel: 'hair dryer',
                                size: (Usage(size2).toInt())*5),
                            top: 300.0,
                            right: 10.0,
                          ),
                        ],
                      ),
                    ),
                    ListTile(
                      trailing: Text('$net'),
                      leading: Text('$net'),
                    ),
                    new ListView.builder(
                      shrinkWrap: true,
                      itemBuilder: (_, index) {
                        return UI(allData[index].status, allData[index].color,
                            allData[index].power);
                      }, itemCount: allData.length,
                    )
                  ]
              )
          )
      ),
    );
  }
  static int net = Sum(size0, size1, size2);
  static int Sum(int size0, int size1, int size2){

    var sum = size1+size0+size2;
    return sum;
  }

  static double Usage(int size){

    return size/(net)*100;

  }

  Future<Null> refresh() async {
    await Future.delayed(Duration(seconds: 2));
    DatabaseReference ref = FirebaseDatabase.instance.reference();
    var devices = ref.child('devices');

    devices.once().then((DataSnapshot snap) {
      var keys = snap.value.keys;
      var data = snap.value;
      allData.clear();
      for (var key in keys) {
        setState(() {
          allData.add(
              new myData(data[key]['status'], data[key]['color'], data[key]['power'])
          );
        });

      }

    });
    return null;
  }

  Widget UI (String status, String color, int power) {
    return new Card(
      child: new Container(
        child: new Column(
          children: <Widget>[
            new Text('date: $status'),
            new Text('time: $color'),
            new Text('vale: $power'),
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
  final int size;


  const CircleButton({Key key, this.onTap, this.iconLabel, this.size}) : super(key: key);

  @override
  Widget build(BuildContext context) {
//    double size = 100.0;
    return new InkResponse(
      onTap: onTap,
      child: new Container(
        width: size.toDouble(),
        height: size.toDouble(),
        decoration: new BoxDecoration(
          color: Color.fromRGBO(176, 0, 32, 1.0),
          shape: BoxShape.circle,
        ),
        child: Center(child: Text('$iconLabel', style: TextStyle(color: Colors.white))),
      ),
    );
  }


}



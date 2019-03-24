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
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar:
        AppBar(
          backgroundColor: Colors.red[800],
          title: Center( child: Text('Home Screen')),
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
                      height: 400.0,
                      child: Stack(
                        children: <Widget>[
                          new Positioned(
                            child: new CircleButton(
                                onTap: () => print(usage(size0).toInt()),
                                iconLabel: 'Laptop',
                                usage: usage(size0).toInt(),
                                size: (usage(size0).toInt())*50),
                            top: 50.0,
                            right: 0.0,
                          ),
                          new Positioned(
                            child: new CircleButton(
                                onTap: () => print(usage(size1).toInt()),
                                usage: usage(size1).toInt(),
                                iconLabel: 'bulb',
                                size: (usage(size1).toInt())*20),
                            top: 30.0,
                            left: 20.0,
                          ),
//                          new Positioned(
//                            child: new CircleButton(onTap: () => print("Cool"),
//                                iconLabel: 'charger',
//                                size: 100),
//                            top: 300.0,
//                            left: 10.0,
//                          ),
                          new Positioned(
                            child: new CircleButton(onTap: () => print(usage(size2).toInt()),
                                iconLabel: 'hair dryer',
                                usage: usage(size2).toInt(),
                                size: (usage(size2).toInt())*3),
                            top: 200.0,
                            right: 10.0,
                          ),
                        ],
                      ),
                    ),
                    ListTile(
                      trailing: Text('$net', style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),),
                      leading: Text('$net', style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),),
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

double usage(int size){

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
              new myData(data[key]['Status'], data[key]['color'], data[key]['power'])
          );
        });

      }

    });
    return null;
  }

  Widget UI (String status, String color, int power) {
    return new Card(
      child: new Container(
        color: Colors.red[800],
        child: new Column(
          children: <Widget>[
            Container(
              child: Padding(padding: EdgeInsets.only(top: 40.0, right: 30.0),child: Text('Status: $status', style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold, color: Colors.white),)),
            height: 124.0,
                margin: new EdgeInsets.only(left: 46.0),
              decoration: new BoxDecoration(
              shape: BoxShape.rectangle,
              borderRadius: new BorderRadius.circular(8.0),
//          boxShadow: <BoxShadow>[
//           new BoxShadow(
//              color: Colors.black12,
//              blurRadius: 10.0,
//              offset: new Offset(0.0, 10.0),
//            ),
//          ],
        ),
      ),
//            new Text('Color: $color') ,
            new Padding(padding: EdgeInsets.only(bottom: 30.0), child: Text('Power Consumed: $power', style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold, color: Colors.white),)),
          ],
        ),
      ),
    );
  }



}

class CircleButton extends StatelessWidget {
  final GestureTapCallback onTap;
  final String iconLabel;
  final int size;
  final int usage;

  const CircleButton({Key key, this.onTap, this.iconLabel, this.size, this.usage}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new InkResponse(
      onTap: onTap,
      child: new Center( child: Container(
        width: size.toDouble(),
        height: size.toDouble(),
        decoration: new BoxDecoration(
          color: Color.fromRGBO(176, 0, 32, 1.0),
          shape: BoxShape.circle,
        ),
        child: Center( child: Column(children: [Container(height: 10.0,), Text('$iconLabel', style: TextStyle(color: Colors.white, fontSize: 20.0)),Text('$usage', style: TextStyle(color: Colors.white,))]),
      ),
      ),
    ),
    );
  }


}



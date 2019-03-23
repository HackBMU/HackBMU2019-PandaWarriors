import 'package:flutter/material.dart';
import 'resource.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_circular_chart/flutter_circular_chart.dart';
import "package:pull_to_refresh/pull_to_refresh.dart";

class Home extends StatefulWidget{

  @override
  HomeState createState() => HomeState();

}

class HomeState extends State<Home> {

  final GlobalKey<AnimatedCircularChartState> _chartKey = new GlobalKey<
      AnimatedCircularChartState>();

  List<myData> allData = [];

  @override
  void initState () {
    DatabaseReference ref = FirebaseDatabase.instance.reference();
    var devices = ref.child('bmu-hackathon').child('temperature');

    devices.once().then((DataSnapshot snap) {
      var keys = snap.value.keys;
      var data = snap.value;
      allData.clear();
      for (var key in keys) {
        allData.add(
            new myData(data[key]['date'], data[key]['time'], data[key]['value'])
        );
      }
      setState(() {
        print('length: $allData.length');
      });
    }
    );
  }

  @override
  Widget build (BuildContext context) {
    // TODO: implement build
    return MaterialApp(
        home: Scaffold(
            body: allData.length == 0 ? new Text('no data') :
                RefreshIndicator(
                  onRefresh: refresh,
                child: ListView(
                    shrinkWrap: true,
                    children: [
                      Stack(
                        children: <Widget>[
                          new Positioned(
                            child: new CircleButton(onTap: () => print("Cool"), iconData: Icons.timer),
                            top: 120.0,
                            left: 10.0,
                          ),
                          new Positioned(
                            child: new CircleButton(onTap: () => print("Cool"), iconData: Icons.place),
                            top: 120.0,
                            right: 10.0,
                          ),
                          new Positioned(
                            child: new CircleButton(onTap: () => print("Cool"), iconData: Icons.local_pizza),
                            top: 240.0,
                            left: 130.0,
                          ),
                          new Positioned(
                            child: new CircleButton(onTap: () => print("Cool"), iconData: Icons.satellite),
                            top: 120.0,
                            left: 130.0,
                          ),
                        ],
                      ),
                      new ListView.builder(
                        shrinkWrap: true,
                        itemBuilder: (_, index) {
                          return UI(allData[index].date, allData[index].time,
                              allData[index].value);
                        }, itemCount: allData.length,
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
            new Text('date: $time'),
            new Text('date: $value'),
          ],
        ),
      ),
    );

  }

  Future<Null> refresh() async {
    await Future.delayed(Duration(seconds: 2));
    DatabaseReference ref = FirebaseDatabase.instance.reference();
    var devices = ref.child('bmu-hackathon').child('temperature');

    devices.once().then((DataSnapshot snap) {
      var keys = snap.value.keys;
      var data = snap.value;
      allData.clear();
      for (var key in keys) {
        setState(() {
          allData.add(
              new myData(data[key]['date'], data[key]['time'], data[key]['value'])
          );
        });

  }

    });
        return null;
  }
}

class CircleButton extends StatelessWidget {
  final GestureTapCallback onTap;
  final IconData iconData;

  const CircleButton({Key key, this.onTap, this.iconData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double size = 5.0;

    return new InkResponse(
      onTap: onTap,
      child: new Container(
        width: size,
        height: size,
        decoration: new BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
        ),
        child: new Icon(
          iconData,
          color: Colors.black,
        ),
      ),
    );
  }
}

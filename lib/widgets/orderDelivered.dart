import 'package:flutter/material.dart';
import 'package:firebase/firebase.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:geodesy/geodesy.dart';
import 'package:delivery/utils/globals.dart' as globals;

class orderDeliveredPage extends StatefulWidget {
  @override
  _orderDeliveredPageState createState() => _orderDeliveredPageState();
}

class _orderDeliveredPageState extends State<orderDeliveredPage> {

  Map<dynamic, dynamic> values = new Map();
  List _data = [];
  List ordersDelivered = [];
  Geodesy geodesy = Geodesy();

  void _getData() async{

    Database db = database();
    DatabaseReference ref = db.ref('users');

    ref.onValue.listen((e) {
      DataSnapshot datasnapshot = e.snapshot;
      values = datasnapshot.val();
      setState(() => 
        values.forEach((key, val) {
          val["key"] = key;
          _data.add(val);
        })
      );
    });
  }

  void alertDialog(BuildContext context) {
    var alert = AlertDialog(
      title: Text("Dialog title"),
      content: Text("Dialog description"),
    );
  showDialog(context: context, builder: (BuildContext context) => alert);
  }

  _showDialog(int index) {
    showDialog(
      context: context,
      builder: (_) => new AlertDialog(
        title: new Text(_data[index]["nom"]),
        content: Container(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            FlatButton(
            child: Text('Appeler client!'),
              onPressed: () => launch("tel://${_data[index]["tel"]}"),
            ),
            FlatButton(
              child: Text('go maps!'),
              onPressed: () => MapsLauncher.launchCoordinates(
                _data[index]["location"]["latitude"], _data[index]["location"]["longitude"]
              ),
            ),
            FlatButton(
            child: Text('Livré!'),
              onPressed: () {
                Database db = database();
                DatabaseReference ref = db.ref('users/'+ _data[index]["key"] + "/status");
                ref.set('delivered');
              },
            )
          ],
        )),
        actions: <Widget>[
          FlatButton(
            child: Text('Annuler!'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          )
        ],
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    ordersDelivered = _data.where((item) => item["status"] == "delivered").toList();
    return new Scaffold(
      body: new Container(
          padding: new EdgeInsets.all(32.0),
          child: new Center(
            child: new Column(
              children: <Widget>[
                new Text('Orders', style: new TextStyle(fontWeight: FontWeight.bold),),
                new Expanded(child: new ListView.builder(
                  itemCount: ordersDelivered.length,
                  itemBuilder: (BuildContext context, int index){
                    LatLng l1 = LatLng(ordersDelivered[index]["location"]["latitude"], ordersDelivered[index]["location"]["longitude"]);
                    LatLng l2 = LatLng(globals.lat, globals.lng);
                    return Card(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          ListTile(
                            title: Text(ordersDelivered[index]["numero"]),
                            onTap: () {_showDialog(index);},
                          ),
                          Text("Nom: " + ordersDelivered[index]["nom"]),
                          Text("Prenom: " + ordersDelivered[index]["prenom"]),
                          Text("Tel: " + ordersDelivered[index]["tel"].toString()),
                          Text("Comment: " + ordersDelivered[index]["comment"]),
                          Text("adresse: " + ordersDelivered[index]["location"]["adresse"]),
                          Text(geodesy.distanceBetweenTwoGeoPoints(l1, l2).toString()),
                        ],
                      ),
                    );
                  },
                ))
              ],
            ),
          )
      ),
    );
  }
  @override
  void initState() {
    _getData();
  }
}
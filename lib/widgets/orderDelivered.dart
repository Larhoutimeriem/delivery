import 'package:flutter/material.dart';
import 'package:firebase/firebase.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:geodesy/geodesy.dart';
import 'package:delivery/utils/globals.dart' as globals;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
      _data = [];
      if (!mounted) return;
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

  _showDialog(order) {
    showDialog(
      context: context,
      builder: (_) => new AlertDialog(
        title: new Text(order["nom"]),
        content: Container(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            FlatButton(
            child: Text('Appeler client!'),
              onPressed: () => launch("tel://${order["tel"]}"),
            ),
            FlatButton(
              child: Text('go maps!'),
              onPressed: () => MapsLauncher.launchCoordinates(
                order["location"]["latitude"], order["location"]["longitude"]
              ),
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
    IconData icon;
    return Container(
          padding: new EdgeInsets.all(32.0),
          child: new Center(
            child: new Column(
              children: <Widget>[
                new Expanded(child: new ListView.builder(
                  itemCount: ordersDelivered.length,
                  itemBuilder: (BuildContext context, int index){
                    LatLng l1 = LatLng(ordersDelivered[index]["location"]["latitude"], ordersDelivered[index]["location"]["longitude"]);
                    LatLng l2 = LatLng(globals.lat, globals.lng);
                    if(ordersDelivered[index]["paymentInfos"]=="cash")
                      icon = FontAwesomeIcons.handHoldingUsd;
                    if(ordersDelivered[index]["paymentInfos"]=="card")
                      icon = FontAwesomeIcons.creditCard;
                    return Card(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          ListTile(
                            title: Text(ordersDelivered[index]["numero"]),
                            onTap: () {_showDialog(ordersDelivered[index]);},
                          ),
                          Text("Nom: " + ordersDelivered[index]["nom"]),
                          Text("Prénom: " + ordersDelivered[index]["prenom"]),
                          Text("Tel: " + ordersDelivered[index]["tel"].toString()),
                          Text("Commentaire: " + ordersDelivered[index]["comment"]),
                          Text("adresse: " + ordersDelivered[index]["location"]["adresse"]),
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  style: TextStyle(color: Colors.black),
                                  text: "Paiement: ",
                                ),
                                TextSpan(
                                  style: TextStyle(color: Colors.black),
                                  text: ordersDelivered[index]["price"].toString() + "  ",
                                ),
                                WidgetSpan(
                                  child: Icon(icon, size: 20),
                                ),
                              ],
                            ),
                          ),
                          RichText(
                            text: TextSpan(
                              children: [
                                WidgetSpan(
                                  child: Icon(FontAwesomeIcons.mapMarkerAlt, size: 20),
                                ),
                                TextSpan(
                                  style: TextStyle(color: Colors.black),
                                  text: geodesy.distanceBetweenTwoGeoPoints(l1, l2).round().toString(),
                                ),
                                TextSpan(
                                  style: TextStyle(color: Colors.black),
                                  text: " m",
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ))
              ],
            ),
          ),
    );
  }
  @override
  void initState() {
    _getData();
  }
}
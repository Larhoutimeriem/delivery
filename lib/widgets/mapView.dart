import 'package:flutter/material.dart';
import 'package:firebase/firebase.dart';
import 'package:google_maps/google_maps.dart' hide Icon;
import 'dart:html';
import 'dart:ui' as ui;
import 'package:delivery/utils/globals.dart' as globals;

class mapViewPage extends StatefulWidget {
  @override
  _mapViewPageState createState() => _mapViewPageState();
}

class _mapViewPageState extends State<mapViewPage> {

  Map<dynamic, dynamic> values = new Map();
  List _data = [{'location': {'adresse': 'ma position' ,'latitude': globals.lat, 'longitude': globals.lng}}];
  List orderPending = [];

  void _getData() async{

    Database db = database();
    DatabaseReference ref = db.ref('users');
    ref.onValue.listen((e) {
      DataSnapshot datasnapshot = e.snapshot;
      values = datasnapshot.val();
      if (!mounted) return;
      setState(() => 
        values.forEach((key, val) {
          val["key"] = key;
          _data.add(val);
        })
      );
    });
  }

  void attachSecretMessage(Marker marker, String secretMessage) {
    final infowindow = InfoWindow(InfoWindowOptions()..content = secretMessage);
    marker.onClick.listen((e) {
      infowindow.open(marker.map, marker);
    });
  }
  
  Widget getMap() {
    String htmlId = "7";
    ui.platformViewRegistry.registerViewFactory(htmlId, (int viewId) {

      final mapOptions = new MapOptions()
        ..zoom = 15
        ..center = new LatLng(48.813055, 2.38822);

      final elem = DivElement()
        ..id = htmlId
        ..style.width = "100%"
        ..style.height = "100%"
        ..style.border = 'none';

      final map = new GMap(elem, mapOptions);

      orderPending = _data.where((item) => item["status"] == "pending").toList();

      for (var i = 0; i< orderPending.length; i++) {
        final marker = Marker(MarkerOptions()
          ..position = LatLng(orderPending[i]['location']['latitude'], orderPending[i]['location']['longitude'])
          ..map = map
          ..title = orderPending[i]['location']['adresse']);
          attachSecretMessage(marker, orderPending[i]['location']['adresse']);
      }

      return elem;
    });

    return HtmlElementView(viewType: htmlId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: getMap(),
      ),
    );
  }  
  @override
  void initState() {
    _getData();
  }
}
import 'package:flutter/material.dart';
import 'package:firebase/firebase.dart';
import 'package:google_maps/google_maps.dart' hide Icon;
import 'dart:html';
import 'dart:ui' as ui;

class mapViewPage extends StatefulWidget {
  @override
  _mapViewPageState createState() => _mapViewPageState();
}

class _mapViewPageState extends State<mapViewPage> {

  Map<dynamic, dynamic> values = new Map();
  List _data = [];
  List<LatLng> latlngs = [LatLng(48.813055, 2.38822), LatLng(48.811325,2.3920731)];

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
  
  Widget getMap() {
    print(_data);
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

      for (LatLng point in latlngs) {
        Marker(MarkerOptions()
          ..position = point
          ..map = map);
      }

      return elem;
    });

    return HtmlElementView(viewType: htmlId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Map view'),
      ),
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
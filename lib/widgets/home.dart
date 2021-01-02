import 'package:flutter/material.dart';
import 'package:firebase/firebase.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  Map<dynamic, dynamic> values = new Map();
  List _data = [];

  void _getData() async{

    Database db = database();
    DatabaseReference ref = db.ref('users');

    ref.onValue.listen((e) {
      DataSnapshot datasnapshot = e.snapshot;
      values = datasnapshot.val();
      setState(() => 
        values.forEach((key, val) {
          _data.add(val);
        })
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Home'),
      ),
      body: new Container(
          padding: new EdgeInsets.all(32.0),
          child: new Center(
            child: new Column(
              children: <Widget>[
                new Text('Orders', style: new TextStyle(fontWeight: FontWeight.bold),),
                new Expanded(child: new ListView.builder(
                  itemCount: _data.length,
                  itemBuilder: (BuildContext context, int index){
                    return Card(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text("Nom: " + _data[index]["nom"]),
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

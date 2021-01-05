import 'package:flutter/material.dart';
import 'package:delivery/Widgets/ListOrders.dart';
import 'package:delivery/Widgets/mapView.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            bottom: TabBar(
              tabs: [
                Tab(text: "List view"),
                Tab(text: "Map view"),
              ],
            ),
            title: Text('Home'),
          ),
          body: TabBarView(
            children: [
              ListOrdersPage(),
              mapViewPage(),
            ],
          ),
        ),
      ),
    );  
  }  
}
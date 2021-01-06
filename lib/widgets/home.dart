import 'package:flutter/material.dart';
import 'package:delivery/Widgets/ListOrders.dart';
import 'package:delivery/Widgets/mapView.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            bottom: TabBar(
              tabs: <Widget>[
                Tab(icon: Icon(FontAwesomeIcons.list), text: "Liste commandes"),
                Tab(icon: Icon(FontAwesomeIcons.mapMarkedAlt), text: "Carte Map"),
              ],
            ),
            title: Text('Accueil'),
          ),
          body: TabBarView(
            children: [
              ListOrdersPage(),
              mapViewPage(),
            ],
          ),
        ),
    );  
  }  
}
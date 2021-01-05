import 'package:flutter/material.dart';
import 'package:delivery/Widgets/orderDelivered.dart';
import 'package:delivery/Widgets/orderPending.dart';

class ListOrdersPage extends StatefulWidget {
  @override
  _ListOrdersPageState createState() => _ListOrdersPageState();
}

class _ListOrdersPageState extends State<ListOrdersPage> {
    @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            bottom: TabBar(
              tabs: [
                Tab(text: "Order is pending"),
                Tab(text: "Order delivered"),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              orderPendigPage(),
              orderDeliveredPage(),
            ],
          ),
        ),
      ),
    );  
  }
}
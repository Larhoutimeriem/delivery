import 'package:flutter/material.dart';
import 'package:delivery/Widgets/orderDelivered.dart';
import 'package:delivery/Widgets/orderPending.dart';
import 'package:delivery/Widgets/orderCanceled.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ListOrdersPage extends StatefulWidget {
  @override
  _ListOrdersPageState createState() => _ListOrdersPageState();
}

class _ListOrdersPageState extends State<ListOrdersPage> with SingleTickerProviderStateMixin{
  TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          bottom: TabBar(
              unselectedLabelColor: Colors.blueAccent,
              indicatorSize: TabBarIndicatorSize.label,
              indicator: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: Colors.blueAccent),
              tabs: [
                Tab(
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        border: Border.all(color: Colors.blueAccent, width: 1)),
                    child: Align(
                      alignment: Alignment.center,
                      child: Text("En cours"),
                    ),
                  ),
                ),
                Tab(
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        border: Border.all(color: Colors.blueAccent, width: 1)),
                    child: Align(
                      alignment: Alignment.center,
                      child: Text("Livré"),
                    ),
                  ),
                ),
                Tab(
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        border: Border.all(color: Colors.blueAccent, width: 1)),
                    child: Align(
                      alignment: Alignment.center,
                      child: Text("Annulé"),
                    ),
                  ),
                ),
              ]),
        ),
        body: TabBarView(children: [
          orderPendigPage(),
          orderDeliveredPage(),
          orderCancelPage(),
        ]),
      )
    );  
  }
}
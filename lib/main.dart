import 'package:flutter/material.dart';
import 'Widgets/login.dart';
import 'dart:async';
import 'package:delivery/utils/locationJs.dart';
import 'package:js/js.dart';
import 'package:delivery/utils/authentication.dart';
import 'package:firebase/firebase.dart';
import 'package:delivery/utils/globals.dart' as globals;

void main() {
  Timer.periodic(new Duration(seconds: 10), (timer) {
    _setCurrentLocation();
  }); 
  runApp(MyApp());
}

success(pos) async{
  try {
    print(pos.coords.latitude);
    print(pos.coords.longitude);
    globals.lat = pos.coords.latitude;
    globals.lng = pos.coords.longitude;
    await getUser();
    print(uid);
    if (uid != null){
      Database db = database();
      DatabaseReference ref = db.ref('livreur/'+uid);
      ref.set({'longitude': pos.coords.longitude, 'latitude': pos.coords.latitude});
    }
  } catch (ex) {
      print("Exception thrown : " + ex.toString());
    }
}

_setCurrentLocation() {
  getCurrentPosition(allowInterop((pos) => success(pos)));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Forms Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginPage(),
    );
  }
}
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

  Future<void> main() async {
    final FirebaseApp app = await FirebaseApp.configure(
      name: 'opensesame-5fcab',
      options: const FirebaseOptions(
        googleAppID: '1:886232296258:ios:f2bf712232ab23b1',
        gcmSenderID: '886232296258',
        databaseURL: 'https://opensesame-5fcab.firebaseio.com',
    ));
    runApp(new MyApp(app: app));
  }

class MyApp extends StatelessWidget {

  MyApp({this.app});
  final FirebaseApp app;

  // @override
  // _MyAppState createState() => new _MyAppState();

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new MyHomePage(title: 'Sesam deschide!'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  static const platform = const MethodChannel('mypt.aeliptus.com/vision');
  int _counter = 0;
  String _faces = "Unknown";
  String name = "Alex";

  _MyHomePageState() {
  
    final _counterRef = FirebaseDatabase.instance.reference().child('observations');

    FirebaseDatabase.instance.reference().child('observations').once().then((DataSnapshot snapshot) {
      print('Connected to second database and read ${snapshot.value}');
    });


    FirebaseDatabase.instance.reference().child('observations').push().set(<String, String>{
      'ana': 'are mere'
    });


    _counterRef.keepSynced(true);
    print(_counterRef);
    final _counterSubscription = _counterRef.onValue.listen((Event event) {
      print('Got something plm');
      print(event.snapshot.value);
      setState(() {
        _counter = event.snapshot.value ?? 0;
      });
    }, onError: (Object o) {
      final DatabaseError error = o;
      setState(() {
      });
    });

  
    var facesChannel = MethodChannel("mypt.aeliptus.com/vision");
    facesChannel.setMethodCallHandler((MethodCall call) async {
      if (call.method == "faces") {
        var faces = call.arguments[0];
        setState(() {
          _faces = faces;
        });
        return;
      } else {
        throw PlatformException(code: "FlutterMethodNotImplemented");
      }
    });
  }

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
    this._getFaces().then((r) {
      print(this._faces);
    });
  }

  Future<Null> _getFaces() async {
    String faces;
    try {
      final String result = await platform.invokeMethod('faces', "abc");
      faces = result;
    } on PlatformException catch (e) {
      faces = "Unknown";
    }

    setState(() {
      _faces = faces;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: new Text(widget.title),
      ),
      body: new Center(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Icon(Icons.access_alarm, color: Colors.red),
            new Text('$_counter',
              style: Theme.of(context).textTheme.display1,
            ),
          ],
        ),
      ),
      floatingActionButton: new FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: new Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

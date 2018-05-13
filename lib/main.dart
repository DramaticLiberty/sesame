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
  var _observation = '';
  int _counter = 0;
  var _faces = [];
  double _refArea = 150.0 * 200.0;
  List<String> _devices = ['camera', 'audio', 'dashboard_light', 'door'];
  StreamSubscription<Event> _observationSubscription;
  DatabaseReference _counterRef;
  
  _MyHomePageState() {
  
    _counterRef = FirebaseDatabase.instance.reference().child('observations/name');

    _counterRef.once().then((DataSnapshot snapshot) {
      print('Connected to second database and read ${snapshot.value}');
    });
    _counterRef.keepSynced(true);

    _observationSubscription = _counterRef.onChildAdded.listen((Event event) {
      print('Got something plm');

      setState(() {
        this._observation = event.snapshot.value['sensor'] ?? '';
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
    var faces = [];
    double area, delta, w, h = 0.0;
    
    var firstObj = Map();

    try {
      var result = await platform.invokeMethod('faces', "abc");
      String _value = '';
      faces = result;
      firstObj = result[0];
      w = double.parse(firstObj['width']);
      h = double.parse(firstObj['height']);
      area = w * h;
      delta = area * 0.1;
     
    
      if ( _refArea < (area - delta) ) {
        switch (firstObj['key']) {
          case '41':
            //cup
            _value = 'cup';
            break;
          case '1':
            //bicicle
            _value = 'bicycle';
            break;
          case '56':
            //chair
            _value = 'chair';
            break;
          default:
        }

        
        FirebaseDatabase.instance.reference().child('observations/name').push().set({
          'sensor': _value
        });
      }
    } on PlatformException catch (e) {
      faces = [];
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
          children: _devices[0] == 'camera' ? <Widget>[
            new Icon(Icons.access_alarm, color: Colors.red),
            new Text('$_observation',
              style: Theme.of(context).textTheme.display1,
            ),
            new FloatingActionButton(
            onPressed: _incrementCounter,
            tooltip: 'Increment',
            child: new Icon(Icons.add),
          )
          ]
          : <Widget>[
            new Icon(Icons.access_alarm, color: Colors.red),
            new Text('$_observation',
              style: Theme.of(context).textTheme.display1,
            ),
        ]
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    ));
  }
}

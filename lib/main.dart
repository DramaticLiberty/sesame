import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
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
  var _faces = [];
  String name = "Alex";
  double _refArea = 150.0 * 200.0;
  

  

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
      faces = result;
      firstObj = result[0];
      w = double.parse(firstObj['width']);
      h = double.parse(firstObj['height']);
      area = w * h;
      delta = area * 0.1;
     
    
      if ( _refArea > (area - delta) ) {
        print('smaller');
      } else {
        print('bigger');
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

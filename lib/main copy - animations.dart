import 'package:flutter/material.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final appTitle = 'Opacity Demo';
    return new MaterialApp(
      title: appTitle,
      home: new MyHomePage(title: appTitle),
    );
  }
}

// The StatefulWidget's job is to take in some data and create a State class.
// In this case, our Widget takes in a title, and creates a _MyHomePageState.
class MyHomePage extends StatefulWidget {
  final String title;

  MyHomePage({Key key, this.title}) : super(key: key);

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

// The State class is responsible for two things: holding some data we can
// update and building the UI using that data.
class _MyHomePageState extends State<MyHomePage> with SingleTickerProviderStateMixin {

  AnimationController _opacityController;
  Animation<double> _opacity;

  bool _showHint = false;

  @override
   void initState() {
     super.initState();
    
     _opacityController = new AnimationController(vsync: this,duration: const Duration(milliseconds: 800));
     _opacity = new CurvedAnimation(parent: _opacityController, curve: Curves.easeInOut)..addStatusListener((status) {
       if (status == AnimationStatus.completed) {
         _opacityController.reverse();
       } else if (status == AnimationStatus.dismissed) {
         _opacityController.forward();
       }
     });
     _opacityController.forward();
  }
  
  @override
  void dispose() {
    super.dispose();
  
    _opacityController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return  new Container(
        child: new Scaffold(
          appBar: new AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: new Text(widget.title),
        ),
          //alignment: Alignment.center,
      
          body: new Center( 
            child: new Column(
            mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
              new FadeTransition(
                opacity: _opacity,
                child: new Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    new Icon(Icons.warning,
                    size: 100.0),
                    new Padding(padding: const EdgeInsets.only(left: 8.0)),
                    new Text("Warning!!!",
                      style: new TextStyle(
                          fontSize: 64.0,
                          color: Colors.blueGrey,
                      ),
                    )
                  ],
                ),
              ),
              new FadeTransition(
                opacity: _opacity,
                child: new Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    new Icon(Icons.arrow_forward,
                    size: 100.0),
                    new Padding(padding: const EdgeInsets.only(left: 8.0)),
                    new Text("Avoid!!!",
                      style: new TextStyle(
                          fontSize: 64.0,
                          color: Colors.blueGrey,
                      ),
                    )
                  ],
                ),
              )
          ]
      )
    ))
    );
    }
}
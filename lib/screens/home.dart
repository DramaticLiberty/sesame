import 'package:flutter/material.dart';
import 'dart:async';
import '../services/firebaseService.dart';
import '../services/detectionService.dart';
import 'sensors.dart';
import 'receiver.dart';

class HomePage extends StatefulWidget {

  final FirebaseAgent fireAgent;

  final String title;

  HomePage({Key key, this.title, this.fireAgent}) : super(key: key);

  @override
  _HomePageState createState() => new _HomePageState(fireAgent);
}

class _HomePageState extends State<HomePage> {

  StreamSubscription _observationSubscription;
  String _perils;
  List<String> _devices = ['camera', 'audio', 'dashboard_light', 'door'];
  VoidCallback _startCamera;

  _HomePageState(fireAgent) {
    final String ENDPOINT_NAME = 'observations/name';
    final String SUBSCRIPTION_TYPE = 'sensor';
    fireAgent().init().then(() {
      fireAgent.connect(ENDPOINT_NAME, true);
          _observationSubscription = fireAgent.subscribeToValues(SUBSCRIPTION_TYPE);
          
          _observationSubscription.onData((data) {
              setState(() {
                this._perils = data;
              });
            }
          );
    });
    

    void _startCamera() {
      PerilDetector().detect().then(
        (data) {
          fireAgent.saveData(data, ENDPOINT_NAME);
          setState((){
            this._perils = data;
          });
        }
      ).catchError((err) => print(err));
    } 
  }

  

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        child: 
          _devices[2] == 'camera' ? CameraWidget(
            onPressedButton: () {
              _startCamera();
            }
          ) : SensorsWidget(
            sensorType: _devices[2],
            active: true,
            value: _perils
          )
      )
    );
  }
}

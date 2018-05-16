import 'dart:async';
import './nativeService.dart';
import 'package:flutter/services.dart';

class PerilDetector {
  
  final String NATIVE_CHANNEL = 'mypt.aeliptus.com/vision';

  Future<Object> detect() async {
    var _obstacles = [], _obstacleObj = Map();
    double _area, _delta, _w, _h, _refArea;
    String _methodName = 'faces', _params = 'abc';    
    _refArea = 150.0 * 200.0;

    try {
      final NativeService nativeService = NativeService();
      nativeService.openChannel(NATIVE_CHANNEL);

      _obstacles = await nativeService.callMethod(_methodName, _params);
      _obstacleObj = _obstacles[0];
      _w = double.parse(_obstacleObj['width']);
      _h = double.parse(_obstacleObj['height']);
      _area = _w * _h;
      _delta = _area * 0.1;

      if ( _refArea < (_area - _delta) ) {
        switch (_obstacleObj['key']) {
          case '41':
            //cup
            _obstacleObj['value'] = 'cup';
            break;
          case '1':
            //bicicle
            _obstacleObj['value']= 'bicycle';
            break;
          case '56':
            //chair
            _obstacleObj['value'] = 'chair';
            break;
          default:
            break;
        }
        return _obstacleObj['value'];
      } 
    } on PlatformException catch (e) {
      print(e);
      _obstacleObj = {};
    }
  }
}
    
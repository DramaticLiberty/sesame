import 'package:flutter/services.dart';
import 'dart:async';

class NativeService {
  var channel;
  void openChannel(name) {
    channel = MethodChannel(name);
    channel.setMethodCallHandler((MethodCall call) async {
      if (call.method == "faces") {
        var faces = call.arguments[0];
        //maybe call set state here
        return;
      } else {
        throw PlatformException(code: "FlutterMethodNotImplemented");
      }
    });
  }
  Future<dynamic> callMethod(_methodName, params) {
    return channel.invokeMethod(_methodName, params);
  }
}
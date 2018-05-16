import 'package:flutter/material.dart';

class LockSensor extends StatelessWidget {
  LockSensor({
    this.active,
    this.value
  });

  final bool active;
  final String value;

  @override
  Widget build(BuildContext context) {
    return 
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: 
          <Widget>[
             Icon(Icons.lock, color: (!active) ? Colors.grey : Colors.red, size: 120.0),
             Text('$value', style: Theme.of(context).textTheme.display1)
        ] 
      );
  }
}
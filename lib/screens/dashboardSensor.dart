import 'package:flutter/material.dart';

class DashboardSensor extends StatelessWidget {
  DashboardSensor({
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
            Icon(Icons.warning, color: (!active) ? Colors.grey : Colors.yellow, size: 120.0),
            Text('$value', style: Theme.of(context).textTheme.display1 )
          ]
      );
  }
}
import 'package:flutter/material.dart';

class CameraWidget extends StatelessWidget {
  CameraWidget({
    this.onPressedButton,
  });
  final VoidCallback onPressedButton;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: 
        <Widget>[
            Text(
              'START DETECTION',
              style: Theme.of(context).textTheme.display1,
            ),
            FloatingActionButton(
              onPressed: onPressedButton,
              tooltip: 'Increment',
              child:  Icon(Icons.add),
            )
          ]
        );
  }
}
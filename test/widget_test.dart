// This is a basic Flutter widget test.
// To perform an interaction with a widget in your test, use the WidgetTester utility that Flutter
// provides. For example, you can send tap and scroll gestures. You can also use WidgetTester to
// find child widgets in the widget tree, read text, and verify that the values of widget properties
// are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';

import 'package:mypt/main.dart';


class MyClientRequests {
  var body = "";
  var code = 200;

  setNext(int code, String body) {
    this.code = code;
    this.body = body;
  }

  setCompanies() {
    this.setNext(200, '[{"company_name": "CornerMarkt", "company_uuid": "eb70dfec-12c3-11e6-b73f-f72d4c3d66db"}]');
  }

  setVersion() {
    this.setNext(200, '{"status": "success", "version": "0.19.20"}');
  }

  Future<Response> next(Request request) async {
    return Response(this.body, this.code);
  }
}

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(new MyApp());

    // Verify that our counter starts at 0.
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    // Tap the '+' icon and trigger a frame.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // Verify that our counter has incremented.
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });
}

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:invenbill/app.dart'; // FIXED: import the correct file

void main() {
  testWidgets('App starts smoke test', (WidgetTester tester) async {
    // Build the InvenBill app and trigger a frame.
    await tester.pumpWidget(const InvenBillApp());

    // Since your app starts with the LoginScreen, check for the presence of a login-related widget.
    expect(find.text('InvenBill Login'), findsOneWidget);
    expect(find.byType(TextFormField), findsNWidgets(2));
  });
}

import 'dart:convert';

import 'package:attention_project/account.dart';
import 'package:attention_project/account_panel.dart';
import 'package:attention_project/settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Decodes the subject and body of a message made by [Account.rescueEmail].
({String to, String subject, String body}) _read(String raw) {
  final parts = raw.split('\r\n\r\n');
  final headers = parts.first.split('\r\n');
  String header(String name) => headers.firstWhere((h) => h.startsWith('$name: ')).substring(name.length + 2);
  final subject = RegExp(r'^=\?UTF-8\?B\?(.*)\?=$').firstMatch(header('Subject'))![1]!;
  return (
    to: header('To'),
    subject: utf8.decode(base64.decode(subject)),
    body: utf8.decode(base64.decode(parts[1])),
  );
}

void main() {
  test('the unlock email carries the code to the signed-in address', () async {
    SharedPreferences.setMockInitialValues({});
    await AppSettings.instance.load();
    final mail = _read(Account.rescueEmail(to: 'me@gmail.com', code: '12345678'));
    expect(mail.to, 'me@gmail.com');
    expect(mail.subject, 'Your Sati unlock code: 12345678');
    expect(mail.body, contains('\n\n12345678\n\n'));
    expect(mail.body, contains('30 minutes'));
  });

  test('in Thai, the unlock email survives the trip through base64', () async {
    SharedPreferences.setMockInitialValues({'app_language': 'th'});
    await AppSettings.instance.load();
    final mail = _read(Account.rescueEmail(to: 'me@gmail.com', code: '87654321'));
    expect(mail.subject, 'รหัสปลดล็อก Sati ของคุณ: 87654321');
    expect(mail.body, contains('ใช้ได้ 30 นาที'));
    SharedPreferences.setMockInitialValues({});
    await AppSettings.instance.load();
  });

  test('without Firebase (as in tests), the account is simply unavailable', () {
    expect(Account.instance.available, isFalse);
    expect(Account.instance.signedIn, isFalse);
  });

  testWidgets('the email dialog switches to "create account" and checks the passwords match', (tester) async {
    SharedPreferences.setMockInitialValues({});
    await AppSettings.instance.load();
    await tester.pumpWidget(const MaterialApp(home: Scaffold(body: EmailSignInDialog())));
    expect(find.text('Sign in with email'), findsOneWidget);
    expect(find.text('Confirm password'), findsNothing);

    await tester.tap(find.text('New here? Create an account'));
    await tester.pump();
    expect(find.text('Create an account'), findsOneWidget);
    await tester.enterText(find.widgetWithText(TextField, 'Email'), 'me@example.com');
    await tester.enterText(find.widgetWithText(TextField, 'Password'), 'secret1');
    await tester.enterText(find.widgetWithText(TextField, 'Confirm password'), 'secret2');
    await tester.tap(find.text('Create account'));
    await tester.pump();
    expect(find.text("The passwords don't match."), findsOneWidget);
  });
}

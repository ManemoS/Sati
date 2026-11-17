import 'dart:convert';

import 'package:attention_project/ai_settings.dart';
import 'package:attention_project/backup.dart';
import 'package:attention_project/cloud_ai.dart';
import 'package:attention_project/settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Sets up the online AI as [prefs] say, then summarizes with every request answered by [reply].
Future<String> _summarize(
  Map<String, Object> prefs,
  Future<http.Response> Function(http.Request request) reply,
) async {
  SharedPreferences.setMockInitialValues({'notes_engine': 'cloud', ...prefs});
  await AppSettings.instance.load();
  return http.runWithClient(() => CloudAi.summarize('the lecture'), () => MockClient(reply));
}

http.Response _json(Object body, [int status = 200]) =>
    http.Response.bytes(utf8.encode(jsonEncode(body)), status, headers: {'content-type': 'application/json'});

void main() {
  test('a phone set up before other services keeps using Claude and its saved key', () async {
    SharedPreferences.setMockInitialValues({'notes_engine': 'claude', 'claude_api_key': 'sk-ant-old'});
    await AppSettings.instance.load();
    expect(AppSettings.instance.notesEngine, 'cloud');
    expect(CloudAi.current, CloudProvider.claude);
    expect(await CloudAi.apiKey(CloudProvider.claude), 'sk-ant-old');
  });

  test('Claude', () async {
    late http.Request sent;
    final notes = await _summarize({'cloud_provider': 'claude', 'claude_api_key': 'k'}, (r) async {
      sent = r;
      return _json({
        'stop_reason': 'end_turn',
        'content': [
          {'type': 'text', 'text': 'Topic: cells'},
        ],
      });
    });
    expect(notes, 'Topic: cells');
    expect(sent.url.toString(), 'https://api.anthropic.com/v1/messages');
    expect(sent.headers['x-api-key'], 'k');
    expect(jsonDecode(sent.body)['model'], CloudProvider.claude.defaultModel);
  });

  test('ChatGPT, with a model the user picked', () async {
    late http.Request sent;
    final notes = await _summarize(
      {'cloud_provider': 'openai', 'openai_api_key': 'sk-1', 'openai_model': 'gpt-x'},
      (r) async {
        sent = r;
        return _json({
          'choices': [
            {'finish_reason': 'stop', 'message': {'role': 'assistant', 'content': ' Topic: แมว '}},
          ],
        });
      },
    );
    expect(notes, 'Topic: แมว');
    expect(sent.url.toString(), 'https://api.openai.com/v1/chat/completions');
    expect(sent.headers['authorization'], 'Bearer sk-1');
    expect(jsonDecode(sent.body)['model'], 'gpt-x');
  });

  test('Gemini', () async {
    late http.Request sent;
    final notes = await _summarize({'cloud_provider': 'gemini', 'gemini_api_key': 'AIza1'}, (r) async {
      sent = r;
      return _json({
        'candidates': [
          {
            'finishReason': 'STOP',
            'content': {
              'parts': [
                {'text': 'thinking…', 'thought': true},
                {'text': 'Topic: '},
                {'text': 'stars'},
              ],
            },
          },
        ],
      });
    });
    expect(notes, 'Topic: stars');
    expect(sent.url.path, '/v1beta/models/gemini-flash-latest:generateContent');
    expect(sent.headers['x-goog-api-key'], 'AIza1');
  });

  test('Other service: own address, no key needed', () async {
    late http.Request sent;
    final notes = await _summarize(
      {'cloud_provider': 'custom', 'custom_base_url': 'http://192.168.1.5:11434/v1/', 'custom_model': 'llama3'},
      (r) async {
        sent = r;
        return _json({
          'choices': [
            {'message': {'content': 'Topic: maps'}},
          ],
        });
      },
    );
    expect(notes, 'Topic: maps');
    expect(sent.url.toString(), 'http://192.168.1.5:11434/v1/chat/completions');
    expect(sent.headers.containsKey('authorization'), isFalse);
  });

  test('errors read the same for every service', () async {
    Future<String> errorFor(Map<String, Object> prefs, http.Response response) async {
      try {
        await _summarize(prefs, (_) async => response);
      } on SummaryException catch (e) {
        return e.message;
      }
      throw TestFailure('expected a SummaryException');
    }

    const gemini = {'cloud_provider': 'gemini', 'gemini_api_key': 'bad'};
    expect(
      await errorFor(gemini, _json({'error': {'code': 400, 'message': 'API key not valid. Please pass a valid API key.'}}, 400)),
      'Your Gemini API key is not valid. Check it in Settings → Notes AI.',
    );
    const openai = {'cloud_provider': 'openai', 'openai_api_key': 'k', 'openai_model': 'nope'};
    expect(
      await errorFor(openai, _json({'error': {'message': 'The model `nope` does not exist'}}, 404)),
      'The model "nope" was not found. Change it in Settings → Notes AI.',
    );
    expect(
      await errorFor(openai, _json({'choices': [{'finish_reason': 'content_filter', 'message': {'content': ''}}]})),
      'ChatGPT declined to summarize this recording.',
    );
    expect(
      await errorFor({'cloud_provider': 'openai'}, _json({})),
      'Add your ChatGPT API key first.',
    );
  });

  test('no API key ever goes into a backup', () async {
    SharedPreferences.setMockInitialValues({
      'cloud_provider': 'gemini',
      'claude_api_key': 'a',
      'openai_api_key': 'b',
      'gemini_api_key': 'c',
      'custom_api_key': 'd',
      'custom_base_url': 'https://openrouter.ai/api/v1',
    });
    final keys = (jsonDecode(await AppBackup.settingsJson()) as Map).keys;
    expect(keys.where((k) => k.endsWith('_api_key')), isEmpty);
    expect(keys, containsAll(['cloud_provider', 'custom_base_url']));
  });

  testWidgets('the key dialog saves, and closes cleanly on Cancel', (tester) async {
    SharedPreferences.setMockInitialValues({});
    await AppSettings.instance.load();
    bool? ready;
    await tester.pumpWidget(MaterialApp(
      home: Builder(
        builder: (context) => TextButton(
          onPressed: () async => ready = await showCloudAiDialog(context, CloudProvider.gemini),
          child: const Text('open'),
        ),
      ),
    ));

    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
    expect(find.text('Gemini API key'), findsOneWidget);
    expect(find.text('gemini-flash-latest'), findsWidgets);
    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();
    expect(ready, isFalse);

    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField).first, '  AIza-test  ');
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();
    expect(ready, isTrue);
    expect(await CloudAi.apiKey(CloudProvider.gemini), 'AIza-test');
    final prefs = await SharedPreferences.getInstance();
    expect(prefs.containsKey('gemini_model'), isFalse, reason: 'the default model is not pinned');
  });
}

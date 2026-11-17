import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'settings.dart';
import 'l10n.dart';

class SummaryException implements Exception {
  const SummaryException(this.message);
  final String message;

  @override
  String toString() => message;
}

/// An online AI service that can write lecture notes with the user's own API key.
enum CloudProvider {
  claude(
    label: 'Claude',
    company: 'Anthropic',
    defaultModel: 'claude-opus-5-5',
    keyHint: 'sk-ant-...',
    keyHelp: 'Create a key at console.anthropic.com under "API keys", then paste it here. It stays on this phone.',
  ),
  openai(
    label: 'ChatGPT',
    company: 'OpenAI',
    defaultModel: 'gpt-5-mini',
    keyHint: 'sk-...',
    keyHelp: 'Create a key at platform.openai.com under "API keys", then paste it here. It stays on this phone.',
  ),
  gemini(
    label: 'Gemini',
    company: 'Google',
    // An alias Google keeps pointed at its newest Flash model.
    defaultModel: 'gemini-flash-latest',
    keyHint: 'AIza...',
    keyHelp: 'Create a key at aistudio.google.com under "Get API key", then paste it here. It stays on this phone.',
  ),

  /// Anything that speaks the OpenAI chat format: OpenRouter, Groq, DeepSeek, Mistral, a laptop
  /// running Ollama or LM Studio…
  custom(
    label: 'Other',
    company: '',
    defaultModel: '',
    keyHint: '',
    keyHelp: 'Any service that works with the OpenAI API, such as OpenRouter, Groq, DeepSeek or Ollama. '
        'Enter its address, model and key. They stay on this phone.',
  );

  const CloudProvider({
    required this.label,
    required this.company,
    required this.defaultModel,
    required this.keyHint,
    required this.keyHelp,
  });

  final String label;
  final String company;
  final String defaultModel;
  final String keyHint;
  final String keyHelp;

  /// The name to show. "Other" is translated; product names are not.
  String get displayName => this == custom ? label.tr : label;

  /// Kept as 'claude_api_key' for Claude so keys saved before other services existed still work.
  /// Every key ends in '_api_key', which backups leave out.
  String get keyPref => '${name}_api_key';
  String get modelPref => '${name}_model';

  static CloudProvider fromName(String? value) => CloudProvider.values.asNameMap()[value] ?? claude;
}

/// Writes lecture notes with whichever online AI the user picked in Settings.
class CloudAi {
  static const _baseUrlPref = 'custom_base_url';

  static CloudProvider get current => CloudProvider.fromName(AppSettings.instance.cloudProvider);

  static Future<String?> _get(String key) async {
    final value = (await SharedPreferences.getInstance()).getString(key)?.trim();
    return value == null || value.isEmpty ? null : value;
  }

  static Future<void> _set(String key, String value) async {
    final prefs = await SharedPreferences.getInstance();
    value.trim().isEmpty ? await prefs.remove(key) : await prefs.setString(key, value.trim());
  }

  static Future<String?> apiKey(CloudProvider p) => _get(p.keyPref);
  static Future<void> setApiKey(CloudProvider p, String key) => _set(p.keyPref, key);

  /// The model to ask, or the provider's default if the user hasn't changed it.
  static Future<String> model(CloudProvider p) async => await _get(p.modelPref) ?? p.defaultModel;
  static Future<void> setModel(CloudProvider p, String model) => _set(p.modelPref, model);

  /// The address of an "Other" service, such as https://openrouter.ai/api/v1.
  static Future<String?> baseUrl() => _get(_baseUrlPref);
  static Future<void> setBaseUrl(String url) => _set(_baseUrlPref, url);

  /// Whether [p] has everything it needs to be asked. A local service (Ollama) needs no key.
  static Future<bool> isReady(CloudProvider p) async => p == CloudProvider.custom
      ? await baseUrl() != null && (await model(p)).isNotEmpty
      : await apiKey(p) != null;

  /// Turns a lecture transcript into study notes. Throws [SummaryException] with a message
  /// that can be shown to the user.
  static Future<String> summarize(String transcript) async {
    final p = current;
    final args = {'name': p.displayName};
    final key = await apiKey(p);
    final model = await CloudAi.model(p);
    if (p == CloudProvider.custom) {
      if (await baseUrl() == null || model.isEmpty) {
        throw SummaryException('Set up the online AI in Settings → Notes AI first.'.tr);
      }
    } else if (key == null) {
      throw SummaryException('Add your {name} API key first.'.trf(args));
    }

    final request = switch (p) {
      CloudProvider.claude => _claude(key!, model, transcript),
      CloudProvider.gemini => _gemini(key!, model, transcript),
      CloudProvider.openai => _openAi('https://api.openai.com/v1', key, model, transcript),
      CloudProvider.custom => _openAi((await baseUrl())!, key, model, transcript),
    };

    final http.Response response;
    try {
      response = await http
          .post(request.url, headers: {'content-type': 'application/json', ...request.headers}, body: jsonEncode(request.body))
          .timeout(const Duration(minutes: 5));
    } on SocketException {
      throw SummaryException('No internet connection. Connect and try again.'.tr);
    } on http.ClientException {
      throw SummaryException('No internet connection. Connect and try again.'.tr);
    } on TimeoutException {
      throw SummaryException('{name} took too long to answer. Try again.'.trf(args));
    }

    // Decode as UTF-8 explicitly so non-English lectures come through intact.
    final Map<String, dynamic> body;
    try {
      body = jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;
    } on FormatException {
      throw SummaryException('{name} returned an error ({code}). Try again.'.trf({...args, 'code': response.statusCode}));
    }

    if (response.statusCode != 200) {
      final error = body['error'];
      final message = error is Map ? error['message'] as String? : error as String?;
      // Gemini answers a wrong key with 400 rather than 401.
      final badKey = response.statusCode == 401 ||
          response.statusCode == 403 ||
          (message?.toLowerCase().contains('api key') ?? false);
      throw SummaryException(switch (response.statusCode) {
        _ when badKey => 'Your {name} API key is not valid. Check it in Settings → Notes AI.'.trf(args),
        404 => 'The model "{model}" was not found. Change it in Settings → Notes AI.'.trf({'model': model}),
        429 => 'Too many requests. Wait a minute and try again.'.tr,
        >= 500 => '{name} is busy right now. Try again in a minute.'.trf(args),
        _ => message ?? '{name} returned an error ({code}). Try again.'.trf({...args, 'code': response.statusCode}),
      });
    }

    final summary = request.read(body);
    if (summary == null) throw SummaryException('{name} declined to summarize this recording.'.trf(args));
    if (summary.isEmpty) throw SummaryException('{name} returned an empty summary. Try again.'.trf(args));
    return summary;
  }

  static const _system = 'You turn lecture transcripts into study notes for a university student '
      'who wants to know what the professor said.';

  static _Request _claude(String key, String model, String transcript) => _Request(
        Uri.parse('https://api.anthropic.com/v1/messages'),
        headers: {
          'x-api-key': key,
          'anthropic-version': '2023-06-01',
          // If Claude's safety check wrongly declines, retry on another model instead of failing.
          'anthropic-beta': 'server-side-fallback-2026-07-01',
        },
        body: {
          'model': model,
          'max_tokens': 16000,
          'output_config': {'effort': 'medium'},
          'fallbacks': 'default',
          'system': _system,
          'messages': [
            {'role': 'user', 'content': _prompt(transcript)},
          ],
        },
        read: (body) {
          if (body['stop_reason'] == 'refusal') return null;
          return [
            for (final block in body['content'] as List)
              if (block['type'] == 'text') block['text'] as String,
          ].join().trim();
        },
      );

  static _Request _gemini(String key, String model, String transcript) => _Request(
        Uri.parse('https://generativelanguage.googleapis.com/v1beta/models/${Uri.encodeComponent(model)}:generateContent'),
        headers: {'x-goog-api-key': key},
        body: {
          'systemInstruction': {
            'parts': [
              {'text': _system},
            ],
          },
          'contents': [
            {
              'role': 'user',
              'parts': [
                {'text': _prompt(transcript)},
              ],
            },
          ],
        },
        read: (body) {
          if ((body['promptFeedback'] as Map?)?['blockReason'] != null) return null;
          final candidates = body['candidates'] as List? ?? const [];
          if (candidates.isEmpty) return null;
          final candidate = candidates.first as Map<String, dynamic>;
          if (const {'SAFETY', 'PROHIBITED_CONTENT', 'BLOCKLIST', 'SPII'}.contains(candidate['finishReason'])) {
            return null;
          }
          final parts = (candidate['content'] as Map?)?['parts'] as List? ?? const [];
          return [
            for (final part in parts)
              if (part['thought'] != true && part['text'] is String) part['text'] as String,
          ].join().trim();
        },
      );

  static _Request _openAi(String baseUrl, String? key, String model, String transcript) {
    final base = baseUrl.endsWith('/') ? baseUrl.substring(0, baseUrl.length - 1) : baseUrl;
    return _Request(
      Uri.parse(base.endsWith('/chat/completions') ? base : '$base/chat/completions'),
      headers: {if (key != null) 'authorization': 'Bearer $key'},
      body: {
        'model': model,
        'messages': [
          {'role': 'system', 'content': _system},
          {'role': 'user', 'content': _prompt(transcript)},
        ],
      },
      read: (body) {
        final choices = body['choices'] as List? ?? const [];
        if (choices.isEmpty) return '';
        final choice = choices.first as Map<String, dynamic>;
        final message = choice['message'] as Map<String, dynamic>? ?? const {};
        if (choice['finish_reason'] == 'content_filter' || message['refusal'] != null) return null;
        return (message['content'] as String? ?? '').trim();
      },
    );
  }

  static String _prompt(String transcript) => '''
Below is a transcript of a lecture, written down automatically by a phone's speech recognition from somewhere in the lecture room. Expect recognition mistakes, missing words, no punctuation, and occasional speech from other people in the room. Work out what the professor most likely meant, and leave out anything that clearly isn't part of the lecture.

<transcript>
$transcript
</transcript>

Write study notes in the same language the lecture was given in, with these parts:
- Topic: one or two sentences on what the lecture was about.
- Key points: the main ideas, in the order they were taught, each explained in a sentence or two.
- Terms and definitions: important terms the professor introduced.
- Announcements: anything about exams, homework, deadlines or what to prepare.
- Unclear parts: places where the recording was too garbled to follow, so the student knows to check them.

Use plain text that reads well on a phone: put each part's name on its own line and use "- " for bullets. Don't use Markdown symbols such as # or **. Leave out a part if there's nothing for it. If the transcript is too short or garbled to summarize, say so in a sentence instead.''';
}

/// One HTTP call to a provider, and how to pull the notes out of its answer.
class _Request {
  const _Request(this.url, {required this.headers, required this.body, required this.read});

  final Uri url;
  final Map<String, String> headers;
  final Map<String, Object> body;

  /// The notes, '' if the answer was empty, or null if the provider declined.
  final String? Function(Map<String, dynamic> body) read;
}

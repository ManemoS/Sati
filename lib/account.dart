import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;

import 'app_lock.dart';
import 'firebase_options.dart';
import 'l10n.dart';

class AccountException implements Exception {
  const AccountException(this.message);
  final String message;

  @override
  String toString() => message;
}

/// The user's Google account, used to share locks between their devices (LockSync.kt) and to
/// email them an unlock code from their own Gmail.
class Account extends ChangeNotifier {
  Account._();
  static final instance = Account._();

  static const _gmailScope = 'https://www.googleapis.com/auth/gmail.send';

  /// OAuth client type 3 in android/app/google-services.json. Update both together.
  static const _webClientId = '690407444897-ipp4bl2dvs851rtfpdg2knbu5odh5eau.apps.googleusercontent.com';

  /// False until Firebase has started, and always in tests.
  bool available = false;
  User? _user;

  bool get signedIn => _user != null;
  String? get email => _user?.email;

  /// The emailed unlock code is sent from the user's own Gmail, so it needs a Google sign-in.
  bool get canEmailCode => _user?.providerData.any((p) => p.providerId == 'google.com') ?? false;

  Future<void> init() async {
    try {
      await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
      // The Web client from google-services.json. Android's Credential Manager needs it to issue
      // an ID token Firebase accepts; passed explicitly in case the generated resource is missing.
      await GoogleSignIn.instance.initialize(serverClientId: _webClientId);
      _user = FirebaseAuth.instance.currentUser;
      FirebaseAuth.instance.authStateChanges().listen((user) {
        _user = user;
        notifyListeners();
      });
      available = true;
      notifyListeners();
    } catch (e) {
      debugPrint('Account unavailable: $e');
    }
  }

  /// Shows Google's account picker. Returns false if the user backed out.
  Future<bool> signIn() async {
    try {
      final google = await GoogleSignIn.instance.authenticate();
      final idToken = google.authentication.idToken;
      if (idToken == null) throw AccountException('Google didn\'t sign you in. Try again.'.tr);
      await FirebaseAuth.instance.signInWithCredential(GoogleAuthProvider.credential(idToken: idToken));
      return true;
    } on GoogleSignInException catch (e) {
      debugPrint('Google sign-in failed: ${e.code} ${e.description} ${e.details}');
      final detail = e.description ?? '';
      // Credential Manager also reports setup problems as "canceled", e.g. "[16] Account reauth
      // failed" when the app's SHA-1 or OAuth consent screen is wrong. Only a real back-out is quiet.
      final setupProblem = detail.contains('[16]') || detail.toLowerCase().contains('reauth');
      if ((e.code == GoogleSignInExceptionCode.canceled || e.code == GoogleSignInExceptionCode.interrupted) &&
          !setupProblem) {
        return false;
      }
      if (detail.startsWith('No credential available')) {
        throw AccountException('Add a Google account to this phone (Settings > Accounts), then try again.'.tr);
      }
      throw AccountException(
          'Couldn\'t sign in with Google ({code}).'.trf({'code': detail.isEmpty ? e.code.name : detail}));
    } on FirebaseAuthException catch (e) {
      debugPrint('Firebase Google sign-in failed: ${e.code} ${e.message}');
      throw AccountException(e.code == 'network-request-failed'
          ? 'No internet connection. Connect and try again.'.tr
          : 'Couldn\'t sign in with Google ({code}).'.trf({'code': e.message ?? e.code}));
    } on AccountException {
      rethrow;
    } catch (e) {
      // Anything else (a PlatformException from a missing plugin class, say) used to vanish
      // without a word; show it so the button never just does nothing.
      debugPrint('Google sign-in error: $e');
      throw AccountException('Couldn\'t sign in with Google ({code}).'.trf({'code': '$e'}));
    }
  }

  /// Makes a new account with an email address and password, and signs in to it.
  Future<void> register(String email, String password) =>
      _emailAuth(() => FirebaseAuth.instance.createUserWithEmailAndPassword(email: email.trim(), password: password));

  Future<void> signInWithEmail(String email, String password) =>
      _emailAuth(() => FirebaseAuth.instance.signInWithEmailAndPassword(email: email.trim(), password: password));

  /// Firebase emails a link for choosing a new password.
  Future<void> sendPasswordReset(String email) =>
      _emailAuth(() => FirebaseAuth.instance.sendPasswordResetEmail(email: email.trim()));

  Future<void> _emailAuth(Future<Object?> Function() action) async {
    try {
      await action();
    } on FirebaseAuthException catch (e) {
      throw AccountException(switch (e.code) {
        'invalid-email' => "That email address doesn't look right.".tr,
        'email-already-in-use' => "There's already an account with this email. Sign in instead.".tr,
        'weak-password' => 'Choose a password of at least 6 characters.'.tr,
        'invalid-credential' || 'wrong-password' || 'user-not-found' => 'Wrong email or password.'.tr,
        'too-many-requests' => 'Too many tries. Wait a few minutes and try again.'.tr,
        'network-request-failed' => 'No internet connection. Connect and try again.'.tr,
        'operation-not-allowed' => "Email sign-in isn't switched on for this app yet.".tr,
        _ => "Couldn't sign in ({code}).".trf({'code': e.code}),
      });
    }
  }

  /// Signing out leaves any running lock on this device as it is.
  Future<void> signOut() async {
    await GoogleSignIn.instance.signOut();
    await FirebaseAuth.instance.signOut();
  }

  /// Makes a one-time unlock code for the running lock and emails it to the user from their
  /// own Gmail. Asks for permission to send email the first time.
  Future<void> emailUnlockCode() async {
    final to = email;
    if (to == null || !canEmailCode) throw AccountException('Sign in with Google in Settings first.'.tr);

    final String token;
    try {
      // The account picker only shows if Google has forgotten which account this is.
      var google = await GoogleSignIn.instance.attemptLightweightAuthentication();
      google ??= await GoogleSignIn.instance.authenticate();
      if (google.email.toLowerCase() != to.toLowerCase()) {
        throw AccountException('Pick {email}, the account this app is signed in with.'.trf({'email': to}));
      }
      token = (await google.authorizationClient.authorizeScopes([_gmailScope])).accessToken;
    } on GoogleSignInException catch (e) {
      throw AccountException(e.code == GoogleSignInExceptionCode.canceled
          ? 'The app needs permission to send the email. Try again and allow it.'.tr
          : 'Couldn\'t get permission to send email ({code}).'.trf({'code': e.code.name}));
    }

    final code = await AppLock.newRescueCode();
    if (code == null) throw AccountException('No lock is running.'.tr);

    final http.Response response;
    try {
      response = await http
          .post(
            Uri.parse('https://gmail.googleapis.com/gmail/v1/users/me/messages/send'),
            headers: {'authorization': 'Bearer $token', 'content-type': 'application/json'},
            body: jsonEncode({'raw': base64Url.encode(utf8.encode(rescueEmail(to: to, code: code)))}),
          )
          .timeout(const Duration(seconds: 30));
    } on SocketException {
      throw AccountException('No internet connection. Connect and try again.'.tr);
    } on http.ClientException {
      throw AccountException('No internet connection. Connect and try again.'.tr);
    } on TimeoutException {
      throw AccountException('Gmail took too long to answer. Try again.'.tr);
    }
    if (response.statusCode == 401) {
      // A stale token; the next try fetches a fresh one.
      await GoogleSignIn.instance.authorizationClient.clearAuthorizationToken(accessToken: token);
    }
    if (response.statusCode != 200) {
      debugPrint('Gmail send failed: ${response.statusCode} ${response.body}');
      throw AccountException(response.statusCode == 403
          ? 'Gmail refused to send the email. The Gmail API may be switched off for this app.'.tr
          : 'Gmail couldn\'t send the email ({code}). Try again.'.trf({'code': response.statusCode}));
    }
  }

  /// The unlock-code email as a raw message for the Gmail API, in the app's language.
  @visibleForTesting
  static String rescueEmail({required String to, required String code}) {
    final subject = 'Your Sati unlock code: {code}'.trf({'code': code});
    final body = ('Your one-time code to end the lock is:\n\n{code}\n\n'
            'It works for {minutes} minutes, on every device signed in to this account. '
            'Enter it where you would enter your own code.\n\n'
            'If you didn\'t ask for this, someone with your phone did. The lock stays on unless the code is entered.')
        .trf({'code': code, 'minutes': rescueMinutes});
    String b64(String s) => base64.encode(utf8.encode(s));
    return [
      'To: $to',
      'Subject: =?UTF-8?B?${b64(subject)}?=',
      'MIME-Version: 1.0',
      'Content-Type: text/plain; charset=UTF-8',
      'Content-Transfer-Encoding: base64',
      '',
      b64(body),
    ].join('\r\n');
  }

  /// Matches LockState.RESCUE_MINUTES.
  static const rescueMinutes = 30;
}

import 'package:flutter/material.dart';

import 'account.dart';
import 'ui.dart';
import 'l10n.dart';

/// Settings section for signing in with Google, so locks are shared between devices.
class AccountPanel extends StatefulWidget {
  const AccountPanel({super.key});

  @override
  State<AccountPanel> createState() => _AccountPanelState();
}

class _AccountPanelState extends State<AccountPanel> {
  final _account = Account.instance;
  bool _busy = false;

  Future<void> _run(Future<void> Function() action) async {
    setState(() => _busy = true);
    try {
      await action();
    } on AccountException catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message)));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return ListenableBuilder(
      listenable: _account,
      builder: (context, _) {
        if (!_account.available) return const SizedBox.shrink();
        final signedIn = _account.signedIn;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SectionLabel('Account'.tr),
            Panel(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      IconBadge(Icons.devices_rounded, color: colors.primary),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              signedIn ? _account.email ?? '' : 'Lock all your devices together'.tr,
                              style: textTheme.titleSmall,
                            ),
                            const SizedBox(height: 2),
                            Text(
                              signedIn
                                  ? ('A lock started on any device signed in to this account locks the others too. '
                                          'If you lose your code, you can get one by email.')
                                      .tr
                                  : ('Sign in with the same account on each device. A lock started on one '
                                          'locks them all. Your lock settings are stored online so your devices can share them.')
                                      .tr,
                              style: textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  if (signedIn && !_account.canEmailCode) ...[
                    Text(
                      'Emailed unlock codes need a Google sign-in. With email and password, keep your own code safe.'.tr,
                      style: textTheme.bodySmall?.copyWith(color: colors.onSurfaceVariant),
                    ),
                    const SizedBox(height: 10),
                  ],
                  if (signedIn)
                    Align(
                      alignment: Alignment.centerRight,
                      child: OutlinedButton.icon(
                        onPressed: _busy ? null : () => _run(_account.signOut),
                        icon: const Icon(Icons.logout_rounded),
                        label: Text('Sign out'.tr),
                      ),
                    )
                  else ...[
                    FilledButton.icon(
                      onPressed: _busy ? null : () => _run(() async => await _account.signIn()),
                      icon: _busy
                          ? const SizedBox.square(dimension: 18, child: CircularProgressIndicator(strokeWidth: 2))
                          : const Icon(Icons.login_rounded),
                      label: Text('Sign in with Google'.tr),
                    ),
                    const SizedBox(height: 8),
                    OutlinedButton.icon(
                      onPressed: _busy
                          ? null
                          : () => showDialog<void>(context: context, builder: (_) => const EmailSignInDialog()),
                      icon: const Icon(Icons.mail_outline_rounded),
                      label: Text('Use email and password'.tr),
                    ),
                  ],
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

/// Signs in, or makes a new account, with an email address and password.
/// Owns its text fields, so they are only freed once the closing animation has finished.
class EmailSignInDialog extends StatefulWidget {
  const EmailSignInDialog({super.key});

  @override
  State<EmailSignInDialog> createState() => _EmailSignInDialogState();
}

class _EmailSignInDialogState extends State<EmailSignInDialog> {
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _confirm = TextEditingController();
  bool _register = false;
  bool _busy = false;
  String? _error;
  String? _notice;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    _confirm.dispose();
    super.dispose();
  }

  Future<void> _run(Future<void> Function() action, {bool close = true}) async {
    setState(() {
      _busy = true;
      _error = null;
      _notice = null;
    });
    try {
      await action();
      if (close && mounted) Navigator.pop(context);
    } on AccountException catch (e) {
      if (mounted) setState(() => _error = e.message);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  void _submit() {
    if (_register && _password.text != _confirm.text) {
      setState(() => _error = 'The passwords don\'t match.'.tr);
      return;
    }
    _run(() => _register
        ? Account.instance.register(_email.text, _password.text)
        : Account.instance.signInWithEmail(_email.text, _password.text));
  }

  void _forgot() {
    if (_email.text.trim().isEmpty) {
      setState(() => _error = 'Enter your email first.'.tr);
      return;
    }
    _run(() async {
      await Account.instance.sendPasswordReset(_email.text);
      if (mounted) setState(() => _notice = 'Check {email} for a link to choose a new password.'.trf({'email': _email.text.trim()}));
    }, close: false);
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return AlertDialog(
      title: Text(_register ? 'Create an account'.tr : 'Sign in with email'.tr),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _email,
              autofocus: true,
              keyboardType: TextInputType.emailAddress,
              autocorrect: false,
              autofillHints: const [AutofillHints.email],
              decoration: InputDecoration(labelText: 'Email'.tr),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _password,
              obscureText: true,
              autocorrect: false,
              autofillHints: [_register ? AutofillHints.newPassword : AutofillHints.password],
              decoration: InputDecoration(
                labelText: 'Password'.tr,
                helperText: _register ? 'At least 6 characters'.tr : null,
              ),
              onSubmitted: _register ? null : (_) => _submit(),
            ),
            if (_register) ...[
              const SizedBox(height: 12),
              TextField(
                controller: _confirm,
                obscureText: true,
                autocorrect: false,
                decoration: InputDecoration(labelText: 'Confirm password'.tr),
                onSubmitted: (_) => _submit(),
              ),
            ],
            if (_error != null) ...[
              const SizedBox(height: 12),
              Text(_error!, style: textTheme.bodySmall?.copyWith(color: colors.error)),
            ],
            if (_notice != null) ...[
              const SizedBox(height: 12),
              Text(_notice!, style: textTheme.bodySmall?.copyWith(color: colors.secondary)),
            ],
            const SizedBox(height: 8),
            if (!_register)
              Align(
                alignment: Alignment.centerLeft,
                child: TextButton(onPressed: _busy ? null : _forgot, child: Text('Forgot password?'.tr)),
              ),
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton(
                onPressed: _busy ? null : () => setState(() {
                  _register = !_register;
                  _error = null;
                  _notice = null;
                }),
                child: Text(_register ? 'I already have an account'.tr : 'New here? Create an account'.tr),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: Text('Cancel'.tr)),
        FilledButton(
          onPressed: _busy ? null : _submit,
          child: _busy
              ? const SizedBox.square(dimension: 18, child: CircularProgressIndicator(strokeWidth: 2))
              : Text(_register ? 'Create account'.tr : 'Sign in'.tr),
        ),
      ],
    );
  }
}

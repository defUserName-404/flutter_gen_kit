const String appLocalizationTemplate = r'''
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

// This is a placeholder. Real localization would use the generated `S` class.
class AppLocalizations {
  static String of(BuildContext context) {
    return Intl.message(
      'Hello from generated app!',
      name: 'helloMessage',
      desc: 'A message for the user.',
    );
  }

  // Example using the generated S class (after `flutter gen-l10n` is run)
  // static String helloMessage(BuildContext context) {
  //   return S.of(context).helloMessage;
  // }
}
''';

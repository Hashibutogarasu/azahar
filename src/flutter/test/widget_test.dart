import 'package:flutter_test/flutter_test.dart';

import 'package:azahar/i18n/translations.g.dart';

void main() {
  test('base locale strings resolve', () {
    final t = AppLocale.en.buildSync();
    expect(t.appName, 'Azahar');
  });
}

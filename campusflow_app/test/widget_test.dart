import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'package:campusflow_app/main.dart';

void main() {
  setUpAll(() => initializeDateFormatting('fr_FR'));

  testWidgets("L'écran de titre affiche le nom de l'application", (
    tester,
  ) async {
    await tester.pumpWidget(const CampusFlowApp());
    expect(find.text('CampusFlow'), findsOneWidget);
  });
}

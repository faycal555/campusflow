import 'package:campusflow_app/screens/echeances_screen.dart';
import 'package:campusflow_app/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';

Widget _app(Widget home) => MaterialApp(theme: AppTheme.light, home: home);

void main() {
  setUpAll(() => initializeDateFormatting('fr_FR'));

  testWidgets('Le formulaire refuse un titre vide', (tester) async {
    await tester.pumpWidget(_app(const EcheancesScreen()));
    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Enregistrer'));
    await tester.pump();
    expect(find.text('Le titre est obligatoire'), findsOneWidget);

    await tester.enterText(find.byType(TextFormField).first, 'Nouveau TP');
    await tester.tap(find.text('Enregistrer'));
    await tester.pumpAndSettle();
    expect(find.text('Nouveau TP'), findsOneWidget);
    expect(find.text('Tâche « Nouveau TP » ajoutée'), findsOneWidget);
  });

  testWidgets('Au-dessus de 840 dp, liste et détail sont côte à côte', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1280, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(_app(const EcheancesScreen()));
    expect(find.text('Sélectionnez une tâche'), findsOneWidget);

    await tester.tap(find.text('Exercices SQL'));
    await tester.pumpAndSettle();
    expect(find.text('Marquer comme fait'), findsOneWidget);
    // Pas de navigation : on reste sur le même écran.
    expect(find.text('Mes échéances'), findsOneWidget);
  });
}

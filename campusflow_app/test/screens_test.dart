import 'package:campusflow_app/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/date_symbol_data_local.dart';

/// Lance l'application et passe l'écran de connexion.
Future<void> pumpApp(WidgetTester tester) async {
  await tester.pumpWidget(const ProviderScope(child: CampusFlowApp()));
  await tester.tap(find.text('Se connecter'));
  await tester.pumpAndSettle();
}

void goTo(WidgetTester tester, String location) {
  GoRouter.of(tester.element(find.byType(Navigator).first)).go(location);
}

void main() {
  setUpAll(() => initializeDateFormatting('fr_FR'));

  testWidgets('Le formulaire refuse un titre vide', (tester) async {
    await pumpApp(tester);
    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Enregistrer'));
    await tester.pump();
    expect(find.text('Le titre est obligatoire'), findsOneWidget);

    await tester.enterText(find.byType(TextFormField).first, 'Nouveau TP');
    await tester.tap(find.text('Enregistrer'));
    await tester.pumpAndSettle();
    expect(find.text('Tâche « Nouveau TP » ajoutée'), findsOneWidget);
  });

  testWidgets('Chaque écran est accessible par son adresse', (tester) async {
    await pumpApp(tester);
    expect(find.text('Mes échéances'), findsOneWidget);

    goTo(tester, '/taches/t3');
    await tester.pumpAndSettle();
    expect(find.text('Exercices SQL'), findsOneWidget);
    expect(find.text('Marquer comme fait'), findsOneWidget);

    goTo(tester, '/taches/nouvelle');
    await tester.pumpAndSettle();
    expect(find.text('Nouvelle tâche'), findsOneWidget);

    goTo(tester, '/cours');
    await tester.pumpAndSettle();
    expect(find.text('Mes cours'), findsOneWidget);

    goTo(tester, '/profil');
    await tester.pumpAndSettle();
    expect(find.text('Se déconnecter'), findsOneWidget);
  });

  testWidgets('Au-dessus de 840 dp, liste et détail sont côte à côte', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1280, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await pumpApp(tester);
    expect(find.text('Sélectionnez une tâche'), findsOneWidget);

    await tester.tap(find.text('Exercices SQL'));
    await tester.pumpAndSettle();
    expect(find.text('Marquer comme fait'), findsOneWidget);
    // Pas de navigation : on reste sur le même écran.
    expect(find.text('Mes échéances'), findsOneWidget);
  });
}

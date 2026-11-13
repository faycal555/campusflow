import 'package:campusflow_app/core/token_storage.dart';
import 'package:campusflow_app/data/auth_repository.dart';
import 'package:campusflow_app/data/fake_repositories.dart';
import 'package:campusflow_app/data/repository_providers.dart';
import 'package:campusflow_app/data/task_repository.dart';
import 'package:campusflow_app/main.dart';
import 'package:campusflow_models/campusflow_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/date_symbol_data_local.dart';

/// Lance l'application avec des repositories en mémoire (aucun réseau) et
/// se connecte avec le compte de démonstration.
Future<void> pumpApp(WidgetTester tester, {TaskRepository? tasks}) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        tokenStorageProvider.overrideWithValue(MemoryTokenStorage()),
        authRepositoryProvider.overrideWithValue(FakeAuthRepository()),
        taskRepositoryProvider.overrideWithValue(tasks ?? FakeTaskRepository()),
        courseRepositoryProvider.overrideWithValue(FakeCourseRepository()),
      ],
      child: const CampusFlowApp(),
    ),
  );
  await tester.pumpAndSettle();
  await tester.enterText(find.byType(TextFormField).at(0), 'aminata@campus.bf');
  await tester.enterText(find.byType(TextFormField).at(1), 'campus2026');
  await tester.tap(find.text('Se connecter'));
  await tester.pumpAndSettle();
}

/// Repository qui échoue au premier chargement puis fonctionne.
class _FlakyRepository extends FakeTaskRepository {
  bool _failed = false;

  @override
  Future<List<Task>> fetchAll() async {
    if (!_failed) {
      _failed = true;
      throw const FormatException('réponse invalide');
    }
    return super.fetchAll();
  }
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

  testWidgets('Une tâche ajoutée ou cochée apparaît dans les autres écrans', (
    tester,
  ) async {
    await pumpApp(tester);

    // Ajout depuis le formulaire → visible dans la liste.
    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextFormField).first, 'Révision examen');
    await tester.tap(find.text('Enregistrer'));
    await tester.pumpAndSettle();
    expect(find.text('Révision examen'), findsOneWidget);

    // Cochée dans le détail → cochée dans la liste.
    await tester.tap(find.text('Exercices SQL'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Marquer comme fait'));
    await tester.pumpAndSettle();
    expect(find.text('Faite'), findsOneWidget);
    goTo(tester, '/taches');
    await tester.pumpAndSettle();
    // Elle a quitté « À faire » et apparaît cochée dans « Faites ».
    expect(find.text('Exercices SQL'), findsNothing);
    await tester.tap(find.textContaining('Faites'));
    await tester.pumpAndSettle();
    final tile = find.ancestor(
      of: find.text('Exercices SQL'),
      matching: find.byType(ListTile),
    );
    final checkbox = tester.widget<Checkbox>(
      find.descendant(of: tile, matching: find.byType(Checkbox)),
    );
    expect(checkbox.value, isTrue);
  });

  testWidgets('Les trois filtres : à faire, faites, en retard', (tester) async {
    await pumpApp(tester);
    // Données d'exemple : 4 tâches non faites dont 1 en retard, 1 faite.
    expect(find.text('À faire (4)'), findsOneWidget);
    expect(find.text('Faites (1)'), findsOneWidget);
    expect(find.text('En retard (1)'), findsOneWidget);
    expect(find.text('Lecture chapitre 2'), findsNothing);

    await tester.tap(find.text('En retard (1)'));
    await tester.pumpAndSettle();
    expect(find.text('Rapport de stage (plan)'), findsOneWidget);
    expect(find.text('Exercices SQL'), findsNothing);

    await tester.tap(find.text('Faites (1)'));
    await tester.pumpAndSettle();
    expect(find.text('Lecture chapitre 2'), findsOneWidget);
  });

  testWidgets('Erreur de chargement puis « Réessayer »', (tester) async {
    await pumpApp(tester, tasks: _FlakyRepository());
    expect(find.text('Données reçues invalides.'), findsOneWidget);

    await tester.tap(find.text('Réessayer'));
    await tester.pumpAndSettle();
    expect(find.text('Exercices SQL'), findsOneWidget);
  });

  testWidgets('Suppression depuis le détail (DELETE)', (tester) async {
    final repo = FakeTaskRepository();
    await pumpApp(tester, tasks: repo);
    await tester.tap(find.text('Exercices SQL'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Supprimer'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(TextButton, 'Supprimer'));
    await tester.pumpAndSettle();

    expect(find.text('Mes échéances'), findsOneWidget);
    expect(find.text('Exercices SQL'), findsNothing);
    // runAsync : le temps est simulé dans testWidgets, Future.delayed n'avancerait pas.
    final remaining = await tester.runAsync(repo.fetchAll);
    expect(remaining!.any((t) => t.title == 'Exercices SQL'), isFalse);
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

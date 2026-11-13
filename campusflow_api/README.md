# campusflow_api — serveur simulé

API REST de CampusFlow fournie par [json-server](https://github.com/typicode/json-server)
à partir de [`db.json`](db.json) (tâches, cours, utilisateurs).

```bash
npm install
npm start
```

- <http://localhost:3000/taches> affiche le JSON brut des tâches.
- Ressources : `/taches`, `/cours`, `/utilisateurs`, avec GET, POST, PATCH et DELETE.
- Le serveur travaille sur une copie (`db.runtime.json`) recréée à chaque
  démarrage : `db.json` reste les données de référence.

Depuis l'émulateur Android, l'API s'appelle par `http://10.0.2.2:3000`
(et non `localhost`, qui désigne l'émulateur lui-même).

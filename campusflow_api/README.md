# campusflow_api — serveur simulé

API REST de CampusFlow fournie par [json-server](https://github.com/typicode/json-server)
à partir de [`db.json`](db.json) (tâches, cours, utilisateurs).

```bash
npm install
npm start            # API protégée par jeton (utilisée par l'application)
npm run start:ouvert # json-server seul, sans authentification
```

## Routes

| Méthode | Route | Rôle |
|---------|-------|------|
| POST | `/login` | `{ email, password }` → `{ token, user }`, ou **401** |
| POST | `/logout` | révoque le jeton |
| GET | `/me` | utilisateur connecté |
| GET, POST | `/taches`, `/cours` | liste / création |
| GET, PATCH, DELETE | `/taches/:id` | détail / modification / suppression |

Avec `npm start`, toutes les routes sauf `/login` exigent l'en-tête
`Authorization: Bearer <jeton>`, sinon le serveur répond **401**. Les jetons sont
gardés en mémoire : redémarrer le serveur les invalide (pratique pour tester la
redirection vers l'écran de connexion). `/utilisateurs` est bloqué pour ne
jamais exposer les mots de passe.

Avec `npm run start:ouvert`, <http://localhost:3000/taches> affiche directement
le JSON brut dans le navigateur.

**Compte de démonstration :** `aminata@campus.bf` / `campus2026`.

Le serveur travaille sur une copie (`db.runtime.json`) recréée à chaque
démarrage : `db.json` reste les données de référence.

Depuis l'émulateur Android, l'API s'appelle par `http://10.0.2.2:3000`
(et non `localhost`, qui désigne l'émulateur lui-même).

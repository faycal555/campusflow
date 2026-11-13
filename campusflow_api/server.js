// Serveur CampusFlow : json-server + authentification simulée par jeton.
//
//   POST /login   { email, password }  -> 200 { token, user } ou 401
//   POST /logout                        -> 204 (jeton révoqué)
//   GET  /me                            -> l'utilisateur connecté
//   toutes les autres routes            -> 401 sans en-tête « Authorization: Bearer <jeton> »
const crypto = require('crypto');
const fs = require('fs');
const path = require('path');
const jsonServer = require('json-server');

const PORT = Number(process.env.PORT) || 3000;

// Le serveur travaille sur une copie : db.json reste les données de référence.
const runtimeDb = path.join(__dirname, 'db.runtime.json');
fs.copyFileSync(path.join(__dirname, 'db.json'), runtimeDb);

const server = jsonServer.create();
const router = jsonServer.router(runtimeDb);
const db = router.db;

// Jetons valides (en mémoire : un redémarrage du serveur les invalide tous).
const sessions = new Map();

const publicUser = ({ password, ...user }) => user;

server.use(jsonServer.defaults({ logger: true }));
server.use(jsonServer.bodyParser);

server.post('/login', (req, res) => {
  const { email, password } = req.body || {};
  const user = db.get('utilisateurs').find({ email, password }).value();
  if (!user) {
    return res.status(401).json({ message: 'Identifiants incorrects' });
  }
  const token = crypto.randomBytes(24).toString('hex');
  sessions.set(token, user.id);
  res.json({ token, user: publicUser(user) });
});

// Contrôle du jeton pour toutes les routes suivantes.
server.use((req, res, next) => {
  const header = req.headers.authorization || '';
  const token = header.startsWith('Bearer ') ? header.slice(7) : null;
  if (!token || !sessions.has(token)) {
    return res.status(401).json({ message: 'Authentification requise' });
  }
  req.token = token;
  req.userId = sessions.get(token);
  next();
});

server.post('/logout', (req, res) => {
  sessions.delete(req.token);
  res.status(204).end();
});

server.get('/me', (req, res) => {
  const user = db.get('utilisateurs').find({ id: req.userId }).value();
  res.json(publicUser(user));
});

// Les mots de passe ne doivent jamais sortir du serveur.
server.use('/utilisateurs', (req, res) => {
  res.status(403).json({ message: 'Accès interdit' });
});

server.use(router);

server.listen(PORT, '0.0.0.0', () => {
  console.log(`API CampusFlow sur http://localhost:${PORT}`);
  console.log('Compte de démonstration : aminata@campus.bf / campus2026');
});

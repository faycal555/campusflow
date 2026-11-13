// Génère les wireframes basse fidélité de CampusFlow (SVG 360x740).
const fs = require('fs');
const path = require('path');
const out = process.argv[2];
fs.mkdirSync(out, { recursive: true });

const W = 360, H = 740;
const esc = (s) => s.replace(/&/g, '&amp;').replace(/</g, '&lt;');
const t = (x, y, s, o = {}) =>
  `<text x="${x}" y="${y}" font-size="${o.size || 14}" font-weight="${o.bold ? 700 : 400}" fill="${o.fill || '#222'}" text-anchor="${o.anchor || 'start'}">${esc(s)}</text>`;
const r = (x, y, w, h, o = {}) =>
  `<rect x="${x}" y="${y}" width="${w}" height="${h}" rx="${o.rx ?? 6}" fill="${o.fill || '#fff'}" stroke="${o.stroke || '#555'}" stroke-width="${o.sw || 1.5}" ${o.dash ? 'stroke-dasharray="5 4"' : ''}/>`;
const c = (cx, cy, rad, o = {}) =>
  `<circle cx="${cx}" cy="${cy}" r="${rad}" fill="${o.fill || '#fff'}" stroke="${o.stroke || '#555'}" stroke-width="1.5"/>`;
const line = (x1, y1, x2, y2) => `<line x1="${x1}" y1="${y1}" x2="${x2}" y2="${y2}" stroke="#bbb" stroke-width="1"/>`;

function wrap(s) { if (!s) return []; const words = s.split(' '); const lines = ['']; for (const w of words) { if ((lines[lines.length - 1] + ' ' + w).length > 62) lines.push(w); else lines[lines.length - 1] = (lines[lines.length - 1] + ' ' + w).trim(); } return lines; }
function frame(title, body, note) {
  return `<svg xmlns="http://www.w3.org/2000/svg" width="${W + 40}" height="${H + 100}" viewBox="0 0 ${W + 40} ${H + 100}" font-family="Arial, sans-serif">
<rect width="100%" height="100%" fill="#f4f4f4"/>
${t(20, 28, title, { bold: true, size: 16 })}
<g transform="translate(20,44)">
${r(0, 0, W, H, { rx: 24, sw: 3, stroke: '#222' })}
${t(24, 26, '9:41', { size: 12 })}${t(W - 24, 26, '▮▮▮ 4G', { size: 12, anchor: 'end' })}
${body}
</g>
${wrap(note).map((l, i) => t(20, H + 66 + i * 15, l, { size: 11, fill: '#555' })).join('')}
</svg>`;
}
const appBar = (title, back = false) =>
  `${line(0, 92, W, 92)}${back ? t(20, 72, '←', { size: 22 }) : ''}${t(back ? 52 : 20, 72, title, { bold: true, size: 20 })}`;
const navBar = (active) => {
  const items = ['Tâches', 'Cours', 'Profil'];
  return `${line(0, H - 72, W, H - 72)}` + items.map((it, i) => {
    const x = 60 + i * 120;
    return `${r(x - 28, H - 60, 56, 26, { rx: 13, fill: i === active ? '#ddd' : '#fff', stroke: i === active ? '#555' : '#fff' })}${c(x, H - 47, 7)}${t(x, H - 18, it, { size: 12, anchor: 'middle', bold: i === active })}`;
  }).join('');
};
const fab = () => `${r(W - 84, H - 148, 64, 56, { rx: 16, fill: '#ddd' })}${t(W - 52, H - 112, '+', { size: 28, anchor: 'middle', bold: true })}`;
const chips = (y, active = 0) => ['À faire', 'Faites', 'En retard'].map((s, i) => {
  const x = 20 + i * 104;
  return `${r(x, y, 96, 32, { rx: 16, fill: i === active ? '#ddd' : '#fff' })}${t(x + 48, y + 21, s, { size: 13, anchor: 'middle', bold: i === active })}`;
}).join('');
const tile = (y, title, sub, late = false) =>
  `${c(40, y + 28, 12)}${t(66, y + 24, title, { size: 15, bold: true })}${t(66, y + 44, sub, { size: 12, fill: late ? '#000' : '#666', bold: late })}${t(W - 24, y + 32, '›', { size: 20, anchor: 'end' })}${line(20, y + 60, W - 20, y + 60)}`;

const files = {};

files['01-connexion.svg'] = frame('Écran 1 — Connexion', `
${r(130, 110, 100, 100, { rx: 50, fill: '#eee' })}${t(180, 166, 'LOGO', { anchor: 'middle', size: 13 })}
${t(180, 250, 'CampusFlow', { anchor: 'middle', bold: true, size: 24 })}
${t(180, 276, 'Vos cours et échéances, au même endroit', { anchor: 'middle', size: 13, fill: '#555' })}
${t(24, 330, 'E-mail', { size: 12 })}${r(20, 338, 320, 52)}${t(36, 370, 'aminata@campus.bf', { fill: '#999' })}
${t(24, 420, 'Mot de passe', { size: 12 })}${r(20, 428, 320, 52)}${t(36, 460, '••••••••', { fill: '#999' })}
${r(20, 510, 320, 52, { rx: 26, fill: '#ccc' })}${t(180, 542, 'Se connecter', { anchor: 'middle', bold: true })}
${t(180, 600, 'Message d\'erreur affiché ici si identifiants refusés', { anchor: 'middle', size: 11, fill: '#777' })}
`, 'Route /login — affiché aussi quand le serveur répond 401.');

files['02-echeances-variante-A.svg'] = frame('Écran 2 — Échéances · Variante A (liste + filtres) ✔ retenue', `
${appBar('Mes échéances')}
${chips(108, 0)}
${tile(156, 'TP Flutter — écran détail', 'Développement mobile · lun. 16 nov.')}
${tile(220, 'Rapport de stage (plan)', 'Méthodologie · hier · EN RETARD', true)}
${tile(284, 'Exercices SQL', 'Bases de données · mer. 18 nov.')}
${tile(348, 'Exposé cloud', 'Cloud computing · ven. 20 nov.')}
${tile(412, 'Projet optimisation', 'Optimisation linéaire · 25 nov.')}
${fab()}${navBar(0)}
`, 'Liste + filtres (retenue). ListView.builder de ListTile, filtres en haut, bouton + flottant, NavigationBar.');

files['02-echeances-variante-B.svg'] = frame('Écran 2 — Échéances · Variante B (cartes par période)', `
${appBar('Mes échéances')}
${t(20, 124, 'EN RETARD', { size: 12, bold: true })}
${r(20, 134, 320, 76, { rx: 12, fill: '#eee' })}${t(36, 164, 'Rapport de stage (plan)', { bold: true })}${t(36, 188, 'Méthodologie · hier', { size: 12 })}
${t(20, 240, 'CETTE SEMAINE', { size: 12, bold: true })}
${r(20, 250, 320, 76, { rx: 12 })}${t(36, 280, 'TP Flutter — écran détail', { bold: true })}${t(36, 304, 'Développement mobile · lun.', { size: 12 })}
${r(20, 336, 320, 76, { rx: 12 })}${t(36, 366, 'Exercices SQL', { bold: true })}${t(36, 390, 'Bases de données · mer.', { size: 12 })}
${t(20, 442, 'PLUS TARD', { size: 12, bold: true })}
${r(20, 452, 320, 76, { rx: 12 })}${t(36, 482, 'Projet optimisation', { bold: true })}${t(36, 506, 'Optimisation linéaire · 25 nov.', { size: 12 })}
${fab()}${navBar(0)}
`, 'Cartes par p�riode. Grandes cartes groupées par période : lisible, mais peu de tâches visibles à la fois.');

const days = ['L', 'M', 'M', 'J', 'V', 'S', 'D'];
files['02-echeances-variante-C.svg'] = frame('Écran 2 — Échéances · Variante C', `
${appBar('Novembre 2026')}
${days.map((d, i) => `${t(36 + i * 48, 120, d, { anchor: 'middle', size: 12 })}${r(16 + i * 48, 130, 40, 48, { rx: 8, fill: i === 0 ? '#ddd' : '#fff' })}${t(36 + i * 48, 160, String(16 + i), { anchor: 'middle', bold: i === 0 })}${[0, 2, 4].includes(i) ? c(36 + i * 48, 172, 3, { fill: '#555' }) : ''}`).join('')}
${line(0, 196, W, 196)}
${t(20, 224, 'Lundi 16 novembre', { bold: true })}
${tile(236, 'TP Flutter — écran détail', 'Développement mobile · 08:00')}
${r(20, 320, 320, 220, { dash: true, fill: '#fafafa', stroke: '#aaa' })}${t(180, 436, 'Rien d\'autre ce jour', { anchor: 'middle', fill: '#999' })}
${fab()}${navBar(0)}
`, 'Calendrier semaine. Vue par jour : bonne pour planifier, mais les retards des jours passés sont invisibles.');

files['03-detail-tache.svg'] = frame('Écran 3 — Détail d\'une tâche', `
${appBar('Détail', true)}
${r(20, 112, 320, 230, { rx: 14 })}
${t(36, 146, 'TP Flutter — écran détail', { bold: true, size: 18 })}
${r(36, 162, 150, 26, { rx: 13, fill: '#eee' })}${t(111, 180, 'Développement mobile', { anchor: 'middle', size: 12 })}
${t(36, 222, '📅  Échéance', { size: 12, fill: '#666' })}${t(36, 244, 'lundi 16 novembre 2026, 08:00')}
${t(36, 280, '●  Statut', { size: 12, fill: '#666' })}${t(36, 302, 'À faire')}
${r(20, 368, 320, 52, { rx: 26, fill: '#ccc' })}${t(180, 400, 'Marquer comme fait', { anchor: 'middle', bold: true })}
${r(20, 432, 320, 52, { rx: 26 })}${t(180, 464, 'Supprimer', { anchor: 'middle' })}
${navBar(0)}
`, 'Route /taches/:id — Column + Card, FilledButton pour l\'action principale.');

files['04-nouvelle-tache.svg'] = frame('Écran 4 — Nouvelle tâche (formulaire)', `
${appBar('Nouvelle tâche', true)}
${t(24, 126, 'Titre *', { size: 12 })}${r(20, 134, 320, 52)}${t(36, 166, 'Ex. : TP Flutter', { fill: '#999' })}
${t(24, 206, 'Le titre est obligatoire', { size: 11, fill: '#000', bold: true })}
${t(24, 240, 'Cours', { size: 12 })}${r(20, 248, 320, 52)}${t(36, 280, 'Développement mobile')}${t(320, 280, '▾', { anchor: 'end' })}
${t(24, 330, 'Date limite', { size: 12 })}${r(20, 338, 320, 52)}${t(36, 370, 'lun. 16 nov. 2026')}${t(320, 370, '📅', { anchor: 'end' })}
${r(20, 420, 320, 52, { rx: 26, fill: '#ccc' })}${t(180, 452, 'Enregistrer', { anchor: 'middle', bold: true })}
${r(20, 640, 320, 44, { rx: 6, fill: '#333', stroke: '#333' })}${t(36, 668, 'Tâche « TP Flutter » ajoutée', { fill: '#fff', size: 13 })}
`, 'Route /taches/nouvelle — Form, validator (titre vide refusé), SnackBar, écran défilant.');

files['05-cours.svg'] = frame('Écran 5 — Mes cours', `
${appBar('Mes cours')}
${['Développement mobile|M. Compaoré · 4 crédits|3 tâches', 'Bases de données|Mme Kaboré · 3 crédits|1 tâche', 'Cloud computing|M. Sawadogo · 3 crédits|1 tâche', 'Optimisation linéaire|M. Traoré · 4 crédits|2 tâches']
    .map((s, i) => { const [a, b, n] = s.split('|'); const y = 112 + i * 96; return `${r(20, y, 320, 84, { rx: 12 })}${r(36, y + 18, 48, 48, { rx: 10, fill: '#eee' })}${t(100, y + 36, a, { bold: true })}${t(100, y + 58, b, { size: 12, fill: '#666' })}${t(324, y + 36, n, { size: 12, anchor: 'end' })}`; }).join('')}
${navBar(1)}
`, 'Route /cours — liste des cours avec nombre de tâches.');

for (const [name, svg] of Object.entries(files)) fs.writeFileSync(path.join(out, name), svg);
console.log(Object.keys(files).join('\n'));


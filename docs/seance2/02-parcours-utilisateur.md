# Séance 2 — Parcours utilisateur « Suivre mes échéances »

Persona : Aminata (voir [01-persona-job-stories.md](01-persona-job-stories.md)).

| Étape | Action d'Aminata | Friction rencontrée | Opportunité pour CampusFlow |
|-------|------------------|---------------------|-----------------------------|
| **1. Planifier** | Le dimanche soir, elle fait le point sur la semaine à venir. | Ses informations sont réparties entre l'agenda papier, des photos du tableau et WhatsApp. | Un écran « Échéances » unique, trié par date, qui regroupe tous les cours. |
| **2. Consulter** | Entre deux cours, elle vérifie ce qui est dû bientôt. | Pas de réseau dans l'amphi ; elle doit ouvrir plusieurs applications. | Données disponibles hors ligne ; filtres « À faire / Faites / En retard » en haut de la liste. |
| **3. Ajouter** | L'enseignant annonce un TP à rendre dans dix jours. | Elle n'a que quelques secondes avant que le cours suivant commence ; saisir sur un petit écran est pénible. | Bouton flottant toujours visible ; formulaire court (titre, cours, date) avec titre obligatoire et confirmation. |
| **4. Être rappelée** | La veille du rendu, elle doit penser à finir le TP. | Aucun rappel : elle découvre l'échéance trop tard. | Tâches en retard mises en évidence (couleur + libellé) ; rappels par notification dans une version ultérieure. |
| **5. Rendre** | Elle dépose son travail puis veut le noter comme terminé. | Dans son agenda papier, rien ne distingue ce qui est fait de ce qui ne l'est pas. | Bouton « Marquer comme fait » sur l'écran de détail ; la tâche passe immédiatement dans le filtre « Faites ». |

**Moment critique :** l'étape 3 (ajouter). Si l'ajout prend plus de quelques
secondes, Aminata abandonne et retourne à WhatsApp ; c'est pourquoi le bouton
d'ajout et la simplicité du formulaire sont prioritaires dans les wireframes.

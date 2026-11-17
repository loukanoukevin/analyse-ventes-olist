
# Description des données
La base contient 99 441 commandes passées par 96 096 clients uniques, pour 112 650 articles, 32 951 produits et 3 095 vendeurs.
Les commandes vont du 4 septembre 2016 au 17 octobre 2018, mais seule la période janvier 2017 – août 2018 (20 mois) est complète et représentative.
97 % des commandes sont livrées (96 478) ; les autres sont expédiées, annulées, indisponibles ou en cours de traitement.
Plusieurs anomalies ont été repérées : des mois quasi vides au début et à la fin de la période, 8 commandes livrées sans date de réception, des avis en double (un même review_id sur plusieurs commandes) et 261 831 doublons dans la table de géolocalisation.
Ces anomalies sont limitées et identifiées : après nettoyage, les données sont fiables et exploitables pour répondre aux 6 questions de la direction.


# Anomalies repérées

1. geolocation : 261 831 lignes en double (26 %)
2. orders : commandes jusqu'en octobre 2018 (mois de sept.-oct. 2018 presque vides)
3. order_reviews : un même review_id peut apparaître sur plusieurs commandes
4. order_reviews : commentaires sur plusieurs lignes (import via COPY)
5. sellers : villes mal saisies (ex. adresse e-mail à la place de la ville)
6. orders : 8 commandes « delivered » sans date de réception
7. orders : septembre à décembre 2016 presque vides (aucune commande en novembre 2016)
8. orders : 775 commandes sans aucun article dans order_items

# Décisions de nettoyage

| # | Problème | Mesure | Décision | Justification |
|---|---|---|---|---|
| 1 | Produits sans catégorie | 610 produits (1,85 %), 1 603 articles vendus, 179 535,28 € de CA, soit 1,32 % du CA total | Conserver ces produits et les regrouper sous la catégorie "non_renseigne" | Les exclure ferait baisser le CA ; le regroupement permet de les afficher dans le classement des catégories |
| 2 | Commandes avec plusieurs avis | 547 commandes (environ 0,55 %), dont 202 avec des notes différentes | Calculer une seule note par commande : la moyenne de ses avis (AVG) | Tient compte de tous les avis sans en privilégier un ; donne une seule note par commande |
| 3 | Catégories sans traduction anglaise | 2 catégories : pc_gamer et portateis_cozinha_e_preparadores_de_alimentos | Afficher le nom portugais quand la traduction manque (COALESCE) | Aucune vente perdue et aucune donnée d'origine modifiée |
| 4 | Commandes livrées sans date de réception | 8 commandes "delivered" (moins de 0,01 %) | Exclues du calcul du délai et du % de retard, mais conservées dans le CA | On ne peut pas calculer un délai sans date de réception ; la vente a bien eu lieu |
| 5 | Mois incomplets | Septembre à décembre 2016 : 4, 324, 0 et 1 commandes ; septembre et octobre 2018 : 16 et 4 commandes | Courbe mensuelle limitée de janvier 2017 à août 2018 (20 mois) ; CA total calculé sur toutes les données | La courbe ne commence et ne finit pas par de fausses chutes ; aucune donnée supprimée |
| 6 | Doublons dans geolocation | 1 000 163 lignes dont 738 332 uniques, soit 261 831 doublons (26 %) | Table conservée telle quelle, sans clé primaire, et non utilisée pour les analyses | Aucune des 6 questions n'en a besoin : la localisation des clients se fait par Etat, avec la table customers |
| 7 | Dates lues comme du texte | Risque signalé par le cahier des charges pour l'import | Colonnes de dates déclarées en TIMESTAMP dès la création des tables | Permet de calculer les délais et de regrouper par mois ; conversion vérifiée après l'import |
| 8 | Double comptage (plusieurs articles et paiements par commande) | Jointure orders x order_items : 112 650 lignes pour 98 666 commandes réelles, soit 14 % de lignes en trop | Compter les commandes avec COUNT(DISTINCT order_id) ; ne jamais joindre directement articles et paiements ; vues séparées pour les commandes et les ventes | Le nombre de commandes et le CA ne sont pas gonflés ; le panier moyen est juste |
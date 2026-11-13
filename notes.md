
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
-- 02_exploration.sql : découverte des données

-- Aperçu des commandes
SELECT * FROM orders LIMIT 5;

-- Clients : 99 441 lignes mais 96 096 personnes réelles (clients qui recommandent)
SELECT COUNT(DISTINCT customer_unique_id) FROM customers;

-- Geolocation : mesure des doublons
SELECT COUNT(*) AS total_lignes,
       COUNT(DISTINCT (geolocation_zip_code_prefix, geolocation_lat, geolocation_lng,
                       geolocation_city, geolocation_state)) AS lignes_uniques
FROM geolocation;

--la période couverte (première et dernière commande) et la répartition des statuts de commande
SELECT MIN(order_purchase_timestamp) AS premiere_commande,
       MAX(order_purchase_timestamp) AS derniere_commande
FROM orders;
-- Résultat : du 2016-09-04 au 2018-10-17
-- Anomalie : le cahier annonce août 2018, mais il existe des commandes
-- jusqu'en octobre 2018 (mois presque vides, à traiter au nettoyage)

--Repartition des commandes par statut
SELECT order_status , COUNT(*) AS commande_par_statut
FROM orders
GROUP BY order_status
ORDER BY commande_par_statut DESC;
-- Résultat (99 441 commandes) :
--   delivered   96 478  (97 %)  livrées
--   shipped      1 107          expédiées, pas encore reçues
--   canceled       625          annulées
--   unavailable    609          indisponibles
--   invoiced       314          facturées
--   processing     301          en préparation
--   created          5          créées
--   approved         2          approuvées
-- Interprétation : 97 % des commandes sont livrées.
-- Pour le délai de livraison (Q5), seules les commandes livrées sont utilisables.

--Vérification des commandes qui n'ont pas de date de reception
SELECT COUNT(*)
FROM orders  
WHERE order_status='delivered'
	AND order_delivered_customer_date IS NULL;
-- Il y 8 commandes qui n'ont pas de date de recepetion dans la base de données

-- Nombre de commandes par mois
SELECT TO_CHAR(order_purchase_timestamp, 'YYYY-MM') AS mois,
       COUNT(*) AS nb_commandes
FROM orders
GROUP BY mois
ORDER BY mois;
-- Observations :
-- 1. Sept.-déc. 2016 : activité quasi nulle (4, 324, 0 et 1 commandes),
--    aucune commande en novembre 2016. Probablement le lancement de la plateforme.
-- 2. Janv. 2017 à nov. 2017 : forte croissance (de 800 à 7 544 commandes/mois).
--    Pic en novembre 2017, vraisemblablement lié au Black Friday (24/11/2017).
-- 3. Janv. 2018 à août 2018 : activité stable, entre 6 000 et 7 300 commandes/mois.
-- 4. Sept.-oct. 2018 : chute à 16 puis 4 commandes. Fin de l'extraction des données,
--    pas une vraie baisse d'activité (piège n°5 du cahier des charges).
-- Décision à prendre (étape 3) : période d'analyse janv. 2017 -> août 2018.


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
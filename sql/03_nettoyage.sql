-- Produits sans catégorie
SELECT COUNT(*) FROM products
WHERE product_category_name IS NULL;

-- Articles vendus dont le produit n'a pas de catégorie
SELECT COUNT(*) AS nb_articles_vendus,
       SUM(oi.price) AS ca_concerne
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
WHERE p.product_category_name IS NULL;

--Calcul du chiffre d'affaires total
SELECT SUM(price) AS ca_total
FROM order_items;

-- Nombre de commandes ayant plusieurs avis
SELECT COUNT(*) AS nb_commandes_plusieurs_avis
FROM (
    SELECT order_id
    FROM order_reviews
    GROUP BY order_id
    HAVING COUNT(*) > 1
) AS commandes_multi_avis;

-- Commandes à plusieurs avis dont les notes sont DIFFÉRENTES
SELECT COUNT(*) AS nb_commandes_notes_differentes
FROM (
    SELECT order_id
    FROM order_reviews
    GROUP BY order_id
    HAVING COUNT(*) > 1
       AND MIN(review_score) <> MAX(review_score)
) AS t;

-- Catégories sans traduction anglaise
SELECT DISTINCT p.product_category_name
FROM products p
LEFT JOIN category_translation ct
    ON p.product_category_name = ct.product_category_name
WHERE ct.product_category_name_english IS NULL
  AND p.product_category_name IS NOT NULL;


-- Test de la règle de nommage des catégories (décisions 1 et 3)
SELECT DISTINCT
       p.product_category_name AS categorie_portugais,
       ct.product_category_name_english AS categorie_anglais,
       COALESCE(ct.product_category_name_english,
                p.product_category_name,
                'non_renseigne') AS categorie_finale
FROM products p
LEFT JOIN category_translation ct
    ON p.product_category_name = ct.product_category_name
ORDER BY categorie_finale;

-- Démonstration du double comptage
SELECT COUNT(*)                   AS nb_lignes,
       COUNT(DISTINCT o.order_id) AS nb_commandes_reelles
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id;





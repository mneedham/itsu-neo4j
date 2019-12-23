CALL apoc.load.json("file:///items.json")
YIELD value

MERGE (product:Product {url: value.url})
SET product.name = value.title, product.description = value.description

WITH product, value
UNWIND value.allergens AS a
MERGE (allergen:Allergen {name: a})
MERGE (product)-[:CONTAINS_ALLERGEN]->(allergen);

// How many allergens are there?
MATCH (allergen:Allergen)
RETURN count(*), collect(allergen.name) AS allergens;

.How many allergens are there?
[opts="header"]
|===
| count(*) | allergens
| 14       | ["fish", "soya", "mustard", "gluten", "celery", "sesame", "sulphur dioxide", "dairy", "egg", "crustaceans", "wheat", "mullusc", "nuts", "peanuts"]
|===

// Which allergen is most prevalent?
MATCH (:Product)
WITH count(*) AS productCount
MATCH (allergen)<-[:CONTAINS_ALLERGEN]-()
WITH allergen, count(*) AS count, productCount
RETURN allergen.name AS allergen, count,
       apoc.math.round(count*1.0/productCount,2) AS percentageOfProducts
ORDER BY count DESC
LIMIT 5;

.Which allergen is most prevalent?
[opts="header"]
|===
| allergen | count | percentageOfProducts
| "soya"    | 78    | 0.7
| "gluten"  | 55    | 0.53
| "sesame"  | 54    | 0.52
| "mustard" | 42    | 0.4
| "celery"  | 24    | 0.23

|===

MATCH (product:Product)
WHERE not((product)-[:CONTAINS_ALLERGEN]->(:Allergen {name: "soya"}))
RETURN product.name, [(product)-[:CONTAINS_ALLERGEN]->(a) | a.name];


// Which products don't contain any of my allergens?
WITH ["crustaceans", "nuts", "egg", "dairy", "fish"] AS allergens
MATCH (product:Product)
WHERE all(allergen in allergens WHERE not((product)-[:CONTAINS_ALLERGEN]->(:Allergen {name: allergen})))
RETURN product.name, product.description, [(product)-[:CONTAINS_ALLERGEN]->(a) | a.name] AS allergens;

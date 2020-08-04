=== Königsberg ===

MATCH (n:Zona) RETURN n;

MATCH path=(n:Zona)-[:PUENTE*]-(m:Zona)
WHERE LENGTH(path) = 7
RETURN path;

MATCH path=(n:Zona)-[:PUENTE*]-(m:Zona)
RETURN path, LENGTH(path) AS length
ORDER BY LENGTH(path) DESC;

=== Los Ramones buscan baterista ===

CREATE 
(a:Person {name: "Joey"}), 
(b:Person {name: "Dee Dee"}),
(c:Person {name: "Tommy"}),
(d:Person {name: "Johnny"}),
(e:Person {name: "Marky"}),
(f:Person {name: "CJ"}),
(g:Person {name: "Elvis"}),
(h:Person {name: "Richie"}),
(i:Person {name: "Deborah"}),
(drums:Instrument {name: "Drums"}),
(a)-[:PLAYS_WITH]->(b),
(a)-[:PLAYS_WITH]->(c),
(a)-[:PLAYS_WITH]->(d),
(a)-[:PLAYS_WITH]->(e),
(a)-[:PLAYS_WITH]->(f),
(a)-[:PLAYS_WITH]->(h),
(b)-[:PLAYS_WITH]->(c),
(b)-[:PLAYS_WITH]->(d),
(b)-[:PLAYS_WITH]->(e),
(b)-[:PLAYS_WITH]->(h),
(c)-[:PLAYS_WITH]->(d),
(d)-[:PLAYS_WITH]->(e),
(d)-[:PLAYS_WITH]->(f),
(d)-[:PLAYS_WITH]->(h),
(a)-[:KNOWS]->(i),
(i)-[:PLAYS_WITH]->(g),
(g)-[:PLAYS]->(drums)
RETURN a, b, c, d, e, f, g, h, i,  drums;

MATCH 
p=(n:Person)-[*]->(m:Person)-[:PLAYS]->(d:Instrument {name: "Drums"})
RETURN p;

=== Fraude telefónico ===

CREATE
(a:Phone_G1 {name: "P1"}),
(b:Phone_G1 {name: "P2"}),
(c:Phone_G1 {name: "P3"}),
(d:Phone_G1 {name: "P4"}),

(e:Phone_F {name: "P5"}),

(g:Phone_G2 {name: "P6"}),
(h:Phone_G2 {name: "P7"}),
(i:Phone_G2 {name: "P8"}),
(j:Phone_G2 {name: "P9"}),

(a)-[:CALLS]->(b),
(a)-[:CALLS]->(d),
(b)-[:CALLS]->(a),
(b)-[:CALLS]->(c),
(b)-[:CALLS]->(d),
(c)-[:CALLS]->(d),
(d)-[:CALLS]->(a),
(d)-[:CALLS]->(b),

(g)-[:CALLS]->(d),
(g)-[:CALLS]->(i),
(h)-[:CALLS]->(g),
(h)-[:CALLS]->(i),
(h)-[:CALLS]->(j),
(i)-[:CALLS]->(h),
(i)-[:CALLS]->(j),
(j)-[:CALLS]->(h),

(e)-[:CALLS]->(h),
(e)-[:CALLS]->(g),
(e)-[:CALLS]->(d)

RETURN a, b, c, d, e, g, h, i, j;

MATCH 
(n:Phone_F)-[:CALLS]->()  WHERE NOT (n)<-[:CALLS]-()
RETURN p

=== Consultas NLP ===

MATCH (n:Word)<-[r:NEXT]-(m:Word)
RETURN n.name AS name, r.count AS count
ORDER BY r.count DESC
LIMIT 5

MATCH (w1:Word)-[r:NEXT]->(w2:Word)
RETURN [w1.name, w2.name] AS pairs, r.count AS count
ORDER BY r.count DESC
LIMIT 5

MATCH (w1:Word)-[r:NEXT]->(w2:Word)
WHERE w1.name <> w2.name
RETURN [w1.name, w2.name] AS pairs, r.count AS count
ORDER BY r.count DESC
LIMIT 5

MATCH (w1:Word {name: "amen"})
MATCH (w2:Word)-[r:NEXT]->(w1)
RETURN w2.name AS prev, w1.name AS word, r.count AS count
ORDER BY r.count DESC;

MATCH (w1:Word {name: "amen"})
MATCH (w2:Word)<-[r:NEXT]-(w1)
RETURN w2.name AS next, w1.name AS word, r.count AS count
ORDER BY r.count DESC;

MATCH (w:Word {name: 'tipo'})
CALL algo.randomWalk.stream(id(w), 5, 1)
YIELD nodeIds
UNWIND nodeIds AS nodeId
RETURN algo.asNode(nodeId).name AS word;
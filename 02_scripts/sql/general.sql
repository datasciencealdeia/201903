--meu primeiro SQL (DQL)
SELECT 'Hello World'

--meu primeiro SQL util
SELECT * FROM ds_exportacoes;
SELECT * FROM ds_ncm;

--contando as tuplas/registros/linhas
SELECT COUNT(*) FROM ds_exportacoes;

--Fazendo o JOIN entre as tabelas. Bora derrubar o servidor? ISso é um cartesiano
SELECT 
*
FROM 
ds_exportacoes
,ds_ncm;
--NUNCA FAREI!!!

--Jeito certo
SELECT
*
FROM
ds_exportacoes as e
,ds_ncm as n
WHERE
e.co_ncm = n.co_ncm;

--Quais os 3 maiores estados exportadores de SOJA (toneladas) entre 2014 e 2018? 
SELECT
n.no_ncm_por
,SUM(e.qt_estat)
FROM
ds_exportacoes as e
INNER JOIN ds_ncm as n ON e.co_ncm = n.co_ncm;

--Quais os 3 maiores estados exportadores de SOJA (toneladas) entre 2014 e 2018? 
SELECT
n.co_ncm
,n.no_ncm_por
,SUM(e.qt_estat)
FROM
ds_exportacoes as e
INNER JOIN ds_ncm as n ON e.co_ncm = n.co_ncm
GROUP BY 
n.co_ncm
,n.no_ncm_por;

--Quais os 3 maiores estados exportadores de SOJA (toneladas) entre 2014 e 2018? - >= and <=
SELECT
n.co_ncm
,n.no_ncm_por
,e.co_uf
,TO_CHAR(sum(e.qt_estat), '9G999G999G999G999D99') as total_toneladas
FROM
ds_exportacoes as e
INNER JOIN ds_ncm as n ON e.co_ncm = n.co_ncm
WHERE
n.co_ncm = '12019000'
AND e.co_ano >= '2014'
AND e.co_ano <= '2018'
GROUP BY 
n.co_ncm
,n.no_ncm_por
,e.co_uf;

--Quais os 3 maiores estados exportadores de SOJA (toneladas) entre 2014 e 2018? - Order by biched?
SELECT
n.co_ncm
,n.no_ncm_por
,e.co_uf
,TO_CHAR(sum(e.qt_estat), '9G999G999G999G999D99') as total_toneladas
FROM
ds_exportacoes as e
INNER JOIN ds_ncm as n ON e.co_ncm = n.co_ncm
WHERE
n.co_ncm = '12019000'
AND e.co_ano between '2014' and '2018'
GROUP BY 
n.co_ncm
,n.no_ncm_por
,e.co_uf
ORDER BY
total_toneladas DESC;

--Quais os 3 maiores estados exportadores de SOJA (toneladas) entre 2014 e 2018? - Order by OK
SELECT
n.co_ncm
,n.no_ncm_por
,e.co_uf
,TO_CHAR(sum(e.qt_estat), '9G999G999G999G999') as total_toneladas
FROM
ds_exportacoes as e
INNER JOIN ds_ncm as n ON e.co_ncm = n.co_ncm
WHERE
n.co_ncm = '12019000'
AND e.co_ano between '2014' and '2018'
GROUP BY 
n.co_ncm
,n.no_ncm_por
,e.co_uf
ORDER BY
sum(e.qt_estat) DESC;

--Quais os 3 maiores estados exportadores de SOJA (toneladas) entre 2014 e 2018? - Somente os 3 primeiros
SELECT
n.co_ncm
,n.no_ncm_por
,e.co_uf
,TO_CHAR(sum(e.qt_estat), '9G999G999G999G999') as total_toneladas
FROM
ds_exportacoes as e
INNER JOIN ds_ncm as n ON e.co_ncm = n.co_ncm
WHERE
n.co_ncm = '12019000'
AND e.co_ano between '2014' and '2018'
GROUP BY 
n.co_ncm
,n.no_ncm_por
,e.co_uf
ORDER BY
sum(e.qt_estat) DESC
LIMIT 3;

--Quais os 3 maiores estados exportadores de SOJA (USD) entre 2014 e 2018? - Somente os 3 primeiros
SELECT
n.co_ncm
,n.no_ncm_por
,e.co_uf
--,TO_CHAR(sum(e.qt_estat), '9G999G999G999G999') as total_toneladas
,CAST(SUM(e.vl_fob) as money) as total_USD
FROM
ds_exportacoes as e
INNER JOIN ds_ncm as n ON e.co_ncm = n.co_ncm
WHERE
n.co_ncm = '12019000'
AND e.co_ano between '2014' and '2018'
GROUP BY 
n.co_ncm
,n.no_ncm_por
,e.co_uf
ORDER BY
sum(e.vl_fob) DESC
LIMIT 3;

--Quais os 3 maiores estados exportadores de SOJA (BRL) entre 2014 e 2018? - Somente os 3 primeiros - Erro
SELECT
n.co_ncm
,n.no_ncm_por
,e.co_uf
--,TO_CHAR(sum(e.qt_estat), '9G999G999G999G999') as total_toneladas
,CAST(SUM(e.vl_fob) as money)*c.cotacao as total_BRL
FROM
ds_exportacoes as e
INNER JOIN ds_ncm as n ON e.co_ncm = n.co_ncm
INNER JOIN ds_cotacao as c ON c.ano_mes = e.ano_mes
WHERE
n.co_ncm = '12019000'
AND e.co_ano between '2014' and '2018'
GROUP BY 
n.co_ncm
,n.no_ncm_por
,e.co_uf
ORDER BY
sum(e.vl_fob) DESC
LIMIT 3;

/*
EM TONELADAS

"MT"	"     5.653.372.256"
"PR"	"     3.395.010.429"
"SP"	"     2.730.859.851"
*/

--Quais os 3 maiores estados exportadores de SOJA (BRL) entre 2014 e 2018? - Somente os 3 primeiros
SELECT
n.co_ncm
,n.no_ncm_por
,e.co_uf
--TO_CHAR(sum(e.qt_estat), '9G999G999G999G999') as total_toneladas
,CAST(SUM(e.vl_fob*c.cotacao) as money) as total_BRL
FROM
ds_exportacoes as e
INNER JOIN ds_ncm as n ON e.co_ncm = n.co_ncm
INNER JOIN ds_cotacao as c ON c.ano_mes = e.ano_mes
WHERE
n.co_ncm = '12019000'
AND e.co_ano between '2014' and '2018'
GROUP BY 
n.co_ncm
,n.no_ncm_por
,e.co_uf
ORDER BY
sum(e.vl_fob) DESC
LIMIT 3;

--Quais os 3 maiores estados exportadores de SOJA (BRL) com TONELADAS TOTAIS entre 2014 e 2018? - Somente os 3 primeiros
/*"     5.653.372.256"
"     3.395.010.429"
"     2.730.859.851"*/

SELECT
n.co_ncm
,n.no_ncm_por
,e.co_uf
,TO_CHAR(sum(e.qt_estat), '9G999G999G999G999') as total_toneladas
,CAST(SUM(e.vl_fob*c.cotacao) as money) as total_BRL
,CAST(SUM(e.vl_fob*c.cotacao)/sum(e.qt_estat) as money)
FROM
ds_exportacoes as e
INNER JOIN ds_ncm as n ON e.co_ncm = n.co_ncm
INNER JOIN ds_cotacao as c ON c.ano_mes = e.ano_mes
WHERE
n.co_ncm = '12019000'
AND e.co_ano between '2014' and '2018'
GROUP BY 
n.co_ncm
,n.no_ncm_por
,e.co_uf
ORDER BY
sum(e.qt_estat) DESC
LIMIT 3;

--De agora em diante só análise de tonelada e fazer o mesmo estudo para cada um dos commodites

--Quais os NCMs?
SELECT DISTINCT e.co_ncm, n.no_ncm_por
FROM ds_exportacoes e 
INNER JOIN ds_ncm n ON n.co_ncm = e.co_ncm;

/*
"12019000"	"Soja, mesmo triturada, exceto para semeadura"
"10059010"	"Milho em grăo, exceto para semeadura"
"09011110"	"Café năo torrado, năo descafeinado, em grăo"
*/

--Quais os 3 maiores estados exportadores de SOJA, MILHO E CAFE (TON) entre 2014 e 2018? - Somente os 3 primeiros - Erro

--"12019000"	"Soja, mesmo triturada, exceto para semeadura"
SELECT
n.co_ncm
,n.no_ncm_por
,e.co_uf
,TO_CHAR(sum(e.qt_estat), '9G999G999G999G999') as total_toneladas
FROM
ds_exportacoes as e
INNER JOIN ds_ncm as n ON e.co_ncm = n.co_ncm
WHERE
n.co_ncm = '12019000'
AND e.co_ano between '2014' and '2018'
GROUP BY 
n.co_ncm
,n.no_ncm_por
,e.co_uf
ORDER BY
sum(e.qt_estat) DESC
LIMIT 3;

--"10059010"	"Milho em grăo, exceto para semeadura"
SELECT
n.co_ncm
,n.no_ncm_por
,e.co_uf
,TO_CHAR(sum(e.qt_estat), '9G999G999G999G999') as total_toneladas
FROM
ds_exportacoes as e
INNER JOIN ds_ncm as n ON e.co_ncm = n.co_ncm
WHERE
n.co_ncm = '10059010'
AND e.co_ano between '2014' and '2018'
GROUP BY 
n.co_ncm
,n.no_ncm_por
,e.co_uf
ORDER BY
sum(e.qt_estat) DESC
LIMIT 3;

--"09011110"	"Café năo torrado, năo descafeinado, em grăo"
SELECT
n.co_ncm
,n.no_ncm_por
,e.co_uf
,TO_CHAR(sum(e.qt_estat), '9G999G999G999G999') as total_toneladas
FROM
ds_exportacoes as e
INNER JOIN ds_ncm as n ON e.co_ncm = n.co_ncm
WHERE
n.co_ncm = '09011110'
AND e.co_ano between '2014' and '2018'
GROUP BY 
n.co_ncm
,n.no_ncm_por
,e.co_uf
ORDER BY
sum(e.qt_estat) DESC
LIMIT 3;

--Para evitar exportar cada uma das queries por NCM pq nao uni-las? - UNION - Pegadinha do Malandro
SELECT
n.co_ncm
,n.no_ncm_por
,e.co_uf
,TO_CHAR(sum(e.qt_estat), '9G999G999G999G999') as total_toneladas
FROM
ds_exportacoes as e
INNER JOIN ds_ncm as n ON e.co_ncm = n.co_ncm
WHERE
n.co_ncm = '12019000'
AND e.co_ano between '2014' and '2018'
GROUP BY 
n.co_ncm
,n.no_ncm_por
,e.co_uf
ORDER BY
sum(e.qt_estat) DESC
LIMIT 3
UNION
SELECT
n.co_ncm
,n.no_ncm_por
,e.co_uf
,TO_CHAR(sum(e.qt_estat), '9G999G999G999G999') as total_toneladas
FROM
ds_exportacoes as e
INNER JOIN ds_ncm as n ON e.co_ncm = n.co_ncm
WHERE
n.co_ncm = '10059010'
AND e.co_ano between '2014' and '2018'
GROUP BY 
n.co_ncm
,n.no_ncm_por
,e.co_uf
ORDER BY
sum(e.qt_estat) DESC
LIMIT 3
UNION
SELECT
n.co_ncm
,n.no_ncm_por
,e.co_uf
,TO_CHAR(sum(e.qt_estat), '9G999G999G999G999') as total_toneladas
FROM
ds_exportacoes as e
INNER JOIN ds_ncm as n ON e.co_ncm = n.co_ncm
WHERE
n.co_ncm = '09011110'
AND e.co_ano between '2014' and '2018'
GROUP BY 
n.co_ncm
,n.no_ncm_por
,e.co_uf
ORDER BY
sum(e.qt_estat) DESC
LIMIT 3;

--Nao eh feiticaria eh tecnologia
(SELECT
n.co_ncm
,n.no_ncm_por
,e.co_uf
,TO_CHAR(sum(e.qt_estat), '9G999G999G999G999') as total_toneladas
FROM
ds_exportacoes as e
INNER JOIN ds_ncm as n ON e.co_ncm = n.co_ncm
WHERE
n.co_ncm = '12019000'
AND e.co_ano between '2014' and '2018'
GROUP BY 
n.co_ncm
,n.no_ncm_por
,e.co_uf
ORDER BY
sum(e.qt_estat) DESC
LIMIT 3)
UNION
(SELECT
n.co_ncm
,n.no_ncm_por
,e.co_uf
,TO_CHAR(sum(e.qt_estat), '9G999G999G999G999') as total_toneladas
FROM
ds_exportacoes as e
INNER JOIN ds_ncm as n ON e.co_ncm = n.co_ncm
WHERE
n.co_ncm = '10059010'
AND e.co_ano between '2014' and '2018'
GROUP BY 
n.co_ncm
,n.no_ncm_por
,e.co_uf
ORDER BY
sum(e.qt_estat) DESC
LIMIT 3)
UNION
(SELECT
n.co_ncm
,n.no_ncm_por
,e.co_uf
,TO_CHAR(sum(e.qt_estat), '9G999G999G999G999') as total_toneladas
FROM
ds_exportacoes as e
INNER JOIN ds_ncm as n ON e.co_ncm = n.co_ncm
WHERE
n.co_ncm = '09011110'
AND e.co_ano between '2014' and '2018'
GROUP BY 
n.co_ncm
,n.no_ncm_por
,e.co_uf
ORDER BY
sum(e.qt_estat) DESC
LIMIT 3)
ORDER BY 1 DESC,4 DESC;
;

/* ==============================   Hora de pensar... e pensar... e pensar... ====================== */











/* ==== E PENSAR ===== */












/* O Brasil é o 3o maior produto mundial de milho... e o maior produto mundial de soja. Pq o número do milho estah TAO elevado? */













/* Bora analisar o milho x soja na tabela de NCM x EXPORTACOES em JAN 2018 no MT */
SELECT
*
FROM
ds_exportacoes d
INNER JOIN ds_ncm n ON n.co_ncm = d.co_ncm
WHERE
d.co_uf='MT'
and d.co_ncm in ('10059010','12019000')
and d.ano_mes = 201801;

--EUREKA corrigindo o retorno temos
(SELECT
n.co_ncm
,n.no_ncm_por
,e.co_uf
,TO_CHAR(sum(e.qt_estat), '9G999G999G999G999') as total_toneladas
FROM
ds_exportacoes as e
INNER JOIN ds_ncm as n ON e.co_ncm = n.co_ncm
WHERE
n.co_ncm = '12019000'
AND e.co_ano between '2014' and '2018'
GROUP BY 
n.co_ncm
,n.no_ncm_por
,e.co_uf
ORDER BY
sum(e.qt_estat) DESC
LIMIT 3)
UNION
(SELECT
n.co_ncm
,n.no_ncm_por
,e.co_uf
,TO_CHAR(sum(e.qt_estat)/1000, '9G999G999G999G999') as total_toneladas
FROM
ds_exportacoes as e
INNER JOIN ds_ncm as n ON e.co_ncm = n.co_ncm
WHERE
n.co_ncm = '10059010'
AND e.co_ano between '2014' and '2018'
GROUP BY 
n.co_ncm
,n.no_ncm_por
,e.co_uf
ORDER BY
sum(e.qt_estat) DESC
LIMIT 3)
UNION
(SELECT
n.co_ncm
,n.no_ncm_por
,e.co_uf
,TO_CHAR(sum(e.qt_estat), '9G999G999G999G999') as total_toneladas
FROM
ds_exportacoes as e
INNER JOIN ds_ncm as n ON e.co_ncm = n.co_ncm
WHERE
n.co_ncm = '09011110'
AND e.co_ano between '2014' and '2018'
GROUP BY 
n.co_ncm
,n.no_ncm_por
,e.co_uf
ORDER BY
sum(e.qt_estat) DESC
LIMIT 3)
ORDER BY 1 ASC,4 DESC;
;

--Corrigindo a fonte de dados do milho para não apresentar mais este problema do Kg x Ton - UPDATE (DML)
UPDATE
ds_exportacoes
SET
qt_estat=qt_estat/1000
WHERE
co_ncm = '10059010'
AND;
--rollback or commit?

--E indices? Temos? Precisa (DDL)
CREATE INDEX ON ds_exportacoes (e.co_ncm) and;
--rollback ou commit?

--Exercicio valendo um Kit Kat para primeira(o) que terminar

/*
Seu chefinho quer mais uma analise previa dos dados... ele quer saber quais os 5 PAISES (NOME) que mais compraram SOJA
, MILHO E CAFE (em toneladas) DO Brasil em 2018

Ex:
Cafe... China 1.500.000.000
Cafe... Japao 1.300.000.000
...
Milho... Portugal 35.000.000
...
Soja... Australia 2.000.000
....


Go Ahead!
*/
...


------- BONUS ---------

--join de todas as tabelas
select
*
from
ds_exportacoes e
,ds_cotacao c
,ds_ncm n
,ds_urf u
,ds_pais p
,ds_modal m
where
e.ano_mes = c.ano_mes
and e.co_ncm = n.co_ncm
and e.co_urf = u.co_urf
and e.co_pais = p.co_pais
and e.co_modal = m.co_via;

--total de linhas por NCM por ano
select
co_ano
,co_ncm
,count(*)
from
ds_exportacoes
group by
co_ano
,co_ncm
order by
co_ano desc;

--Bonus analisando dados duplicados
select
co_ncm
,co_ano
,co_mes
,co_pais
,co_urf
,co_modal
,qt_estat
,vl_fob
,ano_mes
,count(*)
from
ds_exportacoes
group by
co_ncm
,co_ano
,co_mes
,co_pais
,co_urf
,co_modal
,qt_estat
,vl_fob
,ano_mes
having count(*)>1
order by co_ano desc;



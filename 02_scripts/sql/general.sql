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

rollback

select * from ds_exportacoes where co_ncm='10059010' and co_ano='2019' and co_uf='MT' and co_mes='01' order by co_mes,co_pais,co_uf desc;

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



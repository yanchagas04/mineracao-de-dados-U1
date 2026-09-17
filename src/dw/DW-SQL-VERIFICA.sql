-- ---------------------------------------------------------
-- 1. CONSULTA TUDO DIMENSÕES
-- ---------------------------------------------------------

-- ---------------------------------------------------------
-- 1.1. CONSULTA dim_estado_civil
-- ---------------------------------------------------------

select * from dim_estado_civil ec;

-- ---------------------------------------------------------
-- 1.2. CONSULTA dim_loja
-- ---------------------------------------------------------

select * from dim_loja l;

-- ---------------------------------------------------------
-- 1.3. CONSULTA dim_produto
-- ---------------------------------------------------------

select * from dim_produto p;

-- ---------------------------------------------------------
-- 1.4. CONSULTA dim_tempo
-- ---------------------------------------------------------

select * from dim_tempo t;

-- ---------------------------------------------------------
-- 2. CONSULTA FATOS
-- ---------------------------------------------------------

-- ---------------------------------------------------------
-- 2.1. CONSULTA fato_vendas_concorrente
-- ---------------------------------------------------------

select * from fato_vendas_concorrente vc;

-- ---------------------------------------------------------
-- 2.2. CONSULTA fato_vendas
-- ---------------------------------------------------------

select * from fato_vendas v;

-- ---------------------------------------------------------
-- 3. VERIFICA QUANTIDADE DE LINHAS + CALCULA POSSIBILIDADES
-- ---------------------------------------------------------

-- Rode esse script primeiro para poder forçar o Postgres retornar estatísticas com valores reais e não tomar o erro 2201E (Logaritmo de um número negativo)
ANALYZE dim_estado_civil, dim_loja, dim_produto, dim_tempo;

-- Esse script retorna aqui a quantidade total de linhas de cada tabela dimensão, soma delas e o produto delas para verificar a quantidade de possibilidades total
WITH dimensoes AS (
    SELECT
        c.relname AS tabela,
        c.reltuples::bigint AS total_linhas
    FROM pg_class c
    JOIN pg_namespace n ON n.oid = c.relnamespace
    WHERE n.nspname = 'public'
      AND c.relkind = 'r'
      AND c.relname LIKE 'dim%'
)
SELECT tabela AS "NOME DA TABELA", total_linhas AS "TOTAL DE LINHAS"
FROM dimensoes
UNION ALL
SELECT 'TOTAL (soma)' AS tabela,
       SUM(total_linhas) AS total_linhas
FROM dimensoes
UNION ALL
SELECT 'TOTAL (produto)' AS tabela,
       ROUND(EXP(SUM(LN(total_linhas))))::bigint AS total_linhas
FROM dimensoes;
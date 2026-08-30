-- -----------------------------------------------------------------------------
-- 1. DIMENSÃO TEMPO (MENSAL)
-- SK_TEMPO no formato YYYYMM (ex: 202501 para Jan/2025)
-- -----------------------------------------------------------------------------
CREATE TABLE dim_tempo (
    sk_tempo             INTEGER PRIMARY KEY, -- YYYYMM
    ano                  INTEGER NOT NULL,
    mes                  INTEGER NOT NULL,
    nome_mes             VARCHAR(20) NOT NULL,
    ano_mes              VARCHAR(7) NOT NULL, -- '2025-01'
    quadrimestre         INTEGER NOT NULL,    -- 1, 2 ou 3
    nome_quadrimestre    VARCHAR(15) NOT NULL -- '1º Quadrimestre'
);

-- -----------------------------------------------------------------------------
-- 2. DEMAIS DIMENSÕES
-- -----------------------------------------------------------------------------
CREATE TABLE dim_cliente (
    sk_cliente           SERIAL PRIMARY KEY,
    bk_id_cliente        INTEGER NOT NULL,
    origem_fonte         VARCHAR(30) NOT NULL,
    nome_cliente         VARCHAR(150) NOT NULL,
    email                VARCHAR(150),
    telefone             VARCHAR(30),
    genero               VARCHAR(20),
    estado_civil         VARCHAR(30),
    data_nascimento      DATE
);

CREATE TABLE dim_produto (
    sk_produto           SERIAL PRIMARY KEY,
    bk_id_produto        INTEGER NOT NULL,
    origem_fonte         VARCHAR(30) NOT NULL,
    nome_produto         VARCHAR(150) NOT NULL,
    categoria            VARCHAR(100) NOT NULL,
    preco_referencia     NUMERIC(12,2)
);

CREATE TABLE dim_loja (
    sk_loja              SERIAL PRIMARY KEY,
    nome_loja            VARCHAR(100) NOT NULL,
    cidade               VARCHAR(100) NOT NULL,
    estado               VARCHAR(10) NOT NULL,
    tipo_unidade         VARCHAR(30) NOT NULL,
    sistema_origem       VARCHAR(50) NOT NULL
);

-- -----------------------------------------------------------------------------
-- 3. TABELAS FATO (AGREGADAS POR MÊS)
-- -----------------------------------------------------------------------------
CREATE TABLE fato_vendas (
    sk_tempo             INTEGER NOT NULL REFERENCES dim_tempo(sk_tempo),
    sk_cliente           INTEGER NOT NULL REFERENCES dim_cliente(sk_cliente),
    sk_produto           INTEGER NOT NULL REFERENCES dim_produto(sk_produto),
    sk_loja              INTEGER NOT NULL REFERENCES dim_loja(sk_loja),
    quantidade_vendida   INTEGER NOT NULL,
    valor_total_venda    NUMERIC(12,2) NOT NULL
);

CREATE TABLE fato_vendas_concorrente (
    sk_tempo             INTEGER NOT NULL REFERENCES dim_tempo(sk_tempo),
    sk_produto           INTEGER NOT NULL REFERENCES dim_produto(sk_produto),
    sk_loja              INTEGER NOT NULL REFERENCES dim_loja(sk_loja),
    quantidade_vendida   INTEGER NOT NULL,
    valor_total_venda    NUMERIC(12,2) NOT NULL
);

-- -----------------------------------------------------------------------------
-- 4. ÍNDICES
-- -----------------------------------------------------------------------------
CREATE INDEX idx_fv_tempo   ON fato_vendas(sk_tempo);
CREATE INDEX idx_fv_cliente ON fato_vendas(sk_cliente);
CREATE INDEX idx_fv_produto ON fato_vendas(sk_produto);
CREATE INDEX idx_fv_loja    ON fato_vendas(sk_loja);

CREATE INDEX idx_fvc_tempo   ON fato_vendas_concorrente(sk_tempo);
CREATE INDEX idx_fvc_produto ON fato_vendas_concorrente(sk_produto);
CREATE INDEX idx_fvc_loja    ON fato_vendas_concorrente(sk_loja);
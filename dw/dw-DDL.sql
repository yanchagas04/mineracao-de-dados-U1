-- -----------------------------------------------------------------------------
-- 1. DIMENSÃO TEMPO (QUADRIMESTRAL / ANUAL)
-- SK_TEMPO no formato YYYYQ (ex: 20241 para 1º Quadrimestre/2024)
-- -----------------------------------------------------------------------------
CREATE TABLE dim_tempo (
    sk_tempo             INTEGER PRIMARY KEY, -- YYYYQ (ex: 20241, 20242, 20243)
    ano                  INTEGER NOT NULL,
    quadrimestre         INTEGER NOT NULL     -- 1, 2 ou 3
);

-- -----------------------------------------------------------------------------
-- 2. DEMAIS DIMENSÕES
-- -----------------------------------------------------------------------------
CREATE TABLE dim_estado_civil (
    sk_estado_civil      SERIAL PRIMARY KEY,
    estado_civil         VARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE dim_produto (
    sk_produto           SERIAL PRIMARY KEY,
    id_origem            INTEGER,
    nome_produto         VARCHAR(150) NOT NULL,
    categoria            VARCHAR(100) NOT NULL
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
    sk_estado_civil      INTEGER NOT NULL REFERENCES dim_estado_civil(sk_estado_civil),
    sk_produto           INTEGER NOT NULL REFERENCES dim_produto(sk_produto),
    sk_loja              INTEGER NOT NULL REFERENCES dim_loja(sk_loja),
    quantidade_vendida   INTEGER NOT NULL,
    valor_total_venda    NUMERIC(12,2) NOT NULL,

    CONSTRAINT pk_fato_vendas
        PRIMARY KEY (sk_tempo, sk_estado_civil, sk_produto, sk_loja)
);

CREATE TABLE fato_vendas_concorrente (
    sk_tempo             INTEGER NOT NULL REFERENCES dim_tempo(sk_tempo),
    valor                 NUMERIC(12,2) NOT NULL,

    CONSTRAINT pk_fato_vendas_concorrente
        PRIMARY KEY (sk_tempo)
);

-- -----------------------------------------------------------------------------
-- 4. ÍNDICES
-- -----------------------------------------------------------------------------

CREATE INDEX idx_fv_tempo        ON fato_vendas(sk_tempo);
CREATE INDEX idx_fv_estado_civil ON fato_vendas(sk_estado_civil);
CREATE INDEX idx_fv_produto      ON fato_vendas(sk_produto);
CREATE INDEX idx_fv_loja         ON fato_vendas(sk_loja);

CREATE INDEX idx_fvc_tempo   ON fato_vendas_concorrente(sk_tempo);

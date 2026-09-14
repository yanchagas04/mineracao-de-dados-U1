-- -----------------------------------------------------------------------------
-- 1. LOJA SALVADOR (Origem: Oracle)
-- -----------------------------------------------------------------------------
CREATE TABLE STG_SALVADOR_CLIENTES (
    ID_CLIENTE          NUMBER(10),
    NOME                VARCHAR2(150),
    EMAIL               VARCHAR2(150),
    TELEFONE            VARCHAR2(30),
    SEXO                VARCHAR2(20),
    ESTADO_CIVIL        VARCHAR2(30),
    DATA_NASCIMENTO     DATE
);

CREATE TABLE STG_SALVADOR_PRODUTOS (
    ID_PRODUTO         NUMBER(10),
    NOME_PRODUTO       VARCHAR2(150),
    CATEGORIA          VARCHAR2(100),
    PRECO              NUMBER(12,2)
);

CREATE TABLE STG_SALVADOR_VENDAS (
    ID_VENDA           NUMBER(10),
    ID_CLIENTE         NUMBER(10),
    DATA_VENDA         DATE,
    VALOR_TOTAL        NUMBER(12,2)
);

CREATE TABLE STG_SALVADOR_ITENS_VENDA (
    ID_ITEM            NUMBER(10),
    ID_VENDA           NUMBER(10),
    ID_PRODUTO         NUMBER(10),
    QUANTIDADE         NUMBER(10),
    PRECO_UNITARIO     NUMBER(12,2)
);

-- -----------------------------------------------------------------------------
-- 2. LOJA ITABUNA (Origem: PostgreSQL / Supabase)
-- -----------------------------------------------------------------------------
CREATE TABLE STG_ITABUNA_CLIENTES (
    ID_CLIENTE          NUMBER(10),
    NOME                VARCHAR2(150),
    EMAIL               VARCHAR2(150),
    TELEFONE            VARCHAR2(30),
    SEXO                VARCHAR2(20),
    ESTADO_CIVIL        VARCHAR2(30),
    DATA_NASCIMENTO     DATE
);

CREATE TABLE STG_ITABUNA_PRODUTOS (
    ID_PRODUTO         NUMBER(10),
    NOME_PRODUTO       VARCHAR2(150),
    CATEGORIA          VARCHAR2(100),
    PRECO              NUMBER(12,2)
);

CREATE TABLE STG_ITABUNA_VENDAS (
    ID_VENDA           NUMBER(10),
    ID_CLIENTE         NUMBER(10),
    DATA_VENDA         DATE,
    VALOR_TOTAL        NUMBER(12,2)
);

CREATE TABLE STG_ITABUNA_ITENS_VENDA (
    ID_ITEM            NUMBER(10),
    ID_VENDA           NUMBER(10),
    ID_PRODUTO         NUMBER(10),
    QUANTIDADE         NUMBER(10),
    PRECO_UNITARIO     NUMBER(12,2)
);

-- -----------------------------------------------------------------------------
-- 3. LOJA FEIRA DE SANTANA (Origem: MongoDB / JSON (transformado em Oracle))
-- -----------------------------------------------------------------------------
CREATE TABLE STG_FEIRA_CLIENTES (
    ID_CLIENTE          NUMBER(10),
    NOME                VARCHAR2(150),
    EMAIL               VARCHAR2(150),
    TELEFONE            VARCHAR2(30),
    SEXO                VARCHAR2(20),
    ESTADO_CIVIL        VARCHAR2(30),
    DATA_NASCIMENTO     DATE
);

CREATE TABLE STG_FEIRA_PRODUTOS (
    ID_PRODUTO         NUMBER(10),
    NOME_PRODUTO       VARCHAR2(150),
    CATEGORIA          VARCHAR2(100),
    PRECO              NUMBER(12,2)
);

CREATE TABLE STG_FEIRA_PEDIDOS (
    ID_PEDIDO          NUMBER(10),
    ID_CLIENTE         NUMBER(10),
    DATA_PEDIDO        DATE,
    VALOR_TOTAL        NUMBER(12,2)
);

CREATE TABLE STG_FEIRA_ITENS_PEDIDO (
    ID_ITEM            NUMBER(10),
    ID_PEDIDO          NUMBER(10),
    ID_PRODUTO         NUMBER(10),
    NOME_PRODUTO       VARCHAR2(150),
    CATEGORIA          VARCHAR2(100),
    PRECO_UNITARIO     NUMBER(12,2),
    QUANTIDADE         NUMBER(10)
);

-- -----------------------------------------------------------------------------
-- 4. CONCORRENTE (Origem: Excel)
-- -----------------------------------------------------------------------------
CREATE TABLE STG_CONCORRENTE_VENDAS (
    ANO         NUMBER(4)     NOT NULL,
    MES         VARCHAR2(10)  NOT NULL,
    VENDAS      NUMBER(14,2)  NOT NULL
);

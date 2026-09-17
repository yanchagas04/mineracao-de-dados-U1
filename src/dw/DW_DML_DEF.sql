-- ---------------------------------------------------------
-- 1. INSERTS DIMENSÕES
-- ---------------------------------------------------------

-- ---------------------------------------------------------
-- 1.1. INSERT ESTADO CIVIL
-- ---------------------------------------------------------

INSERT INTO public.dim_estado_civil (estado_civil) VALUES
	 ('Casado(a)'),
	 ('Divorciado(a)'),
	 ('Não Informado'),
	 ('Solteiro(a)'),
	 ('União Estável'),
	 ('Viúvo(a)');

-- ---------------------------------------------------------
-- 1.2. INSERT LOJA
-- ---------------------------------------------------------

INSERT INTO public.dim_loja (nome_loja,cidade,estado,tipo_unidade,sistema_origem) VALUES
	 ('Pet Shop Nosso Aumigo - Matriz Salvador','Salvador','BA','Matriz','Oracle (C##PETSHOP)'),
	 ('Pet Shop Nosso Aumigo - Filial Itabuna','Itabuna','BA','Filial','PostgreSQL (Supabase)'),
	 ('Pet Shop Nosso Aumigo - Filial Feira de Santana','Feira de Santana','BA','Filial','MongoDB');

-- ---------------------------------------------------------
-- 1.3. INSERT PRODUTO (TRATADO CARACTERES NÃO RENDERIZADOS CORRETAMENTE)
-- ---------------------------------------------------------

INSERT INTO public.dim_produto (id_origem,nome_produto,categoria) VALUES
	 (1,'Racao Premium Caes','Rações'),
	 (2,'Racao Premium Gatos','Rações'),
	 (3,'Antipulgas','Medicamentos'),
	 (4,'Vermifugo','Medicamentos'),
	 (5,'Coleira Nylon','Acessórios'),
	 (6,'Guia Retratil','Acessórios'),
	 (7,'Bola Borracha','Brinquedos'),
	 (8,'Corda Mordedor','Brinquedos'),
	 (9,'Shampoo Pet','Higiene'),
	 (10,'Petisco Bifinho','Petiscos');
INSERT INTO public.dim_produto (id_origem,nome_produto,categoria) VALUES
	 (11,'Cama Luxo','Camas'),
	 (12,'Comedouro Inox','Comedouros'),
	 (13,'Tapete Higienico Premium','Higiene'),
	 (14,'Osso Mastigavel Natural','Petiscos'),
	 (15,'Bebedouro Automatico','Acessórios'),
	 (16,'Escova Para Pelos','Higiene'),
	 (17,'Caixa De Transporte','Acessórios');

-- ---------------------------------------------------------
-- 1.4. INSERT TEMPO
-- ---------------------------------------------------------

INSERT INTO public.dim_tempo (ano,quadrimestre) VALUES
	 (2024,1),
	 (2024,2),
	 (2024,3),
	 (2025,1),
	 (2025,2),
	 (2025,3);

-- ---------------------------------------------------------
-- 2. INSERTS FATOS
-- ---------------------------------------------------------

-- ---------------------------------------------------------
-- 2.1. INSERT VENDAS CONCORRENTE
-- ---------------------------------------------------------

INSERT INTO public.fato_vendas_concorrente (sk_tempo,valor) VALUES
	 (1,760000.00),
	 (2,862000.00),
	 (3,1123000.00),
	 (4,881000.00),
	 (5,1013000.00),
	 (6,1344000.00);

-- ---------------------------------------------------------
-- 2.2. INSERT VENDAS
-- ---------------------------------------------------------

INSERT INTO public.fato_vendas (sk_tempo,sk_estado_civil,sk_produto,sk_loja,quantidade_vendida,valor_total_venda) VALUES
	 (1,1,1,1,13,1688.70),
	 (1,1,1,2,11,844.14),
	 (1,1,2,1,28,3357.20),
	 (1,1,2,3,10,1199.00),
	 (1,1,3,1,5,399.50),
	 (1,1,3,2,5,457.55),
	 (1,1,3,3,6,479.40),
	 (1,1,4,1,2,99.80),
	 (1,1,4,2,10,1531.44),
	 (1,1,4,3,2,99.80);
INSERT INTO public.fato_vendas (sk_tempo,sk_estado_civil,sk_produto,sk_loja,quantidade_vendida,valor_total_venda) VALUES
	 (1,1,5,1,9,269.10),
	 (1,1,5,3,14,418.60),
	 (1,1,6,1,20,1318.00),
	 (1,1,6,2,8,1183.10),
	 (1,1,7,1,1,19.90),
	 (1,1,7,3,5,99.50),
	 (1,1,8,1,24,597.60),
	 (1,1,8,2,24,2893.14),
	 (1,1,8,3,10,249.00),
	 (1,1,9,1,8,279.20);
INSERT INTO public.fato_vendas (sk_tempo,sk_estado_civil,sk_produto,sk_loja,quantidade_vendida,valor_total_venda) VALUES
	 (1,1,9,2,8,868.87),
	 (1,1,9,3,7,244.30),
	 (1,1,10,1,33,491.70),
	 (1,1,10,2,13,1477.10),
	 (1,1,10,3,4,59.60),
	 (1,1,11,1,12,1798.80),
	 (1,1,11,2,13,1481.62),
	 (1,1,12,1,11,438.90),
	 (1,1,12,3,2,79.80),
	 (1,1,13,1,16,1438.40);
INSERT INTO public.fato_vendas (sk_tempo,sk_estado_civil,sk_produto,sk_loja,quantidade_vendida,valor_total_venda) VALUES
	 (1,1,13,2,15,1041.85),
	 (1,1,14,1,5,122.50),
	 (1,1,14,2,20,1635.03),
	 (1,1,14,3,6,147.00),
	 (1,1,15,2,5,519.08),
	 (1,1,16,1,1,18.90),
	 (1,1,16,2,14,1679.25),
	 (1,1,17,1,4,639.60),
	 (1,1,17,2,13,1502.20),
	 (1,1,17,3,5,799.50);
INSERT INTO public.fato_vendas (sk_tempo,sk_estado_civil,sk_produto,sk_loja,quantidade_vendida,valor_total_venda) VALUES
	 (1,2,1,1,35,4546.50),
	 (1,2,1,2,19,1691.14),
	 (1,2,1,3,11,1428.90),
	 (1,2,2,1,24,2877.60),
	 (1,2,2,3,9,1079.10),
	 (1,2,3,1,21,1677.90),
	 (1,2,3,2,12,1273.23),
	 (1,2,3,3,7,559.30),
	 (1,2,4,1,14,698.60),
	 (1,2,4,2,13,768.06);
INSERT INTO public.fato_vendas (sk_tempo,sk_estado_civil,sk_produto,sk_loja,quantidade_vendida,valor_total_venda) VALUES
	 (1,2,4,3,8,399.20),
	 (1,2,5,1,32,956.80),
	 (1,2,5,3,3,89.70),
	 (1,2,6,1,16,1054.40),
	 (1,2,6,2,20,1912.68),
	 (1,2,6,3,16,1054.40),
	 (1,2,7,1,13,258.70),
	 (1,2,7,3,7,139.30),
	 (1,2,8,1,17,423.30),
	 (1,2,8,2,16,1831.78);
INSERT INTO public.fato_vendas (sk_tempo,sk_estado_civil,sk_produto,sk_loja,quantidade_vendida,valor_total_venda) VALUES
	 (1,2,8,3,9,224.10),
	 (1,2,9,1,4,139.60),
	 (1,2,9,2,12,899.41),
	 (1,2,9,3,6,209.40),
	 (1,2,10,1,30,447.00),
	 (1,2,10,2,14,531.68),
	 (1,2,10,3,7,104.30),
	 (1,2,11,1,1,149.90),
	 (1,2,11,2,6,601.66),
	 (1,2,11,3,19,2848.10);
INSERT INTO public.fato_vendas (sk_tempo,sk_estado_civil,sk_produto,sk_loja,quantidade_vendida,valor_total_venda) VALUES
	 (1,2,12,1,7,279.30),
	 (1,2,12,3,11,438.90),
	 (1,2,13,1,4,359.60),
	 (1,2,13,2,8,1057.13),
	 (1,2,13,3,12,1078.80),
	 (1,2,14,1,9,220.50),
	 (1,2,14,2,2,190.94),
	 (1,2,14,3,10,245.00),
	 (1,2,15,1,6,719.40),
	 (1,2,15,2,9,1201.77);
INSERT INTO public.fato_vendas (sk_tempo,sk_estado_civil,sk_produto,sk_loja,quantidade_vendida,valor_total_venda) VALUES
	 (1,2,16,1,5,94.50),
	 (1,2,16,2,16,2610.69),
	 (1,2,17,1,4,639.60),
	 (1,2,17,2,5,415.46),
	 (1,2,17,3,7,1119.30),
	 (1,3,1,3,4,519.60),
	 (1,3,2,3,3,359.70),
	 (1,3,3,3,4,319.60),
	 (1,3,4,3,9,449.10),
	 (1,3,7,3,5,99.50);
INSERT INTO public.fato_vendas (sk_tempo,sk_estado_civil,sk_produto,sk_loja,quantidade_vendida,valor_total_venda) VALUES
	 (1,3,9,3,2,69.80),
	 (1,3,10,3,4,59.60),
	 (1,3,11,3,2,299.80),
	 (1,3,12,3,10,399.00),
	 (1,3,13,3,6,539.40),
	 (1,3,17,3,2,319.80),
	 (1,4,1,1,26,3377.40),
	 (1,4,1,2,8,757.75),
	 (1,4,1,3,6,779.40),
	 (1,4,2,1,26,3117.40);
INSERT INTO public.fato_vendas (sk_tempo,sk_estado_civil,sk_produto,sk_loja,quantidade_vendida,valor_total_venda) VALUES
	 (1,4,2,3,6,719.40),
	 (1,4,3,1,8,639.20),
	 (1,4,3,2,3,387.36),
	 (1,4,3,3,2,159.80),
	 (1,4,4,1,15,748.50),
	 (1,4,4,2,14,1215.08),
	 (1,4,4,3,5,249.50),
	 (1,4,5,1,17,508.30),
	 (1,4,5,3,1,29.90),
	 (1,4,6,1,17,1120.30);
INSERT INTO public.fato_vendas (sk_tempo,sk_estado_civil,sk_produto,sk_loja,quantidade_vendida,valor_total_venda) VALUES
	 (1,4,6,2,12,701.10),
	 (1,4,6,3,6,395.40),
	 (1,4,7,1,14,278.60),
	 (1,4,7,3,2,39.80),
	 (1,4,8,1,6,149.40),
	 (1,4,8,2,15,1842.91),
	 (1,4,8,3,8,199.20),
	 (1,4,9,1,21,732.90),
	 (1,4,9,2,9,586.54),
	 (1,4,9,3,2,69.80);
INSERT INTO public.fato_vendas (sk_tempo,sk_estado_civil,sk_produto,sk_loja,quantidade_vendida,valor_total_venda) VALUES
	 (1,4,10,1,25,372.50),
	 (1,4,10,2,13,567.51),
	 (1,4,10,3,2,29.80),
	 (1,4,11,1,7,1049.30),
	 (1,4,11,2,10,748.87),
	 (1,4,11,3,1,149.90),
	 (1,4,12,1,5,199.50),
	 (1,4,12,3,2,79.80),
	 (1,4,13,1,5,449.50),
	 (1,4,13,2,34,3824.72);
INSERT INTO public.fato_vendas (sk_tempo,sk_estado_civil,sk_produto,sk_loja,quantidade_vendida,valor_total_venda) VALUES
	 (1,4,13,3,9,809.10),
	 (1,4,14,1,4,98.00),
	 (1,4,14,2,13,1406.42),
	 (1,4,14,3,3,73.50),
	 (1,4,15,1,11,1318.90),
	 (1,4,15,2,9,1168.11),
	 (1,4,16,1,1,18.90),
	 (1,4,16,2,15,1996.78),
	 (1,4,17,1,3,479.70),
	 (1,4,17,2,12,1183.10);
INSERT INTO public.fato_vendas (sk_tempo,sk_estado_civil,sk_produto,sk_loja,quantidade_vendida,valor_total_venda) VALUES
	 (1,4,17,3,8,1279.20),
	 (1,5,1,1,42,5455.80),
	 (1,5,1,2,18,2552.70),
	 (1,5,1,3,7,909.30),
	 (1,5,2,1,35,4196.50),
	 (1,5,2,3,7,839.30),
	 (1,5,3,1,4,319.60),
	 (1,5,3,2,16,1060.61),
	 (1,5,3,3,7,559.30),
	 (1,5,4,1,20,998.00);
INSERT INTO public.fato_vendas (sk_tempo,sk_estado_civil,sk_produto,sk_loja,quantidade_vendida,valor_total_venda) VALUES
	 (1,5,4,2,27,3424.08),
	 (1,5,4,3,11,548.90),
	 (1,5,5,1,16,478.40),
	 (1,5,5,3,5,149.50),
	 (1,5,6,1,37,2438.30),
	 (1,5,6,2,4,772.36),
	 (1,5,6,3,6,395.40),
	 (1,5,7,1,18,358.20),
	 (1,5,7,3,9,179.10),
	 (1,5,8,1,11,273.90);
INSERT INTO public.fato_vendas (sk_tempo,sk_estado_civil,sk_produto,sk_loja,quantidade_vendida,valor_total_venda) VALUES
	 (1,5,8,2,16,2012.27),
	 (1,5,8,3,3,74.70),
	 (1,5,9,2,13,1350.82),
	 (1,5,9,3,17,593.30),
	 (1,5,10,1,31,461.90),
	 (1,5,10,2,9,661.19),
	 (1,5,10,3,13,193.70),
	 (1,5,11,1,10,1499.00),
	 (1,5,11,2,12,1352.65),
	 (1,5,11,3,19,2848.10);
INSERT INTO public.fato_vendas (sk_tempo,sk_estado_civil,sk_produto,sk_loja,quantidade_vendida,valor_total_venda) VALUES
	 (1,5,12,1,5,199.50),
	 (1,5,12,3,13,518.70),
	 (1,5,13,1,5,449.50),
	 (1,5,13,2,40,5055.57),
	 (1,5,13,3,10,899.00),
	 (1,5,14,1,16,392.00),
	 (1,5,14,2,11,1009.06),
	 (1,5,14,3,13,318.50),
	 (1,5,15,1,20,2398.00),
	 (1,5,15,2,13,1978.71);
INSERT INTO public.fato_vendas (sk_tempo,sk_estado_civil,sk_produto,sk_loja,quantidade_vendida,valor_total_venda) VALUES
	 (1,5,16,1,3,56.70),
	 (1,5,16,2,9,440.12),
	 (1,5,17,1,10,1599.00),
	 (1,5,17,2,11,1648.40),
	 (1,5,17,3,16,2558.40),
	 (1,6,1,1,32,4156.80),
	 (1,6,1,2,12,1231.34),
	 (1,6,1,3,8,1039.20),
	 (1,6,2,1,25,2997.50),
	 (1,6,2,3,8,959.20);
INSERT INTO public.fato_vendas (sk_tempo,sk_estado_civil,sk_produto,sk_loja,quantidade_vendida,valor_total_venda) VALUES
	 (1,6,3,1,22,1757.80),
	 (1,6,3,2,8,588.46),
	 (1,6,3,3,8,639.20),
	 (1,6,4,1,7,349.30),
	 (1,6,4,2,19,2313.11),
	 (1,6,4,3,3,149.70),
	 (1,6,5,1,14,418.60),
	 (1,6,5,3,4,119.60),
	 (1,6,6,1,16,1054.40),
	 (1,6,6,2,16,1854.10);
INSERT INTO public.fato_vendas (sk_tempo,sk_estado_civil,sk_produto,sk_loja,quantidade_vendida,valor_total_venda) VALUES
	 (1,6,6,3,7,461.30),
	 (1,6,7,1,4,79.60),
	 (1,6,7,3,5,99.50),
	 (1,6,8,1,7,174.30),
	 (1,6,8,2,12,1450.34),
	 (1,6,8,3,5,124.50),
	 (1,6,9,1,9,314.10),
	 (1,6,9,2,7,717.53),
	 (1,6,9,3,4,139.60),
	 (1,6,10,1,56,834.40);
INSERT INTO public.fato_vendas (sk_tempo,sk_estado_civil,sk_produto,sk_loja,quantidade_vendida,valor_total_venda) VALUES
	 (1,6,10,2,6,534.24),
	 (1,6,10,3,1,14.90),
	 (1,6,11,1,8,1199.20),
	 (1,6,11,2,8,544.50),
	 (1,6,11,3,5,749.50),
	 (1,6,12,1,13,518.70),
	 (1,6,12,3,7,279.30),
	 (1,6,13,1,11,988.90),
	 (1,6,13,2,24,3250.44),
	 (1,6,13,3,4,359.60);
INSERT INTO public.fato_vendas (sk_tempo,sk_estado_civil,sk_produto,sk_loja,quantidade_vendida,valor_total_venda) VALUES
	 (1,6,14,1,2,49.00),
	 (1,6,14,2,6,929.44),
	 (1,6,14,3,5,122.50),
	 (1,6,15,1,1,119.90),
	 (1,6,15,2,10,1123.56),
	 (1,6,16,1,6,113.40),
	 (1,6,16,2,8,743.82),
	 (1,6,17,1,7,1119.30),
	 (1,6,17,2,5,663.39),
	 (2,1,1,1,3,389.70);
INSERT INTO public.fato_vendas (sk_tempo,sk_estado_civil,sk_produto,sk_loja,quantidade_vendida,valor_total_venda) VALUES
	 (2,1,1,2,10,744.01),
	 (2,1,1,3,10,1299.00),
	 (2,1,2,1,16,1918.40),
	 (2,1,2,3,12,1438.80),
	 (2,1,3,1,8,639.20),
	 (2,1,3,2,2,281.75),
	 (2,1,3,3,8,639.20),
	 (2,1,4,1,7,349.30),
	 (2,1,4,2,8,1105.13),
	 (2,1,4,3,12,598.80);
INSERT INTO public.fato_vendas (sk_tempo,sk_estado_civil,sk_produto,sk_loja,quantidade_vendida,valor_total_venda) VALUES
	 (2,1,5,1,19,568.10),
	 (2,1,5,3,8,239.20),
	 (2,1,6,1,8,527.20),
	 (2,1,6,2,5,228.75),
	 (2,1,6,3,15,988.50),
	 (2,1,7,1,8,159.20),
	 (2,1,8,1,9,224.10),
	 (2,1,8,2,7,418.56),
	 (2,1,8,3,17,423.30),
	 (2,1,9,1,7,244.30);
INSERT INTO public.fato_vendas (sk_tempo,sk_estado_civil,sk_produto,sk_loja,quantidade_vendida,valor_total_venda) VALUES
	 (2,1,9,2,6,541.89),
	 (2,1,9,3,2,69.80),
	 (2,1,10,1,36,536.40),
	 (2,1,10,2,1,130.74),
	 (2,1,10,3,5,74.50),
	 (2,1,11,1,1,149.90),
	 (2,1,11,2,6,665.04),
	 (2,1,11,3,9,1349.10),
	 (2,1,12,1,2,79.80),
	 (2,1,12,3,11,438.90);
INSERT INTO public.fato_vendas (sk_tempo,sk_estado_civil,sk_produto,sk_loja,quantidade_vendida,valor_total_venda) VALUES
	 (2,1,13,1,4,359.60),
	 (2,1,13,2,28,3675.59),
	 (2,1,13,3,14,1258.60),
	 (2,1,14,1,3,73.50),
	 (2,1,14,2,7,884.84),
	 (2,1,14,3,6,147.00),
	 (2,1,15,1,2,239.80),
	 (2,1,15,2,3,333.72),
	 (2,1,16,1,1,18.90),
	 (2,1,16,2,6,471.97);
INSERT INTO public.fato_vendas (sk_tempo,sk_estado_civil,sk_produto,sk_loja,quantidade_vendida,valor_total_venda) VALUES
	 (2,1,17,2,6,741.24),
	 (2,1,17,3,12,1918.80),
	 (2,2,1,1,39,5066.10),
	 (2,2,1,2,11,1108.72),
	 (2,2,1,3,10,1299.00),
	 (2,2,2,1,33,3956.70),
	 (2,2,2,3,5,599.50),
	 (2,2,3,1,16,1278.40),
	 (2,2,3,2,13,1585.87),
	 (2,2,3,3,15,1198.50);
INSERT INTO public.fato_vendas (sk_tempo,sk_estado_civil,sk_produto,sk_loja,quantidade_vendida,valor_total_venda) VALUES
	 (2,2,4,1,12,598.80),
	 (2,2,4,2,4,748.88),
	 (2,2,4,3,28,1397.20),
	 (2,2,5,1,22,657.80),
	 (2,2,5,3,3,89.70),
	 (2,2,6,1,5,329.50),
	 (2,2,6,2,10,1334.49),
	 (2,2,6,3,11,724.90),
	 (2,2,7,1,11,218.90),
	 (2,2,7,3,1,19.90);
INSERT INTO public.fato_vendas (sk_tempo,sk_estado_civil,sk_produto,sk_loja,quantidade_vendida,valor_total_venda) VALUES
	 (2,2,8,1,13,323.70),
	 (2,2,8,2,19,2399.94),
	 (2,2,8,3,15,373.50),
	 (2,2,9,1,10,349.00),
	 (2,2,9,2,6,613.12),
	 (2,2,9,3,3,104.70),
	 (2,2,10,1,32,476.80),
	 (2,2,10,2,20,1808.55),
	 (2,2,10,3,9,134.10),
	 (2,2,11,1,2,299.80);
INSERT INTO public.fato_vendas (sk_tempo,sk_estado_civil,sk_produto,sk_loja,quantidade_vendida,valor_total_venda) VALUES
	 (2,2,11,2,5,239.40),
	 (2,2,11,3,7,1049.30),
	 (2,2,12,1,8,319.20),
	 (2,2,12,3,5,199.50),
	 (2,2,13,1,13,1168.70),
	 (2,2,13,2,9,1296.91),
	 (2,2,13,3,15,1348.50),
	 (2,2,14,1,6,147.00),
	 (2,2,14,2,4,760.76),
	 (2,2,14,3,7,171.50);
INSERT INTO public.fato_vendas (sk_tempo,sk_estado_civil,sk_produto,sk_loja,quantidade_vendida,valor_total_venda) VALUES
	 (2,2,15,1,10,1199.00),
	 (2,2,15,2,9,1401.43),
	 (2,2,16,1,7,132.30),
	 (2,2,16,2,7,1158.80),
	 (2,2,17,1,8,1279.20),
	 (2,2,17,2,4,489.01),
	 (2,3,1,3,5,649.50),
	 (2,3,2,3,13,1558.70),
	 (2,3,3,3,1,79.90),
	 (2,3,4,3,5,249.50);
INSERT INTO public.fato_vendas (sk_tempo,sk_estado_civil,sk_produto,sk_loja,quantidade_vendida,valor_total_venda) VALUES
	 (2,3,5,3,2,59.80),
	 (2,3,6,3,10,659.00),
	 (2,3,7,3,10,199.00),
	 (2,3,9,3,3,104.70),
	 (2,3,10,3,3,44.70),
	 (2,3,11,3,4,599.60),
	 (2,3,12,3,10,399.00),
	 (2,3,13,3,7,629.30),
	 (2,3,14,3,6,147.00),
	 (2,3,17,3,11,1758.90);
INSERT INTO public.fato_vendas (sk_tempo,sk_estado_civil,sk_produto,sk_loja,quantidade_vendida,valor_total_venda) VALUES
	 (2,4,1,1,21,2727.90),
	 (2,4,1,2,18,1746.71),
	 (2,4,1,3,6,779.40),
	 (2,4,2,1,12,1438.80),
	 (2,4,2,3,2,239.80),
	 (2,4,3,1,15,1198.50),
	 (2,4,3,2,16,1684.58),
	 (2,4,3,3,11,878.90),
	 (2,4,4,1,16,798.40),
	 (2,4,4,2,18,2211.39);
INSERT INTO public.fato_vendas (sk_tempo,sk_estado_civil,sk_produto,sk_loja,quantidade_vendida,valor_total_venda) VALUES
	 (2,4,4,3,5,249.50),
	 (2,4,5,1,19,568.10),
	 (2,4,5,3,4,119.60),
	 (2,4,6,1,12,790.80),
	 (2,4,6,2,18,1302.58),
	 (2,4,6,3,6,395.40),
	 (2,4,7,1,3,59.70),
	 (2,4,7,3,4,79.60),
	 (2,4,8,2,29,2820.89),
	 (2,4,8,3,10,249.00);
INSERT INTO public.fato_vendas (sk_tempo,sk_estado_civil,sk_produto,sk_loja,quantidade_vendida,valor_total_venda) VALUES
	 (2,4,9,1,17,593.30),
	 (2,4,9,2,3,233.70),
	 (2,4,9,3,8,279.20),
	 (2,4,10,1,24,357.60),
	 (2,4,10,2,20,2507.85),
	 (2,4,10,3,2,29.80),
	 (2,4,11,2,3,337.53),
	 (2,4,12,3,10,399.00),
	 (2,4,13,1,11,988.90),
	 (2,4,13,2,38,5147.00);
INSERT INTO public.fato_vendas (sk_tempo,sk_estado_civil,sk_produto,sk_loja,quantidade_vendida,valor_total_venda) VALUES
	 (2,4,13,3,16,1438.40),
	 (2,4,14,1,6,147.00),
	 (2,4,14,2,22,2112.08),
	 (2,4,14,3,3,73.50),
	 (2,4,15,2,13,1333.90),
	 (2,4,16,1,3,56.70),
	 (2,4,16,2,14,1002.06),
	 (2,4,17,1,3,479.70),
	 (2,4,17,2,7,572.05),
	 (2,4,17,3,15,2398.50);
INSERT INTO public.fato_vendas (sk_tempo,sk_estado_civil,sk_produto,sk_loja,quantidade_vendida,valor_total_venda) VALUES
	 (2,5,1,1,34,4416.60),
	 (2,5,1,2,13,1684.30),
	 (2,5,1,3,2,259.80),
	 (2,5,2,1,14,1678.60),
	 (2,5,2,3,2,239.80),
	 (2,5,3,1,8,639.20),
	 (2,5,3,2,4,438.64),
	 (2,5,3,3,4,319.60),
	 (2,5,4,1,8,399.20),
	 (2,5,4,2,5,710.68);
INSERT INTO public.fato_vendas (sk_tempo,sk_estado_civil,sk_produto,sk_loja,quantidade_vendida,valor_total_venda) VALUES
	 (2,5,4,3,9,449.10),
	 (2,5,5,1,8,239.20),
	 (2,5,5,3,5,149.50),
	 (2,5,6,1,26,1713.40),
	 (2,5,6,2,1,65.06),
	 (2,5,6,3,7,461.30),
	 (2,5,7,1,9,179.10),
	 (2,5,7,3,1,19.90),
	 (2,5,8,1,11,273.90),
	 (2,5,8,2,8,853.81);
INSERT INTO public.fato_vendas (sk_tempo,sk_estado_civil,sk_produto,sk_loja,quantidade_vendida,valor_total_venda) VALUES
	 (2,5,8,3,4,99.60),
	 (2,5,9,1,10,349.00),
	 (2,5,9,2,4,658.73),
	 (2,5,10,1,30,447.00),
	 (2,5,10,2,4,361.83),
	 (2,5,10,3,18,268.20),
	 (2,5,11,1,7,1049.30),
	 (2,5,11,2,11,670.75),
	 (2,5,11,3,10,1499.00),
	 (2,5,12,1,2,79.80);
INSERT INTO public.fato_vendas (sk_tempo,sk_estado_civil,sk_produto,sk_loja,quantidade_vendida,valor_total_venda) VALUES
	 (2,5,12,3,1,39.90),
	 (2,5,13,1,3,269.70),
	 (2,5,13,2,14,1538.94),
	 (2,5,13,3,3,269.70),
	 (2,5,14,1,8,196.00),
	 (2,5,14,3,5,122.50),
	 (2,5,15,1,4,479.60),
	 (2,5,15,2,2,66.54),
	 (2,5,16,1,7,132.30),
	 (2,5,16,2,4,267.92);
INSERT INTO public.fato_vendas (sk_tempo,sk_estado_civil,sk_produto,sk_loja,quantidade_vendida,valor_total_venda) VALUES
	 (2,5,17,1,3,479.70),
	 (2,5,17,2,3,457.56),
	 (2,5,17,3,5,799.50),
	 (2,6,1,1,20,2598.00),
	 (2,6,1,2,8,506.04),
	 (2,6,1,3,4,519.60),
	 (2,6,2,1,28,3357.20),
	 (2,6,2,3,6,719.40),
	 (2,6,3,1,4,319.60),
	 (2,6,3,2,16,1978.91);
INSERT INTO public.fato_vendas (sk_tempo,sk_estado_civil,sk_produto,sk_loja,quantidade_vendida,valor_total_venda) VALUES
	 (2,6,3,3,15,1198.50),
	 (2,6,4,1,8,399.20),
	 (2,6,4,2,7,485.86),
	 (2,6,4,3,9,449.10),
	 (2,6,5,1,26,777.40),
	 (2,6,6,1,14,922.60),
	 (2,6,6,2,2,157.02),
	 (2,6,6,3,2,131.80),
	 (2,6,7,1,1,19.90),
	 (2,6,7,3,7,139.30);
INSERT INTO public.fato_vendas (sk_tempo,sk_estado_civil,sk_produto,sk_loja,quantidade_vendida,valor_total_venda) VALUES
	 (2,6,8,1,5,124.50),
	 (2,6,8,2,10,836.21),
	 (2,6,8,3,8,199.20),
	 (2,6,9,1,14,488.60),
	 (2,6,9,2,4,192.47),
	 (2,6,9,3,9,314.10),
	 (2,6,10,1,10,149.00),
	 (2,6,10,2,7,553.14),
	 (2,6,10,3,11,163.90),
	 (2,6,11,3,3,449.70);
INSERT INTO public.fato_vendas (sk_tempo,sk_estado_civil,sk_produto,sk_loja,quantidade_vendida,valor_total_venda) VALUES
	 (2,6,12,1,6,239.40),
	 (2,6,12,3,8,319.20),
	 (2,6,13,1,12,1078.80),
	 (2,6,13,2,16,1992.67),
	 (2,6,13,3,9,809.10),
	 (2,6,14,1,5,122.50),
	 (2,6,14,2,13,1392.45),
	 (2,6,14,3,14,343.00),
	 (2,6,15,1,4,479.60),
	 (2,6,15,2,5,807.08);
INSERT INTO public.fato_vendas (sk_tempo,sk_estado_civil,sk_produto,sk_loja,quantidade_vendida,valor_total_venda) VALUES
	 (2,6,16,1,7,132.30),
	 (2,6,16,2,4,193.47),
	 (2,6,17,1,3,479.70),
	 (2,6,17,2,8,528.08),
	 (2,6,17,3,10,1599.00),
	 (3,1,1,1,22,2857.80),
	 (3,1,1,2,7,576.92),
	 (3,1,1,3,6,779.40),
	 (3,1,2,1,53,6354.70),
	 (3,1,2,3,3,359.70);
INSERT INTO public.fato_vendas (sk_tempo,sk_estado_civil,sk_produto,sk_loja,quantidade_vendida,valor_total_venda) VALUES
	 (3,1,3,1,22,1757.80),
	 (3,1,3,2,12,1086.34),
	 (3,1,3,3,22,1757.80),
	 (3,1,4,1,22,1097.80),
	 (3,1,4,2,8,761.00),
	 (3,1,4,3,3,149.70),
	 (3,1,5,1,31,926.90),
	 (3,1,5,3,17,508.30),
	 (3,1,6,1,19,1252.10),
	 (3,1,6,2,3,110.16);
INSERT INTO public.fato_vendas (sk_tempo,sk_estado_civil,sk_produto,sk_loja,quantidade_vendida,valor_total_venda) VALUES
	 (3,1,6,3,15,988.50),
	 (3,1,7,1,5,99.50),
	 (3,1,7,3,9,179.10),
	 (3,1,8,1,14,348.60),
	 (3,1,8,2,3,205.74),
	 (3,1,8,3,10,249.00),
	 (3,1,9,1,40,1396.00),
	 (3,1,9,2,7,720.40),
	 (3,1,9,3,16,558.40),
	 (3,1,10,1,51,759.90);
INSERT INTO public.fato_vendas (sk_tempo,sk_estado_civil,sk_produto,sk_loja,quantidade_vendida,valor_total_venda) VALUES
	 (3,1,10,2,7,440.75),
	 (3,1,11,1,12,1798.80),
	 (3,1,11,2,4,586.00),
	 (3,1,11,3,9,1349.10),
	 (3,1,12,1,15,598.50),
	 (3,1,12,3,18,718.20),
	 (3,1,13,1,6,539.40),
	 (3,1,13,2,13,1331.74),
	 (3,1,13,3,4,359.60),
	 (3,1,14,1,9,220.50);
INSERT INTO public.fato_vendas (sk_tempo,sk_estado_civil,sk_produto,sk_loja,quantidade_vendida,valor_total_venda) VALUES
	 (3,1,14,2,1,191.15),
	 (3,1,14,3,7,171.50),
	 (3,1,15,1,3,359.70),
	 (3,1,15,2,19,2474.22),
	 (3,1,16,1,15,283.50),
	 (3,1,16,2,1,183.91),
	 (3,1,17,1,7,1119.30),
	 (3,1,17,2,3,52.47),
	 (3,1,17,3,10,1599.00),
	 (3,2,1,1,74,9612.60);
INSERT INTO public.fato_vendas (sk_tempo,sk_estado_civil,sk_produto,sk_loja,quantidade_vendida,valor_total_venda) VALUES
	 (3,2,1,2,6,722.47),
	 (3,2,1,3,20,2598.00),
	 (3,2,2,1,51,6114.90),
	 (3,2,3,1,14,1118.60),
	 (3,2,3,2,2,35.40),
	 (3,2,3,3,4,319.60),
	 (3,2,4,1,14,698.60),
	 (3,2,4,2,4,235.74),
	 (3,2,4,3,7,349.30),
	 (3,2,5,1,29,867.10);
INSERT INTO public.fato_vendas (sk_tempo,sk_estado_civil,sk_produto,sk_loja,quantidade_vendida,valor_total_venda) VALUES
	 (3,2,5,3,9,269.10),
	 (3,2,6,1,23,1515.70),
	 (3,2,6,2,4,49.28),
	 (3,2,6,3,2,131.80),
	 (3,2,7,1,28,557.20),
	 (3,2,7,3,3,59.70),
	 (3,2,8,1,26,647.40),
	 (3,2,8,2,20,1408.25),
	 (3,2,8,3,17,423.30),
	 (3,2,9,1,24,837.60);
INSERT INTO public.fato_vendas (sk_tempo,sk_estado_civil,sk_produto,sk_loja,quantidade_vendida,valor_total_venda) VALUES
	 (3,2,9,2,12,1531.08),
	 (3,2,9,3,11,383.90),
	 (3,2,10,1,24,357.60),
	 (3,2,10,2,1,165.31),
	 (3,2,10,3,4,59.60),
	 (3,2,11,1,5,749.50),
	 (3,2,11,2,10,1307.24),
	 (3,2,11,3,7,1049.30),
	 (3,2,12,1,10,399.00),
	 (3,2,12,3,9,359.10);
INSERT INTO public.fato_vendas (sk_tempo,sk_estado_civil,sk_produto,sk_loja,quantidade_vendida,valor_total_venda) VALUES
	 (3,2,13,1,2,179.80),
	 (3,2,13,2,17,2088.07),
	 (3,2,13,3,5,449.50),
	 (3,2,14,1,19,465.50),
	 (3,2,14,2,12,617.38),
	 (3,2,14,3,10,245.00),
	 (3,2,15,1,1,119.90),
	 (3,2,15,2,6,429.01),
	 (3,2,16,1,25,472.50),
	 (3,2,16,2,5,685.73);
INSERT INTO public.fato_vendas (sk_tempo,sk_estado_civil,sk_produto,sk_loja,quantidade_vendida,valor_total_venda) VALUES
	 (3,2,17,1,9,1439.10),
	 (3,2,17,2,6,315.60),
	 (3,2,17,3,7,1119.30),
	 (3,3,1,3,3,389.70),
	 (3,3,2,3,11,1318.90),
	 (3,3,3,3,5,399.50),
	 (3,3,4,3,6,299.40),
	 (3,3,5,3,6,179.40),
	 (3,3,6,3,11,724.90),
	 (3,3,7,3,4,79.60);
INSERT INTO public.fato_vendas (sk_tempo,sk_estado_civil,sk_produto,sk_loja,quantidade_vendida,valor_total_venda) VALUES
	 (3,3,8,3,4,99.60),
	 (3,3,9,3,2,69.80),
	 (3,3,10,3,3,44.70),
	 (3,3,11,3,7,1049.30),
	 (3,3,12,3,11,438.90),
	 (3,3,13,3,2,179.80),
	 (3,3,14,3,10,245.00),
	 (3,3,17,3,5,799.50),
	 (3,4,1,1,58,7534.20),
	 (3,4,1,2,17,1974.21);
INSERT INTO public.fato_vendas (sk_tempo,sk_estado_civil,sk_produto,sk_loja,quantidade_vendida,valor_total_venda) VALUES
	 (3,4,1,3,15,1948.50),
	 (3,4,2,1,53,6354.70),
	 (3,4,2,3,9,1079.10),
	 (3,4,3,1,32,2556.80),
	 (3,4,3,2,20,2656.69),
	 (3,4,3,3,2,159.80),
	 (3,4,4,1,10,499.00),
	 (3,4,4,2,15,1183.34),
	 (3,4,4,3,5,249.50),
	 (3,4,5,1,30,897.00);
INSERT INTO public.fato_vendas (sk_tempo,sk_estado_civil,sk_produto,sk_loja,quantidade_vendida,valor_total_venda) VALUES
	 (3,4,5,3,3,89.70),
	 (3,4,6,1,6,395.40),
	 (3,4,6,2,41,5659.39),
	 (3,4,6,3,12,790.80),
	 (3,4,7,1,31,616.90),
	 (3,4,7,3,17,338.30),
	 (3,4,8,1,16,398.40),
	 (3,4,8,2,44,4270.09),
	 (3,4,8,3,7,174.30),
	 (3,4,9,1,24,837.60);
INSERT INTO public.fato_vendas (sk_tempo,sk_estado_civil,sk_produto,sk_loja,quantidade_vendida,valor_total_venda) VALUES
	 (3,4,9,2,16,1916.32),
	 (3,4,9,3,6,209.40),
	 (3,4,10,1,45,670.50),
	 (3,4,10,2,23,2022.32),
	 (3,4,10,3,9,134.10),
	 (3,4,11,1,20,2998.00),
	 (3,4,11,2,13,1763.41),
	 (3,4,11,3,19,2848.10),
	 (3,4,12,1,23,917.70),
	 (3,4,12,3,8,319.20);
INSERT INTO public.fato_vendas (sk_tempo,sk_estado_civil,sk_produto,sk_loja,quantidade_vendida,valor_total_venda) VALUES
	 (3,4,13,1,8,719.20),
	 (3,4,13,2,33,3413.69),
	 (3,4,13,3,20,1798.00),
	 (3,4,14,1,4,98.00),
	 (3,4,14,2,17,1939.34),
	 (3,4,14,3,17,416.50),
	 (3,4,15,1,6,719.40),
	 (3,4,15,2,10,1011.96),
	 (3,4,16,1,12,226.80),
	 (3,4,16,2,7,938.31);
INSERT INTO public.fato_vendas (sk_tempo,sk_estado_civil,sk_produto,sk_loja,quantidade_vendida,valor_total_venda) VALUES
	 (3,4,17,1,6,959.40),
	 (3,4,17,2,8,983.84),
	 (3,4,17,3,25,3997.50),
	 (3,5,1,1,53,6884.70),
	 (3,5,1,2,11,635.41),
	 (3,5,1,3,12,1558.80),
	 (3,5,2,1,41,4915.90),
	 (3,5,2,3,14,1678.60),
	 (3,5,3,1,20,1598.00),
	 (3,5,3,3,10,799.00);
INSERT INTO public.fato_vendas (sk_tempo,sk_estado_civil,sk_produto,sk_loja,quantidade_vendida,valor_total_venda) VALUES
	 (3,5,4,1,9,449.10),
	 (3,5,4,2,12,605.66),
	 (3,5,4,3,13,648.70),
	 (3,5,5,1,51,1524.90),
	 (3,5,5,3,11,328.90),
	 (3,5,6,1,11,724.90),
	 (3,5,6,2,8,531.67),
	 (3,5,6,3,10,659.00),
	 (3,5,7,1,6,119.40),
	 (3,5,7,3,18,358.20);
INSERT INTO public.fato_vendas (sk_tempo,sk_estado_civil,sk_produto,sk_loja,quantidade_vendida,valor_total_venda) VALUES
	 (3,5,8,1,18,448.20),
	 (3,5,8,2,23,2342.45),
	 (3,5,8,3,11,273.90),
	 (3,5,9,1,17,593.30),
	 (3,5,9,2,10,1080.46),
	 (3,5,9,3,16,558.40),
	 (3,5,10,1,59,879.10),
	 (3,5,10,2,15,1033.13),
	 (3,5,10,3,4,59.60),
	 (3,5,11,1,7,1049.30);
INSERT INTO public.fato_vendas (sk_tempo,sk_estado_civil,sk_produto,sk_loja,quantidade_vendida,valor_total_venda) VALUES
	 (3,5,11,2,17,1856.20),
	 (3,5,11,3,8,1199.20),
	 (3,5,12,1,6,239.40),
	 (3,5,12,3,11,438.90),
	 (3,5,13,1,13,1168.70),
	 (3,5,13,2,33,3626.84),
	 (3,5,13,3,15,1348.50),
	 (3,5,14,1,12,294.00),
	 (3,5,14,2,4,429.03),
	 (3,5,14,3,8,196.00);
INSERT INTO public.fato_vendas (sk_tempo,sk_estado_civil,sk_produto,sk_loja,quantidade_vendida,valor_total_venda) VALUES
	 (3,5,15,1,7,839.30),
	 (3,5,15,2,10,1264.76),
	 (3,5,16,1,7,132.30),
	 (3,5,16,2,14,1259.90),
	 (3,5,17,1,7,1119.30),
	 (3,5,17,2,2,146.48),
	 (3,5,17,3,17,2718.30),
	 (3,6,1,1,72,9352.80),
	 (3,6,1,2,11,900.33),
	 (3,6,2,1,68,8153.20);
INSERT INTO public.fato_vendas (sk_tempo,sk_estado_civil,sk_produto,sk_loja,quantidade_vendida,valor_total_venda) VALUES
	 (3,6,2,3,3,359.70),
	 (3,6,3,1,34,2716.60),
	 (3,6,3,2,8,648.81),
	 (3,6,3,3,19,1518.10),
	 (3,6,4,1,31,1546.90),
	 (3,6,4,2,6,631.00),
	 (3,6,4,3,4,199.60),
	 (3,6,5,1,35,1046.50),
	 (3,6,5,3,7,209.30),
	 (3,6,6,1,17,1120.30);
INSERT INTO public.fato_vendas (sk_tempo,sk_estado_civil,sk_produto,sk_loja,quantidade_vendida,valor_total_venda) VALUES
	 (3,6,6,2,7,633.59),
	 (3,6,6,3,2,131.80),
	 (3,6,7,1,35,696.50),
	 (3,6,7,3,11,218.90),
	 (3,6,8,1,24,597.60),
	 (3,6,8,2,16,1290.19),
	 (3,6,8,3,6,149.40),
	 (3,6,9,1,36,1256.40),
	 (3,6,9,2,8,1100.43),
	 (3,6,10,1,64,953.60);
INSERT INTO public.fato_vendas (sk_tempo,sk_estado_civil,sk_produto,sk_loja,quantidade_vendida,valor_total_venda) VALUES
	 (3,6,10,2,5,364.13),
	 (3,6,10,3,6,89.40),
	 (3,6,11,1,6,899.40),
	 (3,6,11,2,6,826.78),
	 (3,6,11,3,8,1199.20),
	 (3,6,12,1,14,558.60),
	 (3,6,12,3,3,119.70),
	 (3,6,13,1,25,2247.50),
	 (3,6,13,2,13,1163.75),
	 (3,6,13,3,14,1258.60);
INSERT INTO public.fato_vendas (sk_tempo,sk_estado_civil,sk_produto,sk_loja,quantidade_vendida,valor_total_venda) VALUES
	 (3,6,14,1,14,343.00),
	 (3,6,14,2,1,74.89),
	 (3,6,14,3,1,24.50),
	 (3,6,15,1,6,719.40),
	 (3,6,15,2,18,1642.35),
	 (3,6,16,1,18,340.20),
	 (3,6,16,2,9,1158.45),
	 (3,6,17,1,15,2398.50),
	 (3,6,17,2,10,695.41),
	 (3,6,17,3,7,1119.30);
INSERT INTO public.fato_vendas (sk_tempo,sk_estado_civil,sk_produto,sk_loja,quantidade_vendida,valor_total_venda) VALUES
	 (4,1,1,1,28,3637.20),
	 (4,1,1,2,4,176.80),
	 (4,1,1,3,9,1169.10),
	 (4,1,2,1,30,3597.00),
	 (4,1,2,3,12,1438.80),
	 (4,1,3,1,23,1837.70),
	 (4,1,3,3,15,1198.50),
	 (4,1,4,1,10,499.00),
	 (4,1,4,2,4,127.04),
	 (4,1,4,3,20,998.00);
INSERT INTO public.fato_vendas (sk_tempo,sk_estado_civil,sk_produto,sk_loja,quantidade_vendida,valor_total_venda) VALUES
	 (4,1,5,1,6,179.40),
	 (4,1,5,3,6,179.40),
	 (4,1,6,1,16,1054.40),
	 (4,1,6,2,10,1447.67),
	 (4,1,6,3,16,1054.40),
	 (4,1,7,1,8,159.20),
	 (4,1,7,3,9,179.10),
	 (4,1,8,1,8,199.20),
	 (4,1,8,2,27,3031.57),
	 (4,1,8,3,13,323.70);
INSERT INTO public.fato_vendas (sk_tempo,sk_estado_civil,sk_produto,sk_loja,quantidade_vendida,valor_total_venda) VALUES
	 (4,1,9,1,14,488.60),
	 (4,1,9,2,12,1101.16),
	 (4,1,9,3,10,349.00),
	 (4,1,10,1,37,551.30),
	 (4,1,10,2,12,942.67),
	 (4,1,10,3,9,134.10),
	 (4,1,11,2,2,380.40),
	 (4,1,11,3,15,2248.50),
	 (4,1,12,1,13,518.70),
	 (4,1,12,3,6,239.40);
INSERT INTO public.fato_vendas (sk_tempo,sk_estado_civil,sk_produto,sk_loja,quantidade_vendida,valor_total_venda) VALUES
	 (4,1,13,1,8,719.20),
	 (4,1,13,2,23,2110.87),
	 (4,1,13,3,15,1348.50),
	 (4,1,14,1,2,49.00),
	 (4,1,14,2,4,637.68),
	 (4,1,14,3,13,318.50),
	 (4,1,15,1,2,239.80),
	 (4,1,15,2,7,734.40),
	 (4,1,16,1,4,75.60),
	 (4,1,16,2,7,627.26);
INSERT INTO public.fato_vendas (sk_tempo,sk_estado_civil,sk_produto,sk_loja,quantidade_vendida,valor_total_venda) VALUES
	 (4,1,17,1,3,479.70),
	 (4,1,17,2,5,817.53),
	 (4,1,17,3,14,2238.60),
	 (4,2,1,1,42,5455.80),
	 (4,2,1,2,5,527.16),
	 (4,2,1,3,6,779.40),
	 (4,2,2,1,31,3716.90),
	 (4,2,2,3,1,119.90),
	 (4,2,3,1,17,1358.30),
	 (4,2,3,2,15,1751.41);
INSERT INTO public.fato_vendas (sk_tempo,sk_estado_civil,sk_produto,sk_loja,quantidade_vendida,valor_total_venda) VALUES
	 (4,2,3,3,3,239.70),
	 (4,2,4,1,15,748.50),
	 (4,2,4,2,1,55.86),
	 (4,2,4,3,9,449.10),
	 (4,2,5,1,34,1016.60),
	 (4,2,5,3,12,358.80),
	 (4,2,6,1,18,1186.20),
	 (4,2,6,2,11,1799.04),
	 (4,2,6,3,4,263.60),
	 (4,2,7,1,4,79.60);
INSERT INTO public.fato_vendas (sk_tempo,sk_estado_civil,sk_produto,sk_loja,quantidade_vendida,valor_total_venda) VALUES
	 (4,2,7,3,4,79.60),
	 (4,2,8,1,20,498.00),
	 (4,2,8,2,18,2072.14),
	 (4,2,8,3,5,124.50),
	 (4,2,9,1,16,558.40),
	 (4,2,9,2,14,1125.35),
	 (4,2,9,3,3,104.70),
	 (4,2,10,1,32,476.80),
	 (4,2,10,2,13,862.04),
	 (4,2,10,3,3,44.70);
INSERT INTO public.fato_vendas (sk_tempo,sk_estado_civil,sk_produto,sk_loja,quantidade_vendida,valor_total_venda) VALUES
	 (4,2,11,1,4,599.60),
	 (4,2,11,2,9,673.29),
	 (4,2,11,3,10,1499.00),
	 (4,2,12,1,11,438.90),
	 (4,2,12,3,15,598.50),
	 (4,2,13,1,14,1258.60),
	 (4,2,13,2,9,861.59),
	 (4,2,13,3,12,1078.80),
	 (4,2,14,1,15,367.50),
	 (4,2,14,2,15,1461.60);
INSERT INTO public.fato_vendas (sk_tempo,sk_estado_civil,sk_produto,sk_loja,quantidade_vendida,valor_total_venda) VALUES
	 (4,2,14,3,13,318.50),
	 (4,2,15,1,6,719.40),
	 (4,2,15,2,20,1406.05),
	 (4,2,16,1,7,132.30),
	 (4,2,16,2,17,1358.09),
	 (4,2,17,2,11,1189.09),
	 (4,2,17,3,5,799.50),
	 (4,3,1,3,11,1428.90),
	 (4,3,2,3,6,719.40),
	 (4,3,3,3,8,639.20);
INSERT INTO public.fato_vendas (sk_tempo,sk_estado_civil,sk_produto,sk_loja,quantidade_vendida,valor_total_venda) VALUES
	 (4,3,4,3,11,548.90),
	 (4,3,5,3,12,358.80),
	 (4,3,6,3,7,461.30),
	 (4,3,7,3,9,179.10),
	 (4,3,8,3,6,149.40),
	 (4,3,9,3,8,279.20),
	 (4,3,10,3,12,178.80),
	 (4,3,11,3,7,1049.30),
	 (4,3,12,3,7,279.30),
	 (4,3,13,3,3,269.70);
INSERT INTO public.fato_vendas (sk_tempo,sk_estado_civil,sk_produto,sk_loja,quantidade_vendida,valor_total_venda) VALUES
	 (4,3,14,3,6,147.00),
	 (4,3,17,3,4,639.60),
	 (4,4,1,1,43,5585.70),
	 (4,4,1,2,13,1866.24),
	 (4,4,1,3,4,519.60),
	 (4,4,2,1,24,2877.60),
	 (4,4,2,3,7,839.30),
	 (4,4,3,1,19,1518.10),
	 (4,4,3,2,13,1343.66),
	 (4,4,3,3,6,479.40);
INSERT INTO public.fato_vendas (sk_tempo,sk_estado_civil,sk_produto,sk_loja,quantidade_vendida,valor_total_venda) VALUES
	 (4,4,4,1,26,1297.40),
	 (4,4,4,2,14,1476.01),
	 (4,4,4,3,7,349.30),
	 (4,4,5,1,18,538.20),
	 (4,4,5,3,6,179.40),
	 (4,4,6,1,8,527.20),
	 (4,4,6,2,15,1087.93),
	 (4,4,7,1,15,298.50),
	 (4,4,7,3,6,119.40),
	 (4,4,8,1,26,647.40);
INSERT INTO public.fato_vendas (sk_tempo,sk_estado_civil,sk_produto,sk_loja,quantidade_vendida,valor_total_venda) VALUES
	 (4,4,8,2,20,1763.05),
	 (4,4,8,3,4,99.60),
	 (4,4,9,1,22,767.80),
	 (4,4,9,2,10,935.61),
	 (4,4,9,3,1,34.90),
	 (4,4,10,1,31,461.90),
	 (4,4,10,2,6,841.71),
	 (4,4,10,3,8,119.20),
	 (4,4,11,1,6,899.40),
	 (4,4,11,2,15,1821.15);
INSERT INTO public.fato_vendas (sk_tempo,sk_estado_civil,sk_produto,sk_loja,quantidade_vendida,valor_total_venda) VALUES
	 (4,4,11,3,5,749.50),
	 (4,4,12,1,3,119.70),
	 (4,4,12,3,5,199.50),
	 (4,4,13,1,4,359.60),
	 (4,4,13,2,25,2653.07),
	 (4,4,13,3,6,539.40),
	 (4,4,14,1,3,73.50),
	 (4,4,14,2,7,436.54),
	 (4,4,14,3,15,367.50),
	 (4,4,15,1,9,1079.10);
INSERT INTO public.fato_vendas (sk_tempo,sk_estado_civil,sk_produto,sk_loja,quantidade_vendida,valor_total_venda) VALUES
	 (4,4,15,2,14,1554.47),
	 (4,4,16,1,4,75.60),
	 (4,4,16,2,10,1318.59),
	 (4,4,17,2,8,280.42),
	 (4,4,17,3,4,639.60),
	 (4,5,1,1,15,1948.50),
	 (4,5,1,2,21,2219.91),
	 (4,5,1,3,7,909.30),
	 (4,5,2,1,26,3117.40),
	 (4,5,2,3,13,1558.70);
INSERT INTO public.fato_vendas (sk_tempo,sk_estado_civil,sk_produto,sk_loja,quantidade_vendida,valor_total_venda) VALUES
	 (4,5,3,1,6,479.40),
	 (4,5,3,2,19,2012.42),
	 (4,5,3,3,3,239.70),
	 (4,5,4,1,5,249.50),
	 (4,5,4,2,10,1743.76),
	 (4,5,4,3,16,798.40),
	 (4,5,5,1,21,627.90),
	 (4,5,5,3,12,358.80),
	 (4,5,6,1,1,65.90),
	 (4,5,6,2,9,1249.63);
INSERT INTO public.fato_vendas (sk_tempo,sk_estado_civil,sk_produto,sk_loja,quantidade_vendida,valor_total_venda) VALUES
	 (4,5,6,3,23,1515.70),
	 (4,5,7,1,3,59.70),
	 (4,5,7,3,12,238.80),
	 (4,5,8,1,4,99.60),
	 (4,5,8,2,24,2335.34),
	 (4,5,8,3,9,224.10),
	 (4,5,9,1,10,349.00),
	 (4,5,9,2,5,540.46),
	 (4,5,9,3,15,523.50),
	 (4,5,10,1,7,104.30);
INSERT INTO public.fato_vendas (sk_tempo,sk_estado_civil,sk_produto,sk_loja,quantidade_vendida,valor_total_venda) VALUES
	 (4,5,10,2,9,717.04),
	 (4,5,10,3,13,193.70),
	 (4,5,11,2,15,1329.51),
	 (4,5,11,3,21,3147.90),
	 (4,5,12,1,4,159.60),
	 (4,5,12,3,12,478.80),
	 (4,5,13,1,13,1168.70),
	 (4,5,13,2,32,3544.82),
	 (4,5,13,3,11,988.90),
	 (4,5,14,1,6,147.00);
INSERT INTO public.fato_vendas (sk_tempo,sk_estado_civil,sk_produto,sk_loja,quantidade_vendida,valor_total_venda) VALUES
	 (4,5,14,2,8,1226.07),
	 (4,5,14,3,15,367.50),
	 (4,5,15,1,7,839.30),
	 (4,5,15,2,28,3649.14),
	 (4,5,16,1,6,113.40),
	 (4,5,16,2,7,767.33),
	 (4,5,17,1,4,639.60),
	 (4,5,17,2,11,1511.08),
	 (4,5,17,3,4,639.60),
	 (4,6,1,1,45,5845.50);
INSERT INTO public.fato_vendas (sk_tempo,sk_estado_civil,sk_produto,sk_loja,quantidade_vendida,valor_total_venda) VALUES
	 (4,6,1,2,5,658.30),
	 (4,6,1,3,5,649.50),
	 (4,6,2,1,32,3836.80),
	 (4,6,2,3,7,839.30),
	 (4,6,3,1,22,1757.80),
	 (4,6,3,2,21,1523.03),
	 (4,6,3,3,5,399.50),
	 (4,6,4,1,11,548.90),
	 (4,6,4,2,1,42.52),
	 (4,6,4,3,7,349.30);
INSERT INTO public.fato_vendas (sk_tempo,sk_estado_civil,sk_produto,sk_loja,quantidade_vendida,valor_total_venda) VALUES
	 (4,6,5,1,26,777.40),
	 (4,6,5,3,7,209.30),
	 (4,6,6,1,6,395.40),
	 (4,6,6,2,5,435.43),
	 (4,6,6,3,5,329.50),
	 (4,6,7,1,8,159.20),
	 (4,6,7,3,1,19.90),
	 (4,6,8,1,20,498.00),
	 (4,6,8,2,8,494.09),
	 (4,6,8,3,1,24.90);
INSERT INTO public.fato_vendas (sk_tempo,sk_estado_civil,sk_produto,sk_loja,quantidade_vendida,valor_total_venda) VALUES
	 (4,6,9,1,8,279.20),
	 (4,6,9,2,5,623.95),
	 (4,6,9,3,7,244.30),
	 (4,6,10,1,19,283.10),
	 (4,6,10,2,8,1185.16),
	 (4,6,10,3,2,29.80),
	 (4,6,11,1,2,299.80),
	 (4,6,11,2,3,527.58),
	 (4,6,11,3,8,1199.20),
	 (4,6,12,1,6,239.40);
INSERT INTO public.fato_vendas (sk_tempo,sk_estado_civil,sk_produto,sk_loja,quantidade_vendida,valor_total_venda) VALUES
	 (4,6,12,3,6,239.40),
	 (4,6,13,1,8,719.20),
	 (4,6,13,2,17,1668.86),
	 (4,6,13,3,4,359.60),
	 (4,6,14,2,6,395.03),
	 (4,6,14,3,7,171.50),
	 (4,6,15,1,11,1318.90),
	 (4,6,15,2,14,786.76),
	 (4,6,16,1,10,189.00),
	 (4,6,16,2,13,832.69);
INSERT INTO public.fato_vendas (sk_tempo,sk_estado_civil,sk_produto,sk_loja,quantidade_vendida,valor_total_venda) VALUES
	 (4,6,17,1,18,2878.20),
	 (4,6,17,2,11,685.86),
	 (4,6,17,3,13,2078.70),
	 (5,1,1,1,16,2078.40),
	 (5,1,1,2,3,381.94),
	 (5,1,1,3,9,1169.10),
	 (5,1,2,1,17,2038.30),
	 (5,1,3,1,19,1518.10),
	 (5,1,3,2,6,654.40),
	 (5,1,3,3,9,719.10);
INSERT INTO public.fato_vendas (sk_tempo,sk_estado_civil,sk_produto,sk_loja,quantidade_vendida,valor_total_venda) VALUES
	 (5,1,4,1,1,49.90),
	 (5,1,4,2,6,1083.30),
	 (5,1,4,3,6,299.40),
	 (5,1,5,1,15,448.50),
	 (5,1,5,3,12,358.80),
	 (5,1,6,1,10,659.00),
	 (5,1,6,2,1,17.72),
	 (5,1,6,3,6,395.40),
	 (5,1,7,1,7,139.30),
	 (5,1,7,3,5,99.50);
INSERT INTO public.fato_vendas (sk_tempo,sk_estado_civil,sk_produto,sk_loja,quantidade_vendida,valor_total_venda) VALUES
	 (5,1,8,1,7,174.30),
	 (5,1,8,2,14,1765.56),
	 (5,1,8,3,8,199.20),
	 (5,1,9,1,5,174.50),
	 (5,1,9,2,12,1221.60),
	 (5,1,9,3,7,244.30),
	 (5,1,10,1,26,387.40),
	 (5,1,10,2,12,1705.01),
	 (5,1,10,3,17,253.30),
	 (5,1,11,1,4,599.60);
INSERT INTO public.fato_vendas (sk_tempo,sk_estado_civil,sk_produto,sk_loja,quantidade_vendida,valor_total_venda) VALUES
	 (5,1,11,3,4,599.60),
	 (5,1,12,1,1,39.90),
	 (5,1,12,3,2,79.80),
	 (5,1,13,1,8,719.20),
	 (5,1,13,2,30,3093.18),
	 (5,1,13,3,3,269.70),
	 (5,1,14,1,5,122.50),
	 (5,1,14,2,13,1277.04),
	 (5,1,14,3,20,490.00),
	 (5,1,15,1,1,119.90);
INSERT INTO public.fato_vendas (sk_tempo,sk_estado_civil,sk_produto,sk_loja,quantidade_vendida,valor_total_venda) VALUES
	 (5,1,15,2,2,186.05),
	 (5,1,16,1,12,226.80),
	 (5,1,16,2,4,155.04),
	 (5,1,17,1,4,639.60),
	 (5,1,17,2,6,576.74),
	 (5,2,1,1,18,2338.20),
	 (5,2,1,2,5,409.92),
	 (5,2,1,3,15,1948.50),
	 (5,2,2,1,14,1678.60),
	 (5,2,2,3,8,959.20);
INSERT INTO public.fato_vendas (sk_tempo,sk_estado_civil,sk_produto,sk_loja,quantidade_vendida,valor_total_venda) VALUES
	 (5,2,3,1,9,719.10),
	 (5,2,3,2,18,2221.79),
	 (5,2,3,3,2,159.80),
	 (5,2,4,1,5,249.50),
	 (5,2,4,2,15,1666.94),
	 (5,2,4,3,1,49.90),
	 (5,2,5,1,10,299.00),
	 (5,2,5,3,2,59.80),
	 (5,2,6,1,7,461.30),
	 (5,2,6,2,11,1125.98);
INSERT INTO public.fato_vendas (sk_tempo,sk_estado_civil,sk_produto,sk_loja,quantidade_vendida,valor_total_venda) VALUES
	 (5,2,6,3,5,329.50),
	 (5,2,7,1,8,159.20),
	 (5,2,7,3,8,159.20),
	 (5,2,8,1,6,149.40),
	 (5,2,8,2,25,2678.18),
	 (5,2,8,3,5,124.50),
	 (5,2,9,1,4,139.60),
	 (5,2,9,2,6,759.55),
	 (5,2,10,1,2,29.80),
	 (5,2,10,2,17,1613.14);
INSERT INTO public.fato_vendas (sk_tempo,sk_estado_civil,sk_produto,sk_loja,quantidade_vendida,valor_total_venda) VALUES
	 (5,2,11,1,6,899.40),
	 (5,2,11,2,9,811.76),
	 (5,2,11,3,4,599.60),
	 (5,2,12,1,4,159.60),
	 (5,2,12,3,2,79.80),
	 (5,2,13,2,34,3334.92),
	 (5,2,13,3,6,539.40),
	 (5,2,14,1,5,122.50),
	 (5,2,14,2,14,1535.30),
	 (5,2,14,3,3,73.50);
INSERT INTO public.fato_vendas (sk_tempo,sk_estado_civil,sk_produto,sk_loja,quantidade_vendida,valor_total_venda) VALUES
	 (5,2,15,2,9,605.19),
	 (5,2,16,1,7,132.30),
	 (5,2,16,2,16,2364.15),
	 (5,2,17,1,7,1119.30),
	 (5,2,17,2,1,191.25),
	 (5,2,17,3,4,639.60),
	 (5,3,1,3,8,1039.20),
	 (5,3,2,3,12,1438.80),
	 (5,3,4,3,5,249.50),
	 (5,3,5,3,3,89.70);
INSERT INTO public.fato_vendas (sk_tempo,sk_estado_civil,sk_produto,sk_loja,quantidade_vendida,valor_total_venda) VALUES
	 (5,3,6,3,4,263.60),
	 (5,3,7,3,1,19.90),
	 (5,3,8,3,6,149.40),
	 (5,3,9,3,7,244.30),
	 (5,3,10,3,10,149.00),
	 (5,3,11,3,7,1049.30),
	 (5,3,12,3,12,478.80),
	 (5,3,13,3,2,179.80),
	 (5,3,14,3,7,171.50),
	 (5,3,17,3,4,639.60);
INSERT INTO public.fato_vendas (sk_tempo,sk_estado_civil,sk_produto,sk_loja,quantidade_vendida,valor_total_venda) VALUES
	 (5,4,1,1,19,2468.10),
	 (5,4,1,2,6,831.42),
	 (5,4,1,3,5,649.50),
	 (5,4,2,1,25,2997.50),
	 (5,4,2,3,11,1318.90),
	 (5,4,3,1,18,1438.20),
	 (5,4,3,2,4,242.93),
	 (5,4,3,3,15,1198.50),
	 (5,4,4,1,8,399.20),
	 (5,4,4,2,8,357.37);
INSERT INTO public.fato_vendas (sk_tempo,sk_estado_civil,sk_produto,sk_loja,quantidade_vendida,valor_total_venda) VALUES
	 (5,4,4,3,8,399.20),
	 (5,4,5,1,17,508.30),
	 (5,4,5,3,9,269.10),
	 (5,4,6,1,7,461.30),
	 (5,4,6,2,9,851.77),
	 (5,4,6,3,6,395.40),
	 (5,4,7,1,6,119.40),
	 (5,4,7,3,1,19.90),
	 (5,4,8,1,12,298.80),
	 (5,4,8,2,7,724.78);
INSERT INTO public.fato_vendas (sk_tempo,sk_estado_civil,sk_produto,sk_loja,quantidade_vendida,valor_total_venda) VALUES
	 (5,4,8,3,5,124.50),
	 (5,4,9,1,10,349.00),
	 (5,4,9,2,9,648.33),
	 (5,4,9,3,7,244.30),
	 (5,4,10,1,12,178.80),
	 (5,4,10,2,4,532.04),
	 (5,4,10,3,5,74.50),
	 (5,4,11,1,2,299.80),
	 (5,4,11,2,12,1334.30),
	 (5,4,11,3,13,1948.70);
INSERT INTO public.fato_vendas (sk_tempo,sk_estado_civil,sk_produto,sk_loja,quantidade_vendida,valor_total_venda) VALUES
	 (5,4,12,1,7,279.30),
	 (5,4,12,3,6,239.40),
	 (5,4,13,1,7,629.30),
	 (5,4,13,2,22,1249.28),
	 (5,4,13,3,12,1078.80),
	 (5,4,14,1,2,49.00),
	 (5,4,14,2,10,1303.36),
	 (5,4,14,3,2,49.00),
	 (5,4,15,1,11,1318.90),
	 (5,4,15,2,8,800.15);
INSERT INTO public.fato_vendas (sk_tempo,sk_estado_civil,sk_produto,sk_loja,quantidade_vendida,valor_total_venda) VALUES
	 (5,4,16,2,14,1004.91),
	 (5,4,17,2,6,778.99),
	 (5,4,17,3,5,799.50),
	 (5,5,1,1,22,2857.80),
	 (5,5,1,2,5,386.48),
	 (5,5,1,3,5,649.50),
	 (5,5,2,1,21,2517.90),
	 (5,5,2,3,4,479.60),
	 (5,5,3,1,16,1278.40),
	 (5,5,3,2,23,3236.38);
INSERT INTO public.fato_vendas (sk_tempo,sk_estado_civil,sk_produto,sk_loja,quantidade_vendida,valor_total_venda) VALUES
	 (5,5,3,3,6,479.40),
	 (5,5,4,1,12,598.80),
	 (5,5,4,2,8,1059.51),
	 (5,5,4,3,7,349.30),
	 (5,5,5,1,4,119.60),
	 (5,5,5,3,12,358.80),
	 (5,5,6,1,16,1054.40),
	 (5,5,6,2,17,2176.11),
	 (5,5,6,3,22,1449.80),
	 (5,5,7,1,3,59.70);
INSERT INTO public.fato_vendas (sk_tempo,sk_estado_civil,sk_produto,sk_loja,quantidade_vendida,valor_total_venda) VALUES
	 (5,5,7,3,3,59.70),
	 (5,5,8,1,10,249.00),
	 (5,5,8,2,13,1209.44),
	 (5,5,8,3,8,199.20),
	 (5,5,9,1,22,767.80),
	 (5,5,9,2,9,928.73),
	 (5,5,9,3,3,104.70),
	 (5,5,10,1,13,193.70),
	 (5,5,10,2,8,669.89),
	 (5,5,10,3,10,149.00);
INSERT INTO public.fato_vendas (sk_tempo,sk_estado_civil,sk_produto,sk_loja,quantidade_vendida,valor_total_venda) VALUES
	 (5,5,11,1,3,449.70),
	 (5,5,11,2,9,725.96),
	 (5,5,11,3,23,3447.70),
	 (5,5,12,1,11,438.90),
	 (5,5,12,3,3,119.70),
	 (5,5,13,1,8,719.20),
	 (5,5,13,2,16,1781.38),
	 (5,5,13,3,19,1708.10),
	 (5,5,14,1,4,98.00),
	 (5,5,14,2,19,1901.77);
INSERT INTO public.fato_vendas (sk_tempo,sk_estado_civil,sk_produto,sk_loja,quantidade_vendida,valor_total_venda) VALUES
	 (5,5,14,3,10,245.00),
	 (5,5,15,1,3,359.70),
	 (5,5,15,2,22,1679.17),
	 (5,5,16,1,13,245.70),
	 (5,5,16,2,10,651.40),
	 (5,5,17,1,1,159.90),
	 (5,5,17,2,7,960.97),
	 (5,5,17,3,15,2398.50),
	 (5,6,1,1,23,2987.70),
	 (5,6,1,3,5,649.50);
INSERT INTO public.fato_vendas (sk_tempo,sk_estado_civil,sk_produto,sk_loja,quantidade_vendida,valor_total_venda) VALUES
	 (5,6,2,1,11,1318.90),
	 (5,6,2,3,14,1678.60),
	 (5,6,3,1,15,1198.50),
	 (5,6,3,2,22,2225.56),
	 (5,6,3,3,4,319.60),
	 (5,6,4,1,19,948.10),
	 (5,6,4,2,9,1128.56),
	 (5,6,4,3,3,149.70),
	 (5,6,5,1,22,657.80),
	 (5,6,5,3,11,328.90);
INSERT INTO public.fato_vendas (sk_tempo,sk_estado_civil,sk_produto,sk_loja,quantidade_vendida,valor_total_venda) VALUES
	 (5,6,6,1,9,593.10),
	 (5,6,6,2,6,541.19),
	 (5,6,6,3,10,659.00),
	 (5,6,7,1,11,218.90),
	 (5,6,7,3,8,159.20),
	 (5,6,8,1,5,124.50),
	 (5,6,8,2,6,700.69),
	 (5,6,8,3,10,249.00),
	 (5,6,9,1,12,418.80),
	 (5,6,9,2,18,1748.93);
INSERT INTO public.fato_vendas (sk_tempo,sk_estado_civil,sk_produto,sk_loja,quantidade_vendida,valor_total_venda) VALUES
	 (5,6,9,3,5,174.50),
	 (5,6,10,1,21,312.90),
	 (5,6,10,2,7,415.44),
	 (5,6,10,3,7,104.30),
	 (5,6,11,1,4,599.60),
	 (5,6,11,2,2,118.88),
	 (5,6,11,3,10,1499.00),
	 (5,6,12,1,1,39.90),
	 (5,6,12,3,2,79.80),
	 (5,6,13,1,8,719.20);
INSERT INTO public.fato_vendas (sk_tempo,sk_estado_civil,sk_produto,sk_loja,quantidade_vendida,valor_total_venda) VALUES
	 (5,6,13,2,23,3096.26),
	 (5,6,13,3,5,449.50),
	 (5,6,14,1,5,122.50),
	 (5,6,14,2,10,1214.05),
	 (5,6,14,3,5,122.50),
	 (5,6,15,1,14,1678.60),
	 (5,6,15,2,13,1196.23),
	 (5,6,16,1,5,94.50),
	 (5,6,16,2,8,1040.06),
	 (5,6,17,2,14,1464.41);
INSERT INTO public.fato_vendas (sk_tempo,sk_estado_civil,sk_produto,sk_loja,quantidade_vendida,valor_total_venda) VALUES
	 (5,6,17,3,7,1119.30),
	 (6,1,1,1,77,10002.30),
	 (6,1,1,2,5,236.53),
	 (6,1,1,3,19,2468.10),
	 (6,1,2,1,37,4436.30),
	 (6,1,2,3,12,1438.80),
	 (6,1,3,1,17,1358.30),
	 (6,1,3,2,3,341.99),
	 (6,1,3,3,14,1118.60),
	 (6,1,4,1,10,499.00);
INSERT INTO public.fato_vendas (sk_tempo,sk_estado_civil,sk_produto,sk_loja,quantidade_vendida,valor_total_venda) VALUES
	 (6,1,4,2,22,2089.92),
	 (6,1,4,3,12,598.80),
	 (6,1,5,1,38,1136.20),
	 (6,1,5,3,15,448.50),
	 (6,1,6,1,48,3163.20),
	 (6,1,6,2,2,276.86),
	 (6,1,6,3,6,395.40),
	 (6,1,7,1,8,159.20),
	 (6,1,7,3,20,398.00),
	 (6,1,8,1,11,273.90);
INSERT INTO public.fato_vendas (sk_tempo,sk_estado_civil,sk_produto,sk_loja,quantidade_vendida,valor_total_venda) VALUES
	 (6,1,8,2,28,3671.53),
	 (6,1,8,3,9,224.10),
	 (6,1,9,1,17,593.30),
	 (6,1,9,2,12,897.77),
	 (6,1,9,3,14,488.60),
	 (6,1,10,1,30,447.00),
	 (6,1,10,2,3,541.23),
	 (6,1,10,3,8,119.20),
	 (6,1,11,1,6,899.40),
	 (6,1,11,2,4,523.58);
INSERT INTO public.fato_vendas (sk_tempo,sk_estado_civil,sk_produto,sk_loja,quantidade_vendida,valor_total_venda) VALUES
	 (6,1,11,3,5,749.50),
	 (6,1,12,1,14,558.60),
	 (6,1,12,3,1,39.90),
	 (6,1,13,1,23,2067.70),
	 (6,1,13,2,22,2207.38),
	 (6,1,13,3,17,1528.30),
	 (6,1,14,1,17,416.50),
	 (6,1,14,2,15,2351.99),
	 (6,1,14,3,15,367.50),
	 (6,1,15,2,4,351.91);
INSERT INTO public.fato_vendas (sk_tempo,sk_estado_civil,sk_produto,sk_loja,quantidade_vendida,valor_total_venda) VALUES
	 (6,1,16,1,8,151.20),
	 (6,1,16,2,15,1658.73),
	 (6,1,17,1,6,959.40),
	 (6,1,17,2,2,328.10),
	 (6,1,17,3,8,1279.20),
	 (6,2,1,1,78,10132.20),
	 (6,2,1,2,17,1760.74),
	 (6,2,1,3,3,389.70),
	 (6,2,2,1,57,6834.30),
	 (6,2,2,3,6,719.40);
INSERT INTO public.fato_vendas (sk_tempo,sk_estado_civil,sk_produto,sk_loja,quantidade_vendida,valor_total_venda) VALUES
	 (6,2,3,1,34,2716.60),
	 (6,2,3,2,10,1216.03),
	 (6,2,3,3,22,1757.80),
	 (6,2,4,1,22,1097.80),
	 (6,2,4,2,10,1243.83),
	 (6,2,4,3,10,499.00),
	 (6,2,5,1,45,1345.50),
	 (6,2,5,3,9,269.10),
	 (6,2,6,1,24,1581.60),
	 (6,2,6,2,5,593.63);
INSERT INTO public.fato_vendas (sk_tempo,sk_estado_civil,sk_produto,sk_loja,quantidade_vendida,valor_total_venda) VALUES
	 (6,2,6,3,6,395.40),
	 (6,2,7,1,12,238.80),
	 (6,2,7,3,16,318.40),
	 (6,2,8,1,24,597.60),
	 (6,2,8,2,6,614.43),
	 (6,2,8,3,14,348.60),
	 (6,2,9,1,16,558.40),
	 (6,2,9,2,15,1801.64),
	 (6,2,9,3,6,209.40),
	 (6,2,10,1,54,804.60);
INSERT INTO public.fato_vendas (sk_tempo,sk_estado_civil,sk_produto,sk_loja,quantidade_vendida,valor_total_venda) VALUES
	 (6,2,10,2,4,40.28),
	 (6,2,10,3,7,104.30),
	 (6,2,11,1,13,1948.70),
	 (6,2,11,2,7,783.70),
	 (6,2,11,3,24,3597.60),
	 (6,2,12,1,15,598.50),
	 (6,2,12,3,11,438.90),
	 (6,2,13,1,12,1078.80),
	 (6,2,13,2,26,3216.21),
	 (6,2,13,3,15,1348.50);
INSERT INTO public.fato_vendas (sk_tempo,sk_estado_civil,sk_produto,sk_loja,quantidade_vendida,valor_total_venda) VALUES
	 (6,2,14,1,14,343.00),
	 (6,2,14,2,15,1589.23),
	 (6,2,14,3,14,343.00),
	 (6,2,15,1,4,479.60),
	 (6,2,15,2,5,544.78),
	 (6,2,16,1,1,18.90),
	 (6,2,16,2,17,1653.91),
	 (6,2,17,1,5,799.50),
	 (6,2,17,2,8,831.76),
	 (6,2,17,3,18,2878.20);
INSERT INTO public.fato_vendas (sk_tempo,sk_estado_civil,sk_produto,sk_loja,quantidade_vendida,valor_total_venda) VALUES
	 (6,3,1,3,2,259.80),
	 (6,3,2,3,5,599.50),
	 (6,3,5,3,10,299.00),
	 (6,3,7,3,1,19.90),
	 (6,3,8,3,10,249.00),
	 (6,3,12,3,2,79.80),
	 (6,3,13,3,4,359.60),
	 (6,3,14,3,3,73.50),
	 (6,3,17,3,8,1279.20),
	 (6,4,1,1,46,5975.40);
INSERT INTO public.fato_vendas (sk_tempo,sk_estado_civil,sk_produto,sk_loja,quantidade_vendida,valor_total_venda) VALUES
	 (6,4,1,2,10,1269.58),
	 (6,4,1,3,8,1039.20),
	 (6,4,2,1,48,5755.20),
	 (6,4,2,3,31,3716.90),
	 (6,4,3,1,22,1757.80),
	 (6,4,3,2,7,956.08),
	 (6,4,3,3,1,79.90),
	 (6,4,4,1,16,798.40),
	 (6,4,4,2,20,2510.20),
	 (6,4,4,3,7,349.30);
INSERT INTO public.fato_vendas (sk_tempo,sk_estado_civil,sk_produto,sk_loja,quantidade_vendida,valor_total_venda) VALUES
	 (6,4,5,1,27,807.30),
	 (6,4,5,3,4,119.60),
	 (6,4,6,1,25,1647.50),
	 (6,4,6,2,19,2333.23),
	 (6,4,6,3,11,724.90),
	 (6,4,7,1,3,59.70),
	 (6,4,7,3,10,199.00),
	 (6,4,8,1,21,522.90),
	 (6,4,8,2,16,2460.08),
	 (6,4,8,3,9,224.10);
INSERT INTO public.fato_vendas (sk_tempo,sk_estado_civil,sk_produto,sk_loja,quantidade_vendida,valor_total_venda) VALUES
	 (6,4,9,1,21,732.90),
	 (6,4,9,2,18,2141.55),
	 (6,4,9,3,14,488.60),
	 (6,4,10,1,27,402.30),
	 (6,4,10,2,9,1134.15),
	 (6,4,10,3,8,119.20),
	 (6,4,11,1,15,2248.50),
	 (6,4,11,2,8,1325.68),
	 (6,4,11,3,13,1948.70),
	 (6,4,12,1,13,518.70);
INSERT INTO public.fato_vendas (sk_tempo,sk_estado_civil,sk_produto,sk_loja,quantidade_vendida,valor_total_venda) VALUES
	 (6,4,12,3,23,917.70),
	 (6,4,13,1,15,1348.50),
	 (6,4,13,2,28,2967.14),
	 (6,4,13,3,12,1078.80),
	 (6,4,14,1,6,147.00),
	 (6,4,14,2,7,693.93),
	 (6,4,14,3,5,122.50),
	 (6,4,15,1,2,239.80),
	 (6,4,15,2,14,1792.83),
	 (6,4,16,1,10,189.00);
INSERT INTO public.fato_vendas (sk_tempo,sk_estado_civil,sk_produto,sk_loja,quantidade_vendida,valor_total_venda) VALUES
	 (6,4,16,2,11,1600.95),
	 (6,4,17,2,4,433.91),
	 (6,4,17,3,10,1599.00),
	 (6,5,1,1,45,5845.50),
	 (6,5,1,2,24,2372.12),
	 (6,5,1,3,12,1558.80),
	 (6,5,2,1,41,4915.90),
	 (6,5,2,3,12,1438.80),
	 (6,5,3,1,13,1038.70),
	 (6,5,3,2,8,506.42);
INSERT INTO public.fato_vendas (sk_tempo,sk_estado_civil,sk_produto,sk_loja,quantidade_vendida,valor_total_venda) VALUES
	 (6,5,3,3,17,1358.30),
	 (6,5,4,1,29,1447.10),
	 (6,5,4,2,6,834.94),
	 (6,5,4,3,4,199.60),
	 (6,5,5,1,33,986.70),
	 (6,5,5,3,8,239.20),
	 (6,5,6,1,24,1581.60),
	 (6,5,6,2,10,1047.90),
	 (6,5,6,3,10,659.00),
	 (6,5,7,1,6,119.40);
INSERT INTO public.fato_vendas (sk_tempo,sk_estado_civil,sk_produto,sk_loja,quantidade_vendida,valor_total_venda) VALUES
	 (6,5,7,3,4,79.60),
	 (6,5,8,1,15,373.50),
	 (6,5,8,2,26,2752.32),
	 (6,5,8,3,5,124.50),
	 (6,5,9,1,10,349.00),
	 (6,5,9,2,4,205.04),
	 (6,5,9,3,2,69.80),
	 (6,5,10,1,41,610.90),
	 (6,5,10,2,3,197.94),
	 (6,5,10,3,10,149.00);
INSERT INTO public.fato_vendas (sk_tempo,sk_estado_civil,sk_produto,sk_loja,quantidade_vendida,valor_total_venda) VALUES
	 (6,5,11,1,4,599.60),
	 (6,5,11,2,8,689.79),
	 (6,5,11,3,5,749.50),
	 (6,5,12,1,11,438.90),
	 (6,5,12,3,21,837.90),
	 (6,5,13,1,5,449.50),
	 (6,5,13,2,13,1306.51),
	 (6,5,13,3,25,2247.50),
	 (6,5,14,1,1,24.50),
	 (6,5,14,2,3,384.07);
INSERT INTO public.fato_vendas (sk_tempo,sk_estado_civil,sk_produto,sk_loja,quantidade_vendida,valor_total_venda) VALUES
	 (6,5,14,3,2,49.00),
	 (6,5,15,1,5,599.50),
	 (6,5,15,2,1,194.07),
	 (6,5,16,1,4,75.60),
	 (6,5,16,2,4,627.96),
	 (6,5,17,2,19,1625.51),
	 (6,5,17,3,19,3038.10),
	 (6,6,1,1,106,13769.40),
	 (6,6,1,2,15,1107.21),
	 (6,6,1,3,6,779.40);
INSERT INTO public.fato_vendas (sk_tempo,sk_estado_civil,sk_produto,sk_loja,quantidade_vendida,valor_total_venda) VALUES
	 (6,6,2,1,35,4196.50),
	 (6,6,2,3,7,839.30),
	 (6,6,3,1,36,2876.40),
	 (6,6,3,2,10,1403.91),
	 (6,6,3,3,7,559.30),
	 (6,6,4,1,27,1347.30),
	 (6,6,4,2,5,599.55),
	 (6,6,4,3,3,149.70),
	 (6,6,5,1,50,1495.00),
	 (6,6,5,3,4,119.60);
INSERT INTO public.fato_vendas (sk_tempo,sk_estado_civil,sk_produto,sk_loja,quantidade_vendida,valor_total_venda) VALUES
	 (6,6,6,1,43,2833.70),
	 (6,6,6,2,9,749.40),
	 (6,6,6,3,8,527.20),
	 (6,6,7,1,22,437.80),
	 (6,6,7,3,2,39.80),
	 (6,6,8,1,38,946.20),
	 (6,6,8,2,31,2796.91),
	 (6,6,8,3,10,249.00),
	 (6,6,9,1,39,1361.10),
	 (6,6,9,2,10,679.06);
INSERT INTO public.fato_vendas (sk_tempo,sk_estado_civil,sk_produto,sk_loja,quantidade_vendida,valor_total_venda) VALUES
	 (6,6,9,3,9,314.10),
	 (6,6,10,1,34,506.60),
	 (6,6,10,2,11,783.45),
	 (6,6,10,3,3,44.70),
	 (6,6,11,1,15,2248.50),
	 (6,6,11,2,9,713.55),
	 (6,6,11,3,7,1049.30),
	 (6,6,12,1,12,478.80),
	 (6,6,12,3,7,279.30),
	 (6,6,13,1,11,988.90);
INSERT INTO public.fato_vendas (sk_tempo,sk_estado_civil,sk_produto,sk_loja,quantidade_vendida,valor_total_venda) VALUES
	 (6,6,13,2,15,1000.87),
	 (6,6,13,3,4,359.60),
	 (6,6,14,1,13,318.50),
	 (6,6,14,2,16,1658.84),
	 (6,6,14,3,5,122.50),
	 (6,6,15,1,4,479.60),
	 (6,6,15,2,12,1230.97),
	 (6,6,16,1,10,189.00),
	 (6,6,16,2,10,1788.11),
	 (6,6,17,1,8,1279.20);
INSERT INTO public.fato_vendas (sk_tempo,sk_estado_civil,sk_produto,sk_loja,quantidade_vendida,valor_total_venda) VALUES
	 (6,6,17,2,22,2704.38),
	 (6,6,17,3,1,159.90);



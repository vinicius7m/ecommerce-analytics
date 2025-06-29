DROP VIEW IF EXISTS 
    fato_vendas, 
    dim_clientes, 
    dim_vendedores, 
    dim_produtos, 
    dim_tempo 
CASCADE;

CREATE OR REPLACE VIEW dim_clientes AS
SELECT 
    id,
    nome,
    tipo,
    documento,
    email,
    telefone,
    endereco
FROM clientes;

CREATE OR REPLACE VIEW dim_vendedores AS
SELECT 
    id,
    nome,
    email,
    telefone
FROM vendedores;

CREATE OR REPLACE VIEW dim_produtos AS
SELECT 
    p.id,
    p.nome,
    p.preco,
    c.nome AS categoria,
    m.nome AS marca,
    co.nome AS cor,
    p.ativo
FROM produtos p
LEFT JOIN categorias c ON p.categoria_id = c.id
LEFT JOIN marcas m ON p.marca_id = m.id
LEFT JOIN cores co ON p.cor_id = co.id;

CREATE OR REPLACE VIEW dim_tempo AS
SELECT * FROM tempo;

CREATE OR REPLACE VIEW fato_vendas AS
SELECT 
    v.id,
    v.cliente_id,
    v.vendedor_id,
    v.data_venda::date AS data,  -- para ligação com dim_tempo
    v.forma_pagamento_id,
    iv.produto_id,
    v.valor_total,
    v.desconto,
    v.imposto,
    c.valor AS valor_comissao,
    iv.quantidade AS itens_quantidade
FROM vendas v
JOIN itens_venda iv ON v.id = iv.venda_id
LEFT JOIN comissoes c ON v.id = c.venda_id AND v.vendedor_id = c.vendedor_id;

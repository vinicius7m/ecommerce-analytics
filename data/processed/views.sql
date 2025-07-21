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
    REGEXP_REPLACE(
        NULLIF(
            TRANSLATE(UPPER(TRIM(nome)), 
                'ÁÉÍÓÚÀÈÌÒÙÂÊÎÔÛÃÕÇ', 
                'AEIOUAEIOUAEIOUAOC'
            ), 
            ''
        ),
        '[^A-Z ]', 
        '', 
        'g'
    ) AS nome,
    CASE 
        WHEN UPPER(TRIM(tipo)) IN ('PF', 'PJ') THEN UPPER(TRIM(tipo))
        ELSE NULL
    END AS tipo,
    CASE 
        WHEN UPPER(TRIM(tipo)) = 'PF' AND LENGTH(REGEXP_REPLACE(documento, '[^0-9]', '', 'g')) = 11 
            THEN REGEXP_REPLACE(documento, '[^0-9]', '', 'g')
        WHEN UPPER(TRIM(tipo)) = 'PJ' AND LENGTH(REGEXP_REPLACE(documento, '[^0-9]', '', 'g')) = 14 
            THEN REGEXP_REPLACE(documento, '[^0-9]', '', 'g')
        ELSE NULL
    END AS documento,
    CASE 
        WHEN email LIKE '%@%.%' THEN LOWER(TRIM(email))
        ELSE NULL
    END AS email,
    NULLIF(REGEXP_REPLACE(TRIM(telefone), '[^0-9]', '', 'g'), '') AS telefone,
    CASE 
        WHEN UPPER(TRIM(endereco)) IS NULL OR LENGTH(UPPER(TRIM(endereco))) < 10 THEN NULL
        ELSE UPPER(endereco)
    END AS endereco,
    (SELECT REGEXP_MATCHES(TRIM(endereco), '([A-Z]{2})$'))[1] AS estado
FROM clientes
WHERE 
    REGEXP_REPLACE(
        NULLIF(
            TRANSLATE(UPPER(TRIM(nome)), 
                'ÁÉÍÓÚÀÈÌÒÙÂÊÎÔÛÃÕÇ', 
                'AEIOUAEIOUAEIOUAOC'
            ), 
            ''
        ),
        '[^A-Z ]', 
        '', 
        'g'
    ) IS NOT NULL;

CREATE OR REPLACE VIEW dim_vendedores AS
SELECT 
    id,
    REGEXP_REPLACE(
        NULLIF(
            TRANSLATE(UPPER(TRIM(nome)), 
                'ÁÉÍÓÚÀÈÌÒÙÂÊÎÔÛÃÕÇ', 
                'AEIOUAEIOUAEIOUAOC'
            ), 
            ''
        ),
        '[^A-Z ]', 
        '', 
        'g'
    ) AS nome,
    CASE 
        WHEN email LIKE '%@%.%' THEN LOWER(TRIM(email))
        ELSE NULL
    END AS email,
    NULLIF(REGEXP_REPLACE(TRIM(telefone), '[^0-9]', '', 'g'), '') AS telefone
FROM vendedores;

CREATE OR REPLACE VIEW dim_produtos AS
SELECT 
    p.id,
    REGEXP_REPLACE(
        NULLIF(
            TRANSLATE(UPPER(TRIM(p.nome)), 
                'ÁÉÍÓÚÀÈÌÒÙÂÊÎÔÛÃÕÇ', 
                'AEIOUAEIOUAEIOUAOC'
            ), 
            ''
        ),
        '[^A-Z0-9 ]', 
        '', 
        'g'
    ) AS nome,
    p.preco,
    REGEXP_REPLACE(
        NULLIF(
            TRANSLATE(UPPER(TRIM(c.nome)), 
                'ÁÉÍÓÚÀÈÌÒÙÂÊÎÔÛÃÕÇ', 
                'AEIOUAEIOUAEIOUAOC'
            ), 
            ''
        ),
        '[^A-Z0-9 ]', 
        '', 
        'g'
    ) AS categoria,
    REGEXP_REPLACE(
        NULLIF(
            TRANSLATE(UPPER(TRIM(m.nome)), 
                'ÁÉÍÓÚÀÈÌÒÙÂÊÎÔÛÃÕÇ', 
                'AEIOUAEIOUAEIOUAOC'
            ), 
            ''
        ),
        '[^A-Z0-9 ]', 
        '', 
        'g'
    ) AS marca,
    REGEXP_REPLACE(
        NULLIF(
            TRANSLATE(UPPER(TRIM(co.nome)), 
                'ÁÉÍÓÚÀÈÌÒÙÂÊÎÔÛÃÕÇ', 
                'AEIOUAEIOUAEIOUAOC'
            ), 
            ''
        ),
        '[^A-Z0-9 ]', 
        '', 
        'g'
    ) AS cor,
    p.ativo
FROM produtos p
LEFT JOIN categorias c ON p.categoria_id = c.id
LEFT JOIN marcas m ON p.marca_id = m.id
LEFT JOIN cores co ON p.cor_id = co.id;

CREATE OR REPLACE VIEW dim_tempo AS
SELECT * FROM tempo;

CREATE OR REPLACE VIEW fato_vendas AS
WITH vendas_validas AS (
    SELECT 
        id,
        CASE WHEN cliente_id <= 0 THEN NULL ELSE cliente_id END AS cliente_id,
        CASE WHEN vendedor_id <= 0 THEN NULL ELSE vendedor_id END AS vendedor_id,
        CASE 
            WHEN data_venda ~ '^\d{4}-\d{2}-\d{2}' THEN TO_TIMESTAMP(data_venda, 'YYYY-MM-DD HH24:MI:SS')::date
            WHEN data_venda ~ '^\d{2}/\d{2}/\d{4}' THEN TO_TIMESTAMP(data_venda, 'DD/MM/YYYY HH24:MI:SS')::date
            WHEN data_venda ~ '^\d{2}-\d{2}-\d{4}' THEN TO_TIMESTAMP(data_venda, 'DD-MM-YYYY HH24:MI:SS')::date
            WHEN data_venda ~ '^\d{4}/\d{2}/\d{2}' THEN TO_TIMESTAMP(data_venda, 'YYYY/MM/DD HH24:MI:SS')::date
            WHEN data_venda ~ '^\d{4}\.\d{2}\.\d{2}' THEN TO_TIMESTAMP(data_venda, 'YYYY.MM.DD HH24:MI:SS')::date
            WHEN TRIM(data_venda) = '' THEN NULL
            ELSE NULL 
        END AS data_venda,
        CASE 
            WHEN data_entrega ~ '^\d{4}-\d{2}-\d{2}' THEN TO_TIMESTAMP(data_entrega, 'YYYY-MM-DD HH24:MI:SS')::date
            WHEN data_entrega ~ '^\d{2}/\d{2}/\d{4}' THEN TO_TIMESTAMP(data_entrega, 'DD/MM/YYYY HH24:MI:SS')::date
            WHEN data_entrega ~ '^\d{2}-\d{2}-\d{4}' THEN TO_TIMESTAMP(data_entrega, 'DD-MM-YYYY HH24:MI:SS')::date
            WHEN data_entrega ~ '^\d{4}/\d{2}/\d{2}' THEN TO_TIMESTAMP(data_entrega, 'YYYY/MM/DD HH24:MI:SS')::date
            WHEN data_entrega ~ '^\d{4}\.\d{2}\.\d{2}' THEN TO_TIMESTAMP(data_entrega, 'YYYY.MM.DD HH24:MI:SS')::date
            WHEN TRIM(data_entrega) = '' THEN NULL
            ELSE NULL 
        END AS data_entrega,
        CASE 
            WHEN forma_pagamento_id BETWEEN 1 AND 5 THEN forma_pagamento_id
            ELSE NULL 
        END AS forma_pagamento_id,
        CASE WHEN valor_total < 0 THEN NULL ELSE valor_total END AS valor_total,
        CASE WHEN desconto < 0 THEN NULL ELSE desconto END AS desconto,
        CASE WHEN imposto < 0 THEN NULL ELSE imposto END AS imposto,
        canal,
        status
    FROM vendas
    WHERE 
        (cliente_id IS NOT NULL AND cliente_id > 0) AND
        (vendedor_id IS NOT NULL AND vendedor_id > 0) AND
        (data_venda IS NOT NULL) AND
        (forma_pagamento_id BETWEEN 1 AND 5) AND
        (valor_total IS NOT NULL AND valor_total > 0)
)
SELECT 
    v.id,
    v.cliente_id,
    v.vendedor_id,
    v.data_venda AS data,
    v.data_entrega AS data_entrega,
    v.forma_pagamento_id,
    iv.produto_id,
    v.valor_total,
    COALESCE(v.desconto, 0) AS desconto,
    COALESCE(v.imposto, 0) AS imposto,
    COALESCE(c.valor, 0) AS valor_comissao,
    iv.quantidade AS itens_quantidade,
    v.valor_total - COALESCE(v.desconto, 0) + COALESCE(v.imposto, 0) AS valor_liquido,
    UPPER(v.canal) as canal,
    UPPER(v.status) as status
FROM vendas_validas v
JOIN itens_venda iv ON v.id = iv.venda_id
LEFT JOIN comissoes c ON v.id = c.venda_id AND v.vendedor_id = c.vendedor_id
WHERE 
    iv.produto_id IS NOT NULL AND
    iv.quantidade > 0;

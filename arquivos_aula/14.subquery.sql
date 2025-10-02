

-- Lista de transações com o produto 'Resgatar Ponei'

SELECT
    *
FROM
    transacao_produto as t1
WHERE t1.IdProduto IN (
    SELECT IdProduto
    FROM produtos
    WHERE DescNomeProduto = 'Resgatar Ponei'
);


/* Dos Clientes que começaram SQL no primeiro 
dia, quantos chegaram ao 5° dia?  */

SELECT 
    -- *
    COUNT(DISTINCT idCliente)
FROM 
    transacoes AS t1
WHERE 
    t1.idCliente IN (
        SELECT DISTINCT idCliente
        FROM transacoes
        WHERE SUBSTR(DtCriacao,1,10) = '2025-08-25'
    )
    AND SUBSTR(t1.DtCriacao,1,10) = '2025-08-29'
;

-- Exemplo com subquery dentro de FROM

SELECT 
    *
FROM (
    SELECT *
    FROM transacoes
    WHERE DtCriacao >= '2025-01-01'
)
WHERE DtCriacao < '2025-07-01';


SELECT
    IdProduto,
    count(*)
FROM 
    transacao_produto
GROUP BY
    IdProduto;


SELECT
    IdCliente,
    SUM(QtdePontos),
    COUNT(IdTransacao)
FROM
    transacoes
WHERE DtCriacao >= '2025-07-01' 
    AND DtCriacao < '2025-08-01'  
GROUP BY
    IdCliente  
HAVING -- Filtro pós agrupamento/agregação
    SUM(QtdePontos) > 4000
ORDER BY
    SUM(QtdePontos) DESC
LIMIT 10;
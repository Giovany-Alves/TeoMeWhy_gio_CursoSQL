

SELECT
    IdProduto,
    count(*)
FROM 
    transacao_produto
GROUP BY
    IdProduto;


SELECT -- 5°
    IdCliente,
    SUM(QtdePontos),
    COUNT(IdTransacao)
FROM -- 1º
    transacoes
WHERE -- 2º
    DtCriacao >= '2025-07-01' 
    AND DtCriacao < '2025-08-01'  
GROUP BY -- 3º
    IdCliente  
HAVING -- 4º | Filtro pós agrupamento/agregação
    SUM(QtdePontos) > 4000
ORDER BY -- 6º
    SUM(QtdePontos) DESC
LIMIT 10;
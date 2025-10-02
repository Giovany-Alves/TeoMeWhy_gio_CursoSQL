-- Quais clientes mais perderam pontos por Lover?

SELECT 
    t1.IdCliente,
    SUM(t1.QtdePontos) AS totalPontos
FROM 
    transacoes AS t1
LEFT JOIN transacao_produto AS t2
    ON t1.IdTransacao = t2.IdTransacao
LEFT JOIN produtos AS t3
    ON t2.IdProduto = t3.IdProduto
WHERE 
    t3.DescCategoriaProduto = 'lovers'
GROUP BY 
    t1.IdCliente
ORDER BY 
    SUM(t1.QtdePontos) ASC
LIMIT 5
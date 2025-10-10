

SELECT 
    *
FROM 
    transacao_produto AS t1
LEFT JOIN 
    produtos AS t2
    ON t1.IdProduto = t2.IdProduto
LIMIT 2;


-- Qual categoria tem produtos mais vendidos?

SELECT
    t2.DescCategoriaProduto,
    COUNT(DISTINCT t1.idTransacaoProduto) AS qtdeTransacao
FROM 
    transacao_produto AS t1
LEFT JOIN 
    produtos AS t2
    ON t1.IdProduto = t2.IdProduto
GROUP BY 
    t2.DescCategoriaProduto
ORDER BY 
    qtdeTransacao DESC;

SELECT
    t2.DescCategoriaProduto,
    COUNT(DISTINCT t1.idTransacaoProduto) AS qtdeTransacao
FROM 
    produtos AS t2
LEFT JOIN 
    transacao_produto AS t1
    ON t2.IdProduto = t1.IdProduto
GROUP BY 
    t2.DescCategoriaProduto
ORDER BY 
    qtdeTransacao DESC;

-- Em 2024, quantas transações de Lover tivemos?

SELECT * FROM transacoes LIMIT 5;
SELECT * FROM transacao_produto LIMIT 5;
SELECT * FROM produtos LIMIT 5;

SELECT 
    t3.DescCategoriaProduto,
    COUNT(DISTINCT t1.IdTransacao)
FROM 
    transacoes AS t1
LEFT JOIN transacao_produto AS t2
    ON t1.IdTransacao = t2.IdTransacao
LEFT JOIN produtos AS t3
    ON t2.IdProduto = t3.IdProduto
WHERE 
    t1.DtCriacao >= '2024-01-01'
    AND t1.DtCriacao < '2025-01-01'
    -- AND t3.DescCategoriaProduto = 'lovers';
GROUP BY
    t3.DescCategoriaProduto
HAVING 
    COUNT(DISTINCT t1.IdTransacao) < 1000
ORDER BY
    COUNT(DISTINCT t1.IdTransacao) DESC;


-- Qual mês tivemos mais lista de presença assinada?

SELECT
    -- t1.IdTransacao,
    -- t1.DtCriacao,
    -- t3.DescNomeProduto,
    substr(t1.DtCriacao,1,7) AS anoMes,
    count(DISTINCT t1.IdTransacao) AS qtdeTransacao
FROM
    transacoes AS t1
LEFT JOIN transacao_produto AS t2
    ON t1.IdTransacao = t2.IdTransacao
LEFT JOIN produtos AS t3
    ON t2.IdProduto = t3.IdProduto
WHERE 
    DescNomeProduto = 'Lista de presença'
GROUP BY anoMes
ORDER BY qtdeTransacao DESC;





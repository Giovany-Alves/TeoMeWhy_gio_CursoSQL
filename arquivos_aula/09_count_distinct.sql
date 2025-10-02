SELECT 
    count(*),
    count(DISTINCT IdTransacao),
    count(DISTINCT idCliente)
FROM transacoes
WHERE DtCriacao >= '2025-07-01'
AND DtCriacao < '2025-08-01'
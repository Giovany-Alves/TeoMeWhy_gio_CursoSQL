
WITH
tb_transacoes AS (
    SELECT 
        IdTransacao,
        idCliente,
        qtdePontos,
        DATETIME(SUBSTR(DtCriacao,1,19)) AS DtCriacao,
        JULIANDAY('now') - JULIANDAY(SUBSTR(DtCriacao,1,10)) AS diffDate
    FROM transacoes
),

tb_cliente AS (
    SELECT 
        idCliente,
        DATETIME(SUBSTR(DtCriacao,1,19)) AS DtCriacao,
        JULIANDAY('now') - JULIANDAY(SUBSTR(DtCriacao,1,10)) AS diffDate
    FROM clientes

)


SELECT
    idCliente,
    COUNT(IdTransacao) AS qtdTransacoesVida,
    COUNT(CASE WHEN diffDate <= 56 THEN IdTransacao END) AS qtdeTransacoes56,
    COUNT(CASE WHEN diffDate <= 28 THEN IdTransacao END) AS qtdeTransacoes28,
    COUNT(CASE WHEN diffDate <= 14 THEN IdTransacao END) AS qtdeTransacoes14,
    COUNT(CASE WHEN diffDate <= 7 THEN IdTransacao END) AS qtdeTransacoes7,
    MIN(diffDate) AS diasUltimaTransacao
FROM
    tb_transacoes
GROUP BY 
    idCliente



WITH

tb_sumario_dias AS (
    SELECT 
        SUBSTR(DtCriacao,1,10) AS dtDia,
        COUNT(DISTINCT idTransacao) AS qtdeTransacao
    FROM 
        transacoes
    WHERE 
        DtCriacao >= '2025-08-25'
        AND DtCriacao < '2025-08-30'
    GROUP BY 
        dtDia
)

SELECT 
    *,
    SUM(qtdeTransacao) OVER (ORDER BY dtDia) AS qtdeTransacaoAcum
FROM tb_sumario_dias
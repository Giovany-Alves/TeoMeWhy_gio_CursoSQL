
WITH

cliente_dia AS (
    SELECT 
        DISTINCT
        idCliente,
        SUBSTR(DtCriacao,1,10) AS dtDia
    FROM
        transacoes
    WHERE
        SUBSTR(DtCriacao,1,4) = '2025'
    ORDER BY
        idCliente, dtDia
),

tb_lag AS (
    SELECT 
        *,
        LAG(dtDia) OVER 
                    (PARTITION BY 
                        idCliente 
                    ORDER BY 
                        dtDia) AS LagDia
    FROM cliente_dia
),

tb_diff_dt AS (
    SELECT 
        *,
        JULIANDAY(dtDia) - JULIANDAY(LagDia) AS DtDiff
    FROM tb_lag
),

avg_cliente AS (
    SELECT 
        idCliente, 
        AVG(DtDiff) AS avgDia
    FROM 
        tb_diff_dt
    GROUP BY 
        IdCliente
)

SELECT AVG(avgDia) FROM avg_cliente
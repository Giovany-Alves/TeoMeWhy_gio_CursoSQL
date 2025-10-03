-- Qual o dia da semana mais ativo de cada usuário?

WITH 
tb_cliente_semana AS (
    SELECT 
        IdCliente,
        -- STRFTIME --> Pega o dia da semana, começando no 0 (domingo)
        STRFTIME('%w', SUBSTR(DtCriacao,1,10)) AS dtDiaSemana,
        COUNT(distinct IdTransacao) AS qtdeTransacao
    FROM 
        transacoes
    GROUP BY 
        IdCliente, dtDiaSemana
),

tb_rn AS (
    SELECT 
        *,
        CASE
            WHEN dtDiaSemana = '1' THEN 'SEGUNDA FEIRA'
            WHEN dtDiaSemana = '2' THEN 'TERCA FEIRA'
            WHEN dtDiaSemana = '3' THEN 'QUARTA FEIRA'
            WHEN dtDiaSemana = '4' THEN 'QUINTA FEIRA'
            WHEN dtDiaSemana = '5' THEN 'SEXTA FEIRA'
            WHEN dtDiaSemana = '6' THEN 'SABADO FEIRA'
            ELSE 'DOMINGO'
        END AS descdiaSemana,
        ROW_NUMBER() OVER (PARTITION BY IdCliente ORDER BY qtdeTransacao DESC) AS rn
    FROM tb_cliente_semana
)

SELECT *
FROM tb_rn
WHERE rn = 1
-- DROP TABLE IF EXISTS tb_feature_store_cliente;

-- CREATE TABLE feature_store_cliente AS

WITH

tb_transacoes AS (
    SELECT 
        IdTransacao,
        idCliente,
        qtdePontos,
        DATETIME(SUBSTR(DtCriacao,1,19)) AS DtCriacao,
        JULIANDAY('{date}') - JULIANDAY(SUBSTR(DtCriacao,1,10)) AS diffDate,
        CAST(STRFTIME('%H', SUBSTR(DtCriacao,1,19)) AS INTEGER) AS dtHora
    FROM 
        transacoes
    WHERE DtCriacao < '{date}'
),

tb_cliente AS (
    SELECT 
        idCliente,
        DATETIME(SUBSTR(DtCriacao,1,19)) AS DtCriacao,
        JULIANDAY('{date}') - JULIANDAY(SUBSTR(DtCriacao,1,10)) AS idadeBase
    FROM clientes

),

tb_sumario_transacoes AS (
    SELECT
        idCliente,
        COUNT(IdTransacao) AS qtdeTransacoesVida,
        COUNT(CASE WHEN diffDate <= 56 THEN IdTransacao END) AS qtdeTransacoes56,
        COUNT(CASE WHEN diffDate <= 28 THEN IdTransacao END) AS qtdeTransacoes28,
        COUNT(CASE WHEN diffDate <= 14 THEN IdTransacao END) AS qtdeTransacoes14,  
        COUNT(CASE WHEN diffDate <= 7 THEN IdTransacao END) AS qtdeTransacoes7,
        
        SUM(QtdePontos) AS saldoPontos,
        
        MIN(diffDate) AS diasUltimaTransacao,
        
        SUM(CASE WHEN qtdePontos >0 THEN qtdePontos ELSE 0 END) AS qtdePontosPosVida,
        SUM(CASE WHEN qtdePontos >0 AND diffDate <= 56 THEN qtdePontos ELSE 0 END) AS qtdePontosPos56,
        SUM(CASE WHEN qtdePontos >0 AND diffDate <= 28 THEN qtdePontos ELSE 0 END) AS qtdePontosPos28,
        SUM(CASE WHEN qtdePontos >0 AND diffDate <= 14 THEN qtdePontos ELSE 0 END) AS qtdePontosPos14,
        SUM(CASE WHEN qtdePontos >0 AND diffDate <= 7 THEN qtdePontos ELSE 0 END) AS qtdePontosPos7,

        SUM(CASE WHEN qtdePontos <0 THEN qtdePontos ELSE 0 END) AS qtdePontosNegVida,
        SUM(CASE WHEN qtdePontos <0 AND diffDate <= 56 THEN qtdePontos ELSE 0 END) AS qtdePontosNeg56,
        SUM(CASE WHEN qtdePontos <0 AND diffDate <= 28 THEN qtdePontos ELSE 0 END) AS qtdePontosNeg28,
        SUM(CASE WHEN qtdePontos <0 AND diffDate <= 14 THEN qtdePontos ELSE 0 END) AS qtdePontosNeg14,
        SUM(CASE WHEN qtdePontos <0 AND diffDate <= 7 THEN qtdePontos ELSE 0 END) AS qtdePontosNeg7 
    FROM
        tb_transacoes
    GROUP BY 
        idCliente
),


tb_transacao_produto AS (
    SELECT 
        t1.*,
        t3.DescNomeProduto,
        t3.DescCategoriaProduto

    FROM 
        tb_transacoes AS t1
    LEFT JOIN 
        transacao_produto AS t2
        ON t1.IdTransacao = t2.IdTransacao
    LEFT JOIN
        produtos AS t3
        ON t2.IdProduto = t3.IdProduto
),

tb_cliente_produto AS (
    SELECT 
        idCliente,
        DescNomeProduto,
        COUNT(*) AS qtdeVida,
        COUNT(CASE WHEN diffDate <= 56 THEN IdTransacao END) AS qtde56,
        COUNT(CASE WHEN diffDate <= 28 THEN IdTransacao END) AS qtde28,
        COUNT(CASE WHEN diffDate <= 14 THEN IdTransacao END) AS qtde14,
        COUNT(CASE WHEN diffDate <= 7 THEN IdTransacao END) AS qtde7
    FROM
        tb_transacao_produto
    GROUp BY 
        idCliente, DescNomeProduto
),


tb_cliente_produto_rn AS (
    SELECT 
        *,
        ROW_NUMBER() OVER (PARTITION BY idCliente ORDER BY qtdeVida) AS rnVida,
        ROW_NUMBER() OVER (PARTITION BY idCliente ORDER BY qtde56) AS rn56,
        ROW_NUMBER() OVER (PARTITION BY idCliente ORDER BY qtde28) AS rn28,
        ROW_NUMBER() OVER (PARTITION BY idCliente ORDER BY qtde14) AS rn14,
        ROW_NUMBER() OVER (PARTITION BY idCliente ORDER BY qtde7) AS rn7
    FROM
        tb_cliente_produto
),


tb_cliente_dia AS (
    SELECT
        idCliente,
        STRFTIME('%w', DtCriacao) AS dtDia,
        COUNT(*) AS qtdTransacao
    FROM 
        tb_transacoes
    WHERE
        diffDate <= 28
    GROUP BY
        idCliente, dtDia
),


tb_cliente_dia_rn AS (
    SELECT
        *,
        ROW_NUMBER() OVER (PARTITION BY 
                                idCliente 
                            ORDER BY 

                                qtdTransacao DESC) AS rnDia
    FROM tb_cliente_dia
),


tb_cliente_periodo AS (
    SELECT 
        idCliente,
        IdTransacao,
        CASE 
            WHEN dtHora BETWEEN 7 AND 12 THEN 'MANHÃ'
            WHEN dtHora BETWEEN 13 AND 18 THEN 'TARDE'
            WHEN dtHora BETWEEN 19 AND 23 THEN 'NOITE'
            ELSE 'MADRUGADA'
        END as periodo,
        COUNT(*) AS qtdeTransacao
    FROM 
        tb_transacoes
    WHERE
        diffDate <= 28
    GROUP BY 
        1,2
),


tb_cliente_periodo_rn AS (
    SELECT
        *,
        ROW_NUMBER() OVER (PARTITION BY idCliente ORDER BY qtdeTransacao DESC) AS rnPeriodo
    FROM
        tb_cliente_periodo
),


tb_join AS ( 
    SELECT 
        t1.*,
        t2.IdadeBase,
        t3.DescNomeProduto AS produtoVida,
        t4.DescNomeProduto AS produto56,
        t5.DescNomeProduto AS produto28,
        t6.DescNomeProduto AS produto14,
        t7.DescNomeProduto AS produto7,
        COALESCE(t8.dtDia, -1) AS dtDia,
        COALESCE(t9.rnPeriodo, 'SEM INFORMACAO') AS periodoMaisTransacao28
    FROM 
        tb_sumario_transacoes AS t1

    LEFT JOIN 
        tb_cliente AS t2
        ON t1.idCliente = t2.idCliente

    LEFT JOIN 
        tb_cliente_produto_rn AS t3
        ON t1.idCliente = t3.idCliente
        AND t3.rnVida = 1

    LEFT JOIN
        tb_cliente_produto_rn AS t4
        ON t1.idCliente = t4.IdCliente
        AND t4.rn56 = 1
    
    LEFT JOIN
        tb_cliente_produto_rn AS t5
        ON t1.idCliente = t5.IdCliente
        AND t5.rn28 = 1
    
    LEFT JOIN
        tb_cliente_produto_rn AS t6
        ON t1.idCliente = t6.IdCliente
        AND t6.rn14 = 1
    
    LEFT JOIN
        tb_cliente_produto_rn AS t7
        ON t1.idCliente = t7.IdCliente
        AND t7.rn7 = 1

    LEFT JOIN 
        tb_cliente_dia_rn AS t8
        ON t1.idCliente = t8.idCliente
        AND t8.rnDia = 1
    
    LEFT JOIN
        tb_cliente_periodo_rn AS t9
        ON t1.IdCliente = t9.idCliente
        AND t9.rnPeriodo = 1  
)

SELECT
    '{date}' AS dtRef,
    *,
    1. * qtdeTransacoes28 / qtdeTransacoesVida AS engajamento28Vida
FROM 
    tb_join;


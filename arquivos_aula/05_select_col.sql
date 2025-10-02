SELECT 
    idCliente,
    -- QtdePontos,
    -- QtdePontos * 0.1 AS PontosBonus,
    DtCriacao,
    substr(DtCriacao, 1 , 19) AS dtSubString,
    datetime(substr(DtCriacao, 1 , 19)) AS dtCriacaoNova,
    strftime('%w', datetime(substr(DtCriacao, 1 , 19))) AS diaSemana 
FROM clientes
LIMIT 5
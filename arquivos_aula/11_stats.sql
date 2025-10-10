SELECT 
    ROUND(AVG(QtdePontos), 2) AS MediaCarteira,
    ROUND(1. * SUM(QtdePontos) / COUNT(*),2) AS MediaCarteiraRoots,
    MIN(QtdePontos) AS MinCarteira,
    MAX(QtdePontos) AS MaxCarteira,
    SUM(flTwitch),
    SUM(flEmail)
FROM 
    clientes
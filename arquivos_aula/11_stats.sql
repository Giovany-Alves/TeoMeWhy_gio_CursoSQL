SELECT 
    ROUND(AVG(QtdePontos), 2) AS MediaCarteira,
    1. * SUM(QtdePontos) / COUNT(*) AS MediaCarteiraRoots,
    MIN(QtdePontos) AS MinCarteira,
    MAX(QtdePontos) AS MaxCarteira,
    SUM(flTwitch),
    SUM(flEmail)
FROM 
    clientes
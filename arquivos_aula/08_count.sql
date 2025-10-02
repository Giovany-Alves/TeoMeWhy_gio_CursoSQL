SELECT
    count(*),
    count(1),
    count(idCliente)
FROM clientes;


SELECT DISTINCT flTwitch, flEmail
FROM clientes;


SELECT count(DISTINCT idCliente)
FROM clientes;
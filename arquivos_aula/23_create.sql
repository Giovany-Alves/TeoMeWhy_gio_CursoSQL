-- DROP TABLE IF EXISTS clientes_d28;

CREATE TABLE clientes_d28 (
    idCliente VARCHAR(250) PRIMARY KEY,
    QtdeTransacoes INTEGER
);

DELETE FROM clientes_d28;

INSERT INTO clientes_d28
SELECT
    idCliente,
    COUNT(DISTINCT IdTransacao) AS QtdeTransacoes
FROM
    transacoes
WHERE
    JULIANDAY('now') - JULIANDAY(SUBSTR(DtCriacao,1,10)) <=28
GROUP BY idCliente;

SELECT * FROM clientes_d28;
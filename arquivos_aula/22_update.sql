
-- Não faça UPDATE/DELETE sem WHERE

UPDATE relatorio_diario
SET qtdTransacao = 10000
WHERE dtDia >= '2025-08-25';

SELECT * FROM relatorio_diario;
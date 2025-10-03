DELETE FROM relatorio_diario;

SELECT * FROM relatorio_diario;

SELECT COUNT(*) FROM relatorio_diario;


DELETE FROM relatorio_diario
WHERE STRFTIME('%w', SUBSTR(dtDia,1,10)) = '0';

SELECT * FROM relatorio_diario;

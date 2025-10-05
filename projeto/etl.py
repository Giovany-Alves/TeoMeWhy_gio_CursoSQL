# %%

import pandas as pd
import sqlalchemy

# Conexão com banco de dados
engine = sqlalchemy.create_engine("sqlite:///database.db")

# Lendo a query do arquivo de texto
with open("etl_projeto.sql") as open_file:
    query = open_file.read()

# %%

dates = [
    '2025-01-01',
    '2025-02-01',
    '2025-03-01',
    '2025-04-01',
    '2025-05-01',
    '2025-06-01',
    '2025-07-01',
]

for i in dates:

    # Executa query e traz os dados para o Python
    df = pd.read_sql(query.format(date=i), engine)

    # PEga os dados do python e manda para o banco na tabela 'feature_store_cliente'
    df.to_sql("feature_store_cliente", engine, index=False, if_exists="append")

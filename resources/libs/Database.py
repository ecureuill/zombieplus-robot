import psycopg2
import sys
sys.path.append("resources")
from config import load_config

def connect_to_database():
  config = load_config()
  
  for var in ['DB_HOST', 'DB_NAME', 'DB_USER', 'DB_PASS']:
      if not config.get(var):
          raise ValueError(f"Variável necessária não encontrada: {var}")

  DB_HOST = config["DB_HOST"]
  DB_NAME = config["DB_NAME"]
  DB_USER = config["DB_USER"]
  DB_PASS = config["DB_PASS"]

  conn_string = f"host={DB_HOST} dbname={DB_NAME} user={DB_USER} password={DB_PASS}"

  return psycopg2.connect(conn_string)

def execute_sql(sql):
  if not sql:
      raise ValueError("A consulta SQL não pode ser vazia.")

  with connect_to_database() as conn:
      cur = conn.cursor()
      cur.execute(sql)
      conn.commit()
      print("Query executada com sucesso.")
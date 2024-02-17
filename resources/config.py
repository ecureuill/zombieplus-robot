import yaml
import os

def load_config():
  file = os.path.join("resources", "env.yaml")
  with open(file, "r") as f:
    config = yaml.safe_load(f)

  DB_HOST = config["DB_HOST"]
  DB_NAME = config["DB_NAME"]
  DB_USER = config["DB_USER"]
  DB_PASS = config["DB_PASS"]
  
  return config
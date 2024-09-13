import os
from todo_project import app

# Use 127.0.0.1 como padrão para evitar binding desnecessário em todas as interfaces
host = os.getenv('FLASK_RUN_HOST', '127.0.0.1')

# Levantar um erro se o host não estiver definido corretamente fora do ambiente de desenvolvimento
if os.getenv('FLASK_ENV') != 'development' and host == '0.0.0.0':
    raise ValueError("Insecure FLASK_RUN_HOST detected in a non-development environment")

app.run(host=host, port=5000, debug=False)

import os
from todo_project import app

# Use 127.0.0.1 como padrão para evitar binding desnecessário em todas as interfaces
host = os.getenv('FLASK_RUN_HOST')

# Condicional para garantir que o host seja seguro fora do ambiente de desenvolvimento
if os.getenv('FLASK_ENV') == 'development':
    host = host or '0.0.0.0'  # Bind apenas em todas as interfaces no desenvolvimento
else:
    host = host or '127.0.0.1'  # Bind em localhost fora do desenvolvimento

# Levantar um erro se o host não for seguro
if host == '0.0.0.0' and os.getenv('FLASK_ENV') != 'development':
    raise ValueError("Insecure FLASK_RUN_HOST detected in a non-development environment")  # nosec

app.run(host=host, port=5000, debug=False)

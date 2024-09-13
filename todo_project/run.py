import os
from todo_project import app

# Verifique se está no ambiente de desenvolvimento
if os.getenv('FLASK_ENV') == 'development':
    # Em desenvolvimento, usar 0.0.0.0 para facilitar o acesso local
    host = '0.0.0.0'
else:
    # Em produção, usar 127.0.0.1 para segurança
    host = '127.0.0.1'

# Executar a aplicação Flask
app.run(host=host, port=5000, debug=False)

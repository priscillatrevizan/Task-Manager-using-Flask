import os 
import hmac
from flask import Flask
from flask_sqlalchemy import SQLAlchemy
from flask_login import LoginManager
from flask_bcrypt import Bcrypt
from dotenv import load_dotenv
from flask_wtf.csrf import CSRFProtect


# Carregar as variáveis de ambiente do arquivo .env
load_dotenv()

# Substituto de safe_str_cmp
def safe_str_cmp(a, b):
    return hmac.compare_digest(a, b)

# Crie o objeto da aplicação Flask
app = Flask(__name__)

# Configurações da aplicação
app.config['SECRET_KEY'] = os.getenv('SECRET_KEY')
app.config['SQLALCHEMY_DATABASE_URI'] = 'sqlite:///site.db'

# Inicializar o banco de dados
db = SQLAlchemy(app)

# Configuração de login
login_manager = LoginManager(app)
login_manager.login_view = 'login' 
login_manager.login_message_category = 'danger'

# Inicializar bcrypt para hash de senhas
bcrypt = Bcrypt(app)

# Habilitar CSRF Protection
csrf = CSRFProtect(app)

# Importe as rotas no final do arquivo
from todo_project import routes

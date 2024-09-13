# Use a imagem oficial estável do OWASP ZAP
FROM zaproxy/zap-stable:latest

# Defina o diretório de trabalho na imagem
WORKDIR /app

# Mudar para o usuário root para realizar as instalações
USER root

# Instale o wget, unzip, python3, pip e outras dependências
RUN apt-get update && apt-get install -y curl wget unzip python3 python3-pip

# Instale o gunicorn, python-dotenv e atualize o flask-wtf
RUN pip3 install gunicorn python-dotenv && pip3 install --upgrade flask-wtf

# Retorne ao usuário zap após todas as instalações
USER zap

# Copie o arquivo requirements.txt e instale as dependências do Python
COPY requirements.txt requirements.txt
RUN pip3 install -r requirements.txt

# Substituir 'safe_str_cmp' no 'flask_bcrypt.py' e 'flask_wtf/csrf.py'
RUN sed -i 's/from werkzeug.security import safe_str_cmp/from hmac import compare_digest as safe_str_cmp/' $(pip3 show flask-bcrypt | grep Location | cut -d' ' -f2)/flask_bcrypt.py && \
    sed -i 's/from werkzeug.security import safe_str_cmp/from hmac import compare_digest as safe_str_cmp/' $(pip3 show flask-wtf | grep Location | cut -d' ' -f2)/flask_wtf/csrf.py

# Substituir 'Markup' no 'flask_wtf/form.py'
RUN sed -i 's/from jinja2 import Markup/from markupsafe import Markup/' $(pip3 show flask-wtf | grep Location | cut -d' ' -f2)/flask_wtf/form.py

# Substituir o uso incorreto de JSONEncoder no flask_wtf/recaptcha/widgets.py
#RUN sed -i 's/JSONEncoder = json.encoder.JSONEncoder/JSONEncoder = json.dumps/' $(pip3 show flask-wtf | grep Location | cut -d' ' -f2)/flask_wtf/recaptcha/widgets.py
RUN sed -i 's/JSONEncoder = json.JSONEncoder/JSONEncoder = json.dumps/' $(pip3 show flask-wtf | grep Location | cut -d' ' -f2)/flask_wtf/recaptcha/widgets.py

# Exponha as portas 5000 para Flask e 8080 para ZAP
EXPOSE 5000
EXPOSE 8080

# Copie o resto do código da aplicação
COPY . .

# Copiar o arquivo .env
COPY .env .env

# Comando para rodar o ZAP e o servidor Flask
CMD ["sh", "-c", "/zap/zap.sh -daemon -host 0.0.0.0 -port 8080 & python3 todo_project/run.py"]

# Use a imagem oficial estável do OWASP ZAP
FROM ictu/zap2docker-weekly

# Defina o diretório de trabalho na imagem
WORKDIR /app

# Mudar para o usuário root para realizar as instalações
USER root

# Instale o wget, unzip, python3, pip e outras dependências
RUN apt-get update && apt-get install -y curl wget unzip python3 python3-pip

# Instale o gunicorn, python-dotenv e atualize o flask-wtf
RUN pip3 install gunicorn python-dotenv && pip3 install --upgrade flask-wtf

# Copie o arquivo requirements.txt e instale as dependências do Python
COPY requirements.txt requirements.txt
RUN pip3 install -r requirements.txt

# Substituir 'safe_str_cmp' no 'flask_bcrypt.py' e 'flask_wtf/csrf.py'
RUN sed -i 's/from werkzeug.security import safe_str_cmp/from hmac import compare_digest as safe_str_cmp/' $(pip3 show flask-bcrypt | grep Location | cut -d' ' -f2)/flask_bcrypt.py && \
    sed -i 's/from werkzeug.security import safe_str_cmp/from hmac import compare_digest as safe_str_cmp/' $(pip3 show flask-wtf | grep Location | cut -d' ' -f2)/flask_wtf/csrf.py

# Substituir 'Markup' no 'flask_wtf/form.py'
RUN sed -i 's/from jinja2 import Markup/from markupsafe import Markup/' $(pip3 show flask-wtf | grep Location | cut -d' ' -f2)/flask_wtf/form.py

# Substituir o uso incorreto de JSONEncoder no flask_wtf/recaptcha/widgets.py
RUN sed -i 's/JSONEncoder = json.JSONEncoder/JSONEncoder = json.dumps/' $(pip3 show flask-wtf | grep Location | cut -d' ' -f2)/flask_wtf/recaptcha/widgets.py

# Retorne ao usuário zap após todas as instalações
USER zap

# Exponha as portas 5000 para Flask, 8080 para ZAP e 9000 para o Graylog
EXPOSE 5000
EXPOSE 8080
EXPOSE 9000

# Copie o resto do código da aplicação
COPY . .

# Torna o entrypoint.sh executável
USER root
RUN chmod +x /app/entrypoint.sh

# Volte para o usuário zap para executar o aplicativo
USER zap

# Comando para rodar o ZAP, esperar pelo Graylog e rodar o Flask
CMD ["/app/entrypoint.sh"]


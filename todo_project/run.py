import os
import time
import requests
from todo_project import app
import logging
from pygelf import GelfHttpHandler  # Atualizado para pygelf

# Função para esperar o Graylog estar disponível
def wait_for_graylog(graylog_url, retries=5, delay=5):
    for _ in range(retries):
        try:
            response = requests.get(graylog_url,timeout=5)
            if response.status_code == 200:
                app.logger.info("Graylog está disponível.")
                return True
        except requests.ConnectionError:
            app.logger.warning("Graylog não está disponível. Tentando novamente...")
            time.sleep(delay)
    app.logger.warning("Graylog não foi encontrado após várias tentativas. A aplicação continuará a iniciar.")
    return False

# Verifique se está no ambiente de desenvolvimento
if os.getenv('FLASK_ENV') == 'development':
    host = '0.0.0.0'  # nosec
else:
    host = '192.168.3.75'

# Verificar a disponibilidade do Graylog
graylog_url = 'http://192.168.3.75:12202'
if wait_for_graylog(graylog_url):
    app.logger.info("Iniciando aplicação Flask após Graylog estar disponível.")
else:
    app.logger.warning("Iniciando aplicação Flask sem conexão com o Graylog.")

# Configurando o handler para enviar logs via GELF HTTP
handler = GelfHttpHandler(host='192.168.3.75', port=12202)

# Adicionando o handler ao logger do Flask
app.logger.addHandler(handler)

# Exemplo de log
app.logger.info("Log enviado via GELF HTTP para o Graylog")

# Executar a aplicação Flask
app.run(host=host, port=5000)


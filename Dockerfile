# Use uma imagem base de Python
FROM python:3.11

# Defina o diretório de trabalho na imagem
WORKDIR /app

# Copie o arquivo requirements.txt e instale as dependências
COPY requirements.txt requirements.txt
RUN pip install -r requirements.txt

# Copie o resto do código da aplicação
COPY . .

# Exponha a porta 5000 para a aplicação Flask
EXPOSE 5000

# Comando para iniciar o servidor Flask
CMD ["python", "todo_project/run.py"]

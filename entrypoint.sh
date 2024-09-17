#!/bin/bash

# Inicia o OWASP ZAP em modo daemon
/zap/zap.sh -daemon -port 8080 -host 0.0.0.0 -config api.addrs.addr.regex=true -config api.addrs.addr.name=.* -config api.disablekey=true &

# Espera o Graylog estar disponível
echo "Esperando pelo Graylog..."
until curl -s -o /dev/null -w "%{http_code}" http://192.168.3.75:9000/api/system | grep "200"; do
    echo "Tentando acessar Graylog..."
    echo "Aguardando Graylog estar disponível..."
    sleep 10
done

echo "Graylog está disponível. Iniciando a aplicação Flask..."

# Inicia o Flask
exec python3 ./todo_project/run.py




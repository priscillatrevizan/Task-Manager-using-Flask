#!/bin/bash

# Inicia o OWASP ZAP em modo daemon
/zap/zap.sh -daemon -port 8080 -host 0.0.0.0 -config api.addrs.addr.regex=true -config api.addrs.addr.name=.* -config api.disablekey=true &

# Espera o Graylog estar disponível
echo "Esperando pelo Graylog..."
for i in {1..6}; do  # Espera até 1 minuto (6 * 10s)
  if curl -s -o /dev/null -w "%{http_code}" http://192.168.3.75:9000/api/system | grep -q "200"; then
    echo "Graylog está disponível. Iniciando a aplicação Flask..."
    break
  else
    echo "Aguardando Graylog estar disponível..."
    sleep 10
  fi
done

# Verifica se o Graylog está acessível após 1 minuto
if [ $i -eq 6 ]; then
  echo "Erro: Graylog não está disponível após 1 minuto. Encerrando."
  exit 1
fi

# Inicia o Flask
exec python3 ./todo_project/run.py



const ngrok = require('ngrok');

(async function () {
  try {
    // Conectar o ngrok ao OWASP ZAP na porta 8080
    const zapUrl = await ngrok.connect(8080);
    console.log(`OWASP ZAP está disponível em: ${zapUrl}`);

    // Conectar o ngrok ao Graylog na porta 9000
    const graylogUrl = await ngrok.connect(9000);
    console.log(`Graylog está disponível em: ${graylogUrl}`);
  } catch (error) {
    console.error('Erro ao conectar o ngrok:', error);
  }
})();

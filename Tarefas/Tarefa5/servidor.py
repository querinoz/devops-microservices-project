import http.server
import ssl

# Define a porta e o endereço
server_address = ('localhost', 443)

# Cria o servidor HTTP simples
httpd = http.server.HTTPServer(server_address, http.server.SimpleHTTPRequestHandler)

# Configura o contexto SSL (HTTPS)
context = ssl.SSLContext(ssl.PROTOCOL_TLS_SERVER)
context.load_cert_chain(certfile="cert.pem", keyfile="key.pem")

# Envolve o socket do servidor com a camada de segurança SSL
httpd.socket = context.wrap_socket(httpd.socket, server_side=True)

print("Servidor HTTPS https://localhost:443")
httpd.serve_forever()
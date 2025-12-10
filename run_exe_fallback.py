"""
Ponto de entrada alternativo para o executável Windows (sem PyWebView).

Este script inicia o servidor Flask em uma porta livre e abre o navegador
padrão do sistema para exibir a aplicação.

Use este arquivo se pywebview não puder ser instalado.
"""

import sys
import os
import socket
import threading
import time
import webbrowser
from pathlib import Path

# Adiciona o diretório do script ao path (importante para PyInstaller)
if getattr(sys, 'frozen', False):
    # Executável
    base_path = sys._MEIPASS
else:
    # Desenvolvimento
    base_path = os.path.dirname(os.path.abspath(__file__))

sys.path.insert(0, base_path)

try:
    from waitress import serve
    from app import create_app
except ImportError as e:
    print(f"ERRO: Dependência não encontrada: {e}")
    print("Instale as dependências com: pip install waitress")
    sys.exit(1)


def find_free_port(start_port=8000, max_attempts=100):
    """
    Encontra uma porta livre no localhost.
    
    Args:
        start_port: Porta inicial para tentar
        max_attempts: Número máximo de tentativas
        
    Returns:
        Número da porta livre ou None se não encontrar
    """
    for port in range(start_port, start_port + max_attempts):
        try:
            with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as s:
                s.bind(('127.0.0.1', port))
                return port
        except OSError:
            continue
    return None


def run_flask_server(app, host='127.0.0.1', port=8000):
    """
    Inicia o servidor Flask usando Waitress em uma thread separada.
    
    Args:
        app: Instância da aplicação Flask
        host: Host para bind
        port: Porta para bind
    """
    try:
        # Waitress é um servidor WSGI adequado para Windows
        serve(app, host=host, port=port, threads=4, channel_timeout=120)
    except Exception as e:
        print(f"ERRO ao iniciar servidor Flask: {e}", file=sys.stderr)


def main():
    """Função principal."""
    # Encontra uma porta livre
    port = find_free_port()
    if port is None:
        print("ERRO: Não foi possível encontrar uma porta livre.", file=sys.stderr)
        sys.exit(1)
    
    # Cria a aplicação Flask
    app = create_app()
    
    # URL local
    url = f"http://127.0.0.1:{port}"
    
    # Inicia o servidor Flask em uma thread separada
    server_thread = threading.Thread(
        target=run_flask_server,
        args=(app, '127.0.0.1', port),
        daemon=True
    )
    server_thread.start()
    
    # Aguarda um pouco para garantir que o servidor iniciou
    time.sleep(2)
    
    # Verifica se o servidor está respondendo
    try:
        import urllib.request
        response = urllib.request.urlopen(url, timeout=2)
        response.close()
    except Exception:
        print(f"AVISO: Servidor pode não ter iniciado corretamente. Tentando abrir navegador mesmo assim...")
    
    # Abre o navegador padrão
    print(f"Abrindo aplicação no navegador: {url}")
    print("Pressione Ctrl+C para encerrar o servidor.")
    print()
    
    try:
        webbrowser.open(url)
        
        # Mantém o servidor rodando
        try:
            while True:
                time.sleep(1)
        except KeyboardInterrupt:
            print("\nEncerrando servidor...")
            sys.exit(0)
            
    except Exception as e:
        print(f"ERRO ao abrir navegador: {e}", file=sys.stderr)
        print(f"Abra manualmente no navegador: {url}")
        # Mantém o servidor rodando
        try:
            while True:
                time.sleep(1)
        except KeyboardInterrupt:
            pass
    
    sys.exit(0)


if __name__ == "__main__":
    main()


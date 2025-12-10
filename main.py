"""
Ponto de entrada da aplicação PyQt6.

Inicializa o banco de dados e inicia a interface gráfica.
"""

import sys
import os
from pathlib import Path

# Adiciona o diretório do script ao path (importante para PyInstaller)
if getattr(sys, 'frozen', False):
    # Executável
    base_path = sys._MEIPASS
else:
    # Desenvolvimento
    base_path = os.path.dirname(os.path.abspath(__file__))

sys.path.insert(0, base_path)

from PyQt6.QtWidgets import QApplication, QMessageBox
from PyQt6.QtCore import Qt

from app.database.db_session import init_database
from app.database.direct import init_db_data
from app.gui.main_window import MainWindow


def main():
    """Função principal."""
    # Detecta se está rodando como executável
    is_frozen = getattr(sys, 'frozen', False)
    
    # Configura aplicação Qt
    # Estes atributos podem não estar disponíveis em versões antigas do Qt
    try:
        QApplication.setAttribute(Qt.ApplicationAttribute.AA_EnableHighDpiScaling, True)
        QApplication.setAttribute(Qt.ApplicationAttribute.AA_UseHighDpiPixmaps, True)
    except AttributeError:
        # Versões antigas do Qt não têm esses atributos
        pass
    
    app = QApplication(sys.argv)
    app.setApplicationName("Extrator DARF")
    app.setOrganizationName("Extrator DARF")
    
    # Inicializa banco de dados
    try:
        init_database()
        # Popula dados padrão se necessário
        init_db_data()
    except Exception as e:
        # Tenta mostrar mensagem, mas se falhar (ex: em modo sem GUI), imprime no console
        try:
            QMessageBox.critical(
                None,
                "Erro ao inicializar banco de dados",
                f"Erro ao inicializar o banco de dados:\n{str(e)}\n\n"
                "A aplicação será fechada."
            )
        except Exception:
            print(f"ERRO ao inicializar banco de dados: {e}", file=sys.stderr)
            if not is_frozen:
                input("Pressione Enter para sair...")
        sys.exit(1)
    
    # Cria e mostra janela principal
    try:
        window = MainWindow()
        window.show()
        
        # Executa loop de eventos
        sys.exit(app.exec())
    except Exception as e:
        # Tenta mostrar mensagem, mas se falhar (ex: em modo sem GUI), imprime no console
        try:
            QMessageBox.critical(
                None,
                "Erro fatal",
                f"Erro ao iniciar a aplicação:\n{str(e)}\n\n"
                "A aplicação será fechada."
            )
        except Exception:
            print(f"ERRO fatal: {e}", file=sys.stderr)
            import traceback
            traceback.print_exc()
            if not is_frozen:
                input("Pressione Enter para sair...")
        sys.exit(1)


if __name__ == "__main__":
    main()


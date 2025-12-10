"""
Janela principal da aplicação PyQt6.
"""

from PyQt6.QtWidgets import (
    QMainWindow,
    QTabWidget,
    QWidget,
    QVBoxLayout,
    QMenuBar,
    QStatusBar,
    QMessageBox,
)
from PyQt6.QtCore import Qt
from PyQt6.QtGui import QAction

from app.gui.upload_widget import UploadWidget
from app.gui.rules_widget import RulesWidget


class MainWindow(QMainWindow):
    """Janela principal da aplicação."""
    
    def __init__(self):
        super().__init__()
        self.setWindowTitle("Extrator de Informações DARF")
        self.setMinimumSize(900, 700)
        self.resize(1200, 800)
        
        # Cria widget central e layout
        central_widget = QWidget()
        self.setCentralWidget(central_widget)
        layout = QVBoxLayout(central_widget)
        layout.setContentsMargins(10, 10, 10, 10)
        
        # Cria tabs
        self.tabs = QTabWidget()
        layout.addWidget(self.tabs)
        
        # Aba 1: Upload e processamento
        self.upload_widget = UploadWidget()
        self.tabs.addTab(self.upload_widget, "Processar PDFs")
        
        # Aba 2: Gerenciamento de regras
        self.rules_widget = RulesWidget()
        self.tabs.addTab(self.rules_widget, "Gerenciar Regras")
        
        # Cria menu bar
        self._create_menu_bar()
        
        # Cria status bar
        self.status_bar = QStatusBar()
        self.setStatusBar(self.status_bar)
        self.status_bar.showMessage("Pronto")
        
        # Conecta sinais
        self.upload_widget.status_message.connect(self.status_bar.showMessage)
        self.rules_widget.status_message.connect(self.status_bar.showMessage)
    
    def _create_menu_bar(self):
        """Cria a barra de menus."""
        menu_bar = self.menuBar()
        
        # Menu Arquivo
        file_menu = menu_bar.addMenu("Arquivo")
        
        exit_action = QAction("Sair", self)
        exit_action.setShortcut("Ctrl+Q")
        exit_action.triggered.connect(self.close)
        file_menu.addAction(exit_action)
        
        # Menu Ajuda
        help_menu = menu_bar.addMenu("Ajuda")
        
        about_action = QAction("Sobre", self)
        about_action.triggered.connect(self._show_about)
        help_menu.addAction(about_action)
    
    def _show_about(self):
        """Mostra diálogo Sobre."""
        QMessageBox.about(
            self,
            "Sobre",
            "<h2>Extrator de Informações DARF</h2>"
            "<p>Versão 1.0</p>"
            "<p>Aplicação para extrair informações de PDFs de DARF e gerar arquivos Excel consolidados.</p>"
            "<p>Desenvolvido com PyQt6.</p>"
        )
    
    def closeEvent(self, event):
        """Evento de fechamento da janela."""
        # Cancela processamento em andamento se houver
        if hasattr(self.upload_widget, 'worker') and self.upload_widget.worker and self.upload_widget.worker.isRunning():
            reply = QMessageBox.question(
                self,
                "Processamento em andamento",
                "Há um processamento em andamento. Deseja cancelar e sair?",
                QMessageBox.StandardButton.Yes | QMessageBox.StandardButton.No,
                QMessageBox.StandardButton.No
            )
            
            if reply == QMessageBox.StandardButton.Yes:
                if hasattr(self.upload_widget, 'worker') and self.upload_widget.worker:
                    self.upload_widget.worker.cancel()
                    if self.upload_widget.worker.isRunning():
                        self.upload_widget.worker.wait(3000)  # Aguarda até 3 segundos
                event.accept()
            else:
                event.ignore()
        else:
            event.accept()


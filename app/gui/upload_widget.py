"""
Widget de upload e processamento de PDFs.
"""

from pathlib import Path
from datetime import datetime
from typing import List

from PyQt6.QtWidgets import (
    QWidget,
    QVBoxLayout,
    QHBoxLayout,
    QPushButton,
    QListWidget,
    QListWidgetItem,
    QLabel,
    QProgressBar,
    QFileDialog,
    QMessageBox,
)
from PyQt6.QtCore import Qt, pyqtSignal
from PyQt6.QtGui import QDragEnterEvent, QDropEvent

from app.gui.widgets import ProcessPdfWorker


class UploadWidget(QWidget):
    """Widget para upload e processamento de PDFs."""
    
    status_message = pyqtSignal(str)
    
    def __init__(self):
        super().__init__()
        self.pdf_files: List[Path] = []
        self.worker = None
        self._init_ui()
        
        # Habilita drag and drop
        self.setAcceptDrops(True)
    
    def _init_ui(self):
        """Inicializa a interface."""
        layout = QVBoxLayout(self)
        layout.setSpacing(10)
        
        # Título e instruções
        title_label = QLabel("<h2>📄 Extrator de Informações DARF</h2>")
        layout.addWidget(title_label)
        
        info_label = QLabel(
            "Envie um ou mais arquivos PDF de DARF e receba um arquivo Excel "
            "com as informações extraídas."
        )
        info_label.setWordWrap(True)
        layout.addWidget(info_label)
        
        # Área de drag and drop
        drop_area = QLabel(
            "<b>Arraste e solte os arquivos PDF aqui</b><br>"
            "Ou clique em 'Selecionar Arquivos' para escolher"
        )
        drop_area.setAlignment(Qt.AlignmentFlag.AlignCenter)
        drop_area.setStyleSheet(
            """
            QLabel {
                border: 2px dashed #aaa;
                border-radius: 10px;
                padding: 40px;
                background-color: #f9f9f9;
                min-height: 150px;
            }
            QLabel:hover {
                border-color: #0078d4;
                background-color: #f0f8ff;
            }
            """
        )
        drop_area.setAcceptDrops(True)
        layout.addWidget(drop_area)
        self.drop_area = drop_area
        
        # Botões
        buttons_layout = QHBoxLayout()
        
        self.select_button = QPushButton("Selecionar Arquivos")
        self.select_button.clicked.connect(self._select_files)
        buttons_layout.addWidget(self.select_button)
        
        self.clear_button = QPushButton("Limpar Seleção")
        self.clear_button.clicked.connect(self._clear_files)
        self.clear_button.setEnabled(False)
        buttons_layout.addWidget(self.clear_button)
        
        buttons_layout.addStretch()
        layout.addLayout(buttons_layout)
        
        # Lista de arquivos
        files_label = QLabel("<b>Arquivos selecionados:</b>")
        layout.addWidget(files_label)
        
        self.files_list = QListWidget()
        self.files_list.setMaximumHeight(200)
        layout.addWidget(self.files_list)
        
        # Barra de progresso
        self.progress_bar = QProgressBar()
        self.progress_bar.setVisible(False)
        self.progress_bar.setTextVisible(True)
        layout.addWidget(self.progress_bar)
        
        # Botão de processar
        self.process_button = QPushButton("Processar PDFs")
        self.process_button.setStyleSheet(
            """
            QPushButton {
                background-color: #0078d4;
                color: white;
                padding: 10px;
                font-size: 14px;
                font-weight: bold;
                border-radius: 5px;
            }
            QPushButton:hover {
                background-color: #106ebe;
            }
            QPushButton:disabled {
                background-color: #ccc;
            }
            """
        )
        self.process_button.clicked.connect(self._process_files)
        self.process_button.setEnabled(False)
        layout.addWidget(self.process_button)
        
        layout.addStretch()
    
    def dragEnterEvent(self, event: QDragEnterEvent):
        """Evento quando arquivo é arrastado sobre o widget."""
        if event.mimeData().hasUrls():
            # Verifica se há pelo menos um arquivo PDF
            urls = event.mimeData().urls()
            for url in urls:
                if url.toLocalFile().lower().endswith('.pdf'):
                    event.acceptProposedAction()
                    self.drop_area.setStyleSheet(
                        """
                        QLabel {
                            border: 2px dashed #0078d4;
                            border-radius: 10px;
                            padding: 40px;
                            background-color: #e6f3ff;
                            min-height: 150px;
                        }
                        """
                    )
                    return
        event.ignore()
    
    def dragLeaveEvent(self, event):
        """Evento quando arquivo sai da área de drag."""
        self.drop_area.setStyleSheet(
            """
            QLabel {
                border: 2px dashed #aaa;
                border-radius: 10px;
                padding: 40px;
                background-color: #f9f9f9;
                min-height: 150px;
            }
            QLabel:hover {
                border-color: #0078d4;
                background-color: #f0f8ff;
            }
            """
        )
    
    def dropEvent(self, event: QDropEvent):
        """Evento quando arquivo é solto no widget."""
        self.drop_area.setStyleSheet(
            """
            QLabel {
                border: 2px dashed #aaa;
                border-radius: 10px;
                padding: 40px;
                background-color: #f9f9f9;
                min-height: 150px;
            }
            QLabel:hover {
                border-color: #0078d4;
                background-color: #f0f8ff;
            }
            """
        )
        
        if event.mimeData().hasUrls():
            files = []
            for url in event.mimeData().urls():
                file_path = Path(url.toLocalFile())
                if file_path.is_file() and file_path.suffix.lower() == '.pdf':
                    files.append(file_path)
            
            if files:
                self._add_files(files)
                event.acceptProposedAction()
            else:
                QMessageBox.warning(
                    self,
                    "Arquivos inválidos",
                    "Por favor, arraste apenas arquivos PDF."
                )
    
    def _select_files(self):
        """Abre diálogo para selecionar arquivos."""
        files, _ = QFileDialog.getOpenFileNames(
            self,
            "Selecionar arquivos PDF",
            "",
            "Arquivos PDF (*.pdf)"
        )
        
        if files:
            pdf_files = [Path(f) for f in files if Path(f).suffix.lower() == '.pdf']
            if pdf_files:
                self._add_files(pdf_files)
    
    def _add_files(self, files: List[Path]):
        """Adiciona arquivos à lista."""
        # Remove duplicatas
        existing_paths = {f for f in self.pdf_files}
        new_files = [f for f in files if f not in existing_paths]
        
        if not new_files:
            return
        
        self.pdf_files.extend(new_files)
        self._update_files_list()
        self.clear_button.setEnabled(True)
        self.process_button.setEnabled(True)
    
    def _clear_files(self):
        """Limpa a lista de arquivos."""
        self.pdf_files.clear()
        self._update_files_list()
        self.clear_button.setEnabled(False)
        self.process_button.setEnabled(False)
    
    def _update_files_list(self):
        """Atualiza a lista de arquivos na interface."""
        self.files_list.clear()
        for file_path in self.pdf_files:
            item = QListWidgetItem(file_path.name)
            item.setData(Qt.ItemDataRole.UserRole, file_path)
            self.files_list.addItem(item)
    
    def _process_files(self):
        """Inicia o processamento dos PDFs."""
        if not self.pdf_files:
            QMessageBox.warning(self, "Nenhum arquivo", "Por favor, selecione pelo menos um arquivo PDF.")
            return
        
        # Pede ao usuário onde salvar o arquivo
        timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
        default_filename = f"resultado_darfs_{timestamp}.xlsx"
        
        output_path, _ = QFileDialog.getSaveFileName(
            self,
            "Salvar arquivo Excel",
            default_filename,
            "Arquivos Excel (*.xlsx)"
        )
        
        if not output_path:
            return
        
        output_path = Path(output_path)
        
        # Desabilita botões durante processamento
        self.select_button.setEnabled(False)
        self.clear_button.setEnabled(False)
        self.process_button.setEnabled(False)
        
        # Mostra barra de progresso
        self.progress_bar.setVisible(True)
        self.progress_bar.setRange(0, 0)  # Progresso indefinido
        
        # Cria e inicia worker thread
        self.worker = ProcessPdfWorker(self.pdf_files, output_path)
        self.worker.progress.connect(self._on_progress)
        self.worker.finished.connect(self._on_finished)
        self.worker.error.connect(self._on_error)
        self.worker.start()
    
    def _on_progress(self, message: str):
        """Callback de progresso."""
        self.progress_bar.setFormat(message)
        self.status_message.emit(message)
    
    def _on_finished(self, output_path: str, success: bool, message: str):
        """Callback quando processamento termina."""
        self.progress_bar.setVisible(False)
        
        # Reabilita botões
        self.select_button.setEnabled(True)
        self.clear_button.setEnabled(True)
        self.process_button.setEnabled(True)
        
        if success:
            QMessageBox.information(
                self,
                "Processamento concluído",
                f"{message}\n\nArquivo salvo em:\n{output_path}"
            )
            self.status_message.emit("Processamento concluído com sucesso!")
            # Opcional: limpar arquivos após sucesso
            # self._clear_files()
        else:
            self.status_message.emit("Erro no processamento")
    
    def _on_error(self, error_message: str):
        """Callback de erro."""
        self.progress_bar.setVisible(False)
        
        # Reabilita botões
        self.select_button.setEnabled(True)
        self.clear_button.setEnabled(True)
        self.process_button.setEnabled(True)
        
        QMessageBox.critical(self, "Erro", error_message)
        self.status_message.emit(f"Erro: {error_message}")


"""
Widget de gerenciamento de regras (códigos e CNPJs).
"""

from PyQt6.QtWidgets import (
    QWidget,
    QVBoxLayout,
    QHBoxLayout,
    QTabWidget,
    QLabel,
    QLineEdit,
    QPushButton,
    QTableWidget,
    QTableWidgetItem,
    QComboBox,
    QHeaderView,
    QMessageBox,
)
from PyQt6.QtCore import Qt, pyqtSignal

from app.database.direct import (
    get_todos_codigos,
    get_todos_cnpjs,
    adicionar_codigo,
    remover_codigo,
    adicionar_cnpj,
    remover_cnpj,
)


class RulesWidget(QWidget):
    """Widget para gerenciamento de regras."""
    
    status_message = pyqtSignal(str)
    
    def __init__(self):
        super().__init__()
        self._init_ui()
        self._load_rules()
    
    def _init_ui(self):
        """Inicializa a interface."""
        layout = QVBoxLayout(self)
        layout.setSpacing(10)
        
        # Título
        title_label = QLabel("<h2>⚙️ Gerenciar Regras</h2>")
        layout.addWidget(title_label)
        
        desc_label = QLabel(
            "Gerencie as regras de mapeamento que determinam como os PDFs são processados."
        )
        desc_label.setWordWrap(True)
        layout.addWidget(desc_label)
        
        # Tabs
        self.tabs = QTabWidget()
        layout.addWidget(self.tabs)
        
        # Tab 1: Códigos → Abas
        self.codigos_tab = self._create_codigos_tab()
        self.tabs.addTab(self.codigos_tab, "Códigos → Abas")
        
        # Tab 2: CNPJ → UO Contribuinte
        self.cnpjs_tab = self._create_cnpjs_tab()
        self.tabs.addTab(self.cnpjs_tab, "CNPJ → UO Contribuinte")
    
    def _create_codigos_tab(self) -> QWidget:
        """Cria a aba de gerenciamento de códigos."""
        widget = QWidget()
        layout = QVBoxLayout(widget)
        layout.setSpacing(10)
        
        # Descrição
        desc = QLabel("Defina quais códigos extraídos do PDF devem ir para a aba 'servidor' ou 'patronal-gilrat'.")
        desc.setWordWrap(True)
        layout.addWidget(desc)
        
        # Formulário
        form_layout = QHBoxLayout()
        
        codigo_label = QLabel("Código (4 dígitos):")
        self.codigo_input = QLineEdit()
        self.codigo_input.setPlaceholderText("Ex: 1082")
        self.codigo_input.setMaxLength(4)
        form_layout.addWidget(codigo_label)
        form_layout.addWidget(self.codigo_input)
        
        aba_label = QLabel("Aba:")
        self.aba_combo = QComboBox()
        self.aba_combo.addItems(["", "servidor", "patronal-gilrat"])
        form_layout.addWidget(aba_label)
        form_layout.addWidget(self.aba_combo)
        
        add_codigo_button = QPushButton("Adicionar")
        add_codigo_button.clicked.connect(self._add_codigo)
        form_layout.addWidget(add_codigo_button)
        
        layout.addLayout(form_layout)
        
        # Tabela
        self.codigos_table = QTableWidget()
        self.codigos_table.setColumnCount(3)
        self.codigos_table.setHorizontalHeaderLabels(["Código", "Aba", "Ações"])
        self.codigos_table.horizontalHeader().setStretchLastSection(True)
        self.codigos_table.horizontalHeader().setSectionResizeMode(0, QHeaderView.ResizeMode.ResizeToContents)
        self.codigos_table.horizontalHeader().setSectionResizeMode(1, QHeaderView.ResizeMode.ResizeToContents)
        layout.addWidget(self.codigos_table)
        
        return widget
    
    def _create_cnpjs_tab(self) -> QWidget:
        """Cria a aba de gerenciamento de CNPJs."""
        widget = QWidget()
        layout = QVBoxLayout(widget)
        layout.setSpacing(10)
        
        # Descrição
        desc = QLabel("Defina o mapeamento entre CNPJs e seus códigos de UO Contribuinte correspondentes.")
        desc.setWordWrap(True)
        layout.addWidget(desc)
        
        # Formulário
        form_layout = QHBoxLayout()
        
        cnpj_label = QLabel("CNPJ:")
        self.cnpj_input = QLineEdit()
        self.cnpj_input.setPlaceholderText("Ex: 18.715.565/0001-10")
        form_layout.addWidget(cnpj_label)
        form_layout.addWidget(self.cnpj_input)
        
        uo_label = QLabel("UO Contribuinte:")
        self.uo_input = QLineEdit()
        self.uo_input.setPlaceholderText("Ex: 1071")
        form_layout.addWidget(uo_label)
        form_layout.addWidget(self.uo_input)
        
        add_cnpj_button = QPushButton("Adicionar")
        add_cnpj_button.clicked.connect(self._add_cnpj)
        form_layout.addWidget(add_cnpj_button)
        
        layout.addLayout(form_layout)
        
        # Tabela
        self.cnpjs_table = QTableWidget()
        self.cnpjs_table.setColumnCount(3)
        self.cnpjs_table.setHorizontalHeaderLabels(["CNPJ", "UO Contribuinte", "Ações"])
        self.cnpjs_table.horizontalHeader().setStretchLastSection(True)
        self.cnpjs_table.horizontalHeader().setSectionResizeMode(0, QHeaderView.ResizeMode.ResizeToContents)
        self.cnpjs_table.horizontalHeader().setSectionResizeMode(1, QHeaderView.ResizeMode.ResizeToContents)
        layout.addWidget(self.cnpjs_table)
        
        return widget
    
    def _load_rules(self):
        """Carrega as regras do banco de dados."""
        self._load_codigos()
        self._load_cnpjs()
    
    def _load_codigos(self):
        """Carrega códigos na tabela."""
        try:
            codigos = get_todos_codigos()
            self.codigos_table.setRowCount(len(codigos))
            
            for row, item in enumerate(codigos):
                # Código
                codigo_item = QTableWidgetItem(item['codigo'])
                codigo_item.setFlags(codigo_item.flags() & ~Qt.ItemFlag.ItemIsEditable)
                self.codigos_table.setItem(row, 0, codigo_item)
                
                # Aba
                aba_text = "Servidor" if item['aba'] == "servidor" else "Patronal-GILRAT"
                aba_item = QTableWidgetItem(aba_text)
                aba_item.setFlags(aba_item.flags() & ~Qt.ItemFlag.ItemIsEditable)
                self.codigos_table.setItem(row, 1, aba_item)
                
                # Botão remover
                remove_button = QPushButton("🗑️ Remover")
                remove_button.clicked.connect(
                    lambda checked, cod=item['codigo']: self._remove_codigo(cod)
                )
                self.codigos_table.setCellWidget(row, 2, remove_button)
        except Exception as e:
            QMessageBox.critical(self, "Erro", f"Erro ao carregar códigos: {str(e)}")
            self.status_message.emit(f"Erro ao carregar códigos: {str(e)}")
    
    def _load_cnpjs(self):
        """Carrega CNPJs na tabela."""
        try:
            cnpjs = get_todos_cnpjs()
            self.cnpjs_table.setRowCount(len(cnpjs))
            
            for row, item in enumerate(cnpjs):
                # CNPJ
                cnpj_item = QTableWidgetItem(item['cnpj'])
                cnpj_item.setFlags(cnpj_item.flags() & ~Qt.ItemFlag.ItemIsEditable)
                self.cnpjs_table.setItem(row, 0, cnpj_item)
                
                # UO Contribuinte
                uo_item = QTableWidgetItem(item['uo_contribuinte'])
                uo_item.setFlags(uo_item.flags() & ~Qt.ItemFlag.ItemIsEditable)
                self.cnpjs_table.setItem(row, 1, uo_item)
                
                # Botão remover
                remove_button = QPushButton("🗑️ Remover")
                remove_button.clicked.connect(
                    lambda checked, cnpj=item['cnpj']: self._remove_cnpj(cnpj)
                )
                self.cnpjs_table.setCellWidget(row, 2, remove_button)
        except Exception as e:
            QMessageBox.critical(self, "Erro", f"Erro ao carregar CNPJs: {str(e)}")
            self.status_message.emit(f"Erro ao carregar CNPJs: {str(e)}")
    
    def _add_codigo(self):
        """Adiciona um novo código."""
        codigo = self.codigo_input.text().strip()
        aba = self.aba_combo.currentText().strip()
        
        if not codigo or not aba:
            QMessageBox.warning(self, "Campos obrigatórios", "Por favor, preencha todos os campos.")
            return
        
        sucesso, mensagem = adicionar_codigo(codigo, aba)
        
        if sucesso:
            QMessageBox.information(self, "Sucesso", mensagem)
            self.status_message.emit(mensagem)
            self.codigo_input.clear()
            self.aba_combo.setCurrentIndex(0)
            self._load_codigos()
        else:
            QMessageBox.warning(self, "Erro", mensagem)
            self.status_message.emit(f"Erro: {mensagem}")
    
    def _remove_codigo(self, codigo: str):
        """Remove um código."""
        reply = QMessageBox.question(
            self,
            "Confirmar remoção",
            f"Tem certeza que deseja remover o código {codigo}?",
            QMessageBox.StandardButton.Yes | QMessageBox.StandardButton.No,
            QMessageBox.StandardButton.No
        )
        
        if reply == QMessageBox.StandardButton.Yes:
            sucesso, mensagem = remover_codigo(codigo)
            
            if sucesso:
                QMessageBox.information(self, "Sucesso", mensagem)
                self.status_message.emit(mensagem)
                self._load_codigos()
            else:
                QMessageBox.warning(self, "Erro", mensagem)
                self.status_message.emit(f"Erro: {mensagem}")
    
    def _add_cnpj(self):
        """Adiciona um novo CNPJ."""
        cnpj = self.cnpj_input.text().strip()
        uo = self.uo_input.text().strip()
        
        if not cnpj or not uo:
            QMessageBox.warning(self, "Campos obrigatórios", "Por favor, preencha todos os campos.")
            return
        
        sucesso, mensagem = adicionar_cnpj(cnpj, uo)
        
        if sucesso:
            QMessageBox.information(self, "Sucesso", mensagem)
            self.status_message.emit(mensagem)
            self.cnpj_input.clear()
            self.uo_input.clear()
            self._load_cnpjs()
        else:
            QMessageBox.warning(self, "Erro", mensagem)
            self.status_message.emit(f"Erro: {mensagem}")
    
    def _remove_cnpj(self, cnpj: str):
        """Remove um CNPJ."""
        reply = QMessageBox.question(
            self,
            "Confirmar remoção",
            f"Tem certeza que deseja remover o CNPJ {cnpj}?",
            QMessageBox.StandardButton.Yes | QMessageBox.StandardButton.No,
            QMessageBox.StandardButton.No
        )
        
        if reply == QMessageBox.StandardButton.Yes:
            sucesso, mensagem = remover_cnpj(cnpj)
            
            if sucesso:
                QMessageBox.information(self, "Sucesso", mensagem)
                self.status_message.emit(mensagem)
                self._load_cnpjs()
            else:
                QMessageBox.warning(self, "Erro", mensagem)
                self.status_message.emit(f"Erro: {mensagem}")


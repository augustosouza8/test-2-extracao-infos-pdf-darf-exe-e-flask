"""
Widgets auxiliares e threads para processamento assíncrono.
"""

from PyQt6.QtCore import QThread, pyqtSignal
from pathlib import Path
from typing import List

from app.services.pdf_parser import processar_pdf
from app.services.excel_generator import (
    formatar_linha_servidor,
    formatar_linha_patronal_gilrat,
    gerar_excel,
)
from app.utils.errors import coletar_erros_registro
from app.database.direct import get_aba_por_codigo


class ProcessPdfWorker(QThread):
    """
    Worker thread para processar PDFs de forma assíncrona.
    
    Evita travar a interface durante o processamento.
    """
    
    # Sinais para comunicação com a UI
    progress = pyqtSignal(str)  # Mensagem de progresso
    finished = pyqtSignal(str, bool, str)  # (caminho_excel, sucesso, mensagem)
    error = pyqtSignal(str)  # Mensagem de erro
    
    def __init__(self, pdf_files: List[Path], output_path: Path):
        super().__init__()
        self.pdf_files = pdf_files
        self.output_path = output_path
        self._cancelled = False
    
    def cancel(self):
        """Cancela o processamento."""
        self._cancelled = True
    
    def run(self):
        """Executa o processamento dos PDFs."""
        try:
            registros = []
            
            # Processa cada PDF
            for idx, pdf_path in enumerate(self.pdf_files):
                if self._cancelled:
                    self.error.emit("Processamento cancelado pelo usuário.")
                    return
                
                self.progress.emit(f"Processando {pdf_path.name} ({idx + 1}/{len(self.pdf_files)})...")
                
                try:
                    # processar_pdf retorna uma lista de resultados (um por página)
                    resultados_paginas = processar_pdf(pdf_path)
                    registros.extend(resultados_paginas)
                except Exception as e:
                    # Caso o PDF dê erro, registramos uma linha com os campos em None
                    filename = pdf_path.name
                    registros.append({
                        "arquivo": f"{filename} - Página 1",
                        "cnpj": None,
                        "cnpj_erro": f"Erro ao processar PDF: {str(e)}",
                        "razao_social": None,
                        "razao_social_erro": f"Erro ao processar PDF: {str(e)}",
                        "periodo_apuracao": None,
                        "periodo_apuracao_erro": f"Erro ao processar PDF: {str(e)}",
                        "data_vencimento": None,
                        "data_vencimento_erro": f"Erro ao processar PDF: {str(e)}",
                        "numero_documento": None,
                        "numero_documento_erro": f"Erro ao processar PDF: {str(e)}",
                        "valor_total_documento": None,
                        "valor_total_documento_erro": f"Erro ao processar PDF: {str(e)}",
                        "codigo": None,
                        "codigo_erro": f"Erro ao processar PDF: {str(e)}",
                        "denominacao": None,
                        "denominacao_erro": f"Erro ao processar PDF: {str(e)}",
                        "linha_digitavel": None,
                        "linha_digitavel_erro": f"Erro ao processar PDF: {str(e)}",
                    })
            
            if self._cancelled:
                self.error.emit("Processamento cancelado pelo usuário.")
                return
            
            if not registros:
                self.error.emit("Nenhum arquivo foi processado com sucesso.")
                return
            
            # Separa registros por aba baseado no código e coleta erros
            self.progress.emit("Organizando resultados...")
            registros_servidor = []
            registros_patronal = []
            todos_erros = []
            
            for registro in registros:
                # Coleta erros do registro
                erros_registro = coletar_erros_registro(registro)
                todos_erros.extend(erros_registro)
                
                # Separa por aba
                codigo = registro.get("codigo", "")
                aba = get_aba_por_codigo(codigo)
                
                if aba == "servidor":
                    linha_formatada = formatar_linha_servidor(registro)
                    registros_servidor.append(linha_formatada)
                elif aba == "patronal-gilrat":
                    linha_formatada = formatar_linha_patronal_gilrat(registro)
                    registros_patronal.append(linha_formatada)
            
            if self._cancelled:
                self.error.emit("Processamento cancelado pelo usuário.")
                return
            
            # Gera o Excel
            self.progress.emit("Gerando arquivo Excel...")
            gerar_excel(registros_servidor, registros_patronal, todos_erros, self.output_path)
            
            self.finished.emit(
                str(self.output_path),
                True,
                f"Processamento concluído! {len(registros)} registro(s) processado(s)."
            )
            
        except Exception as e:
            self.error.emit(f"Erro durante o processamento: {str(e)}")


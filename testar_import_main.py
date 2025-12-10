"""Script para testar se o main.py pode ser importado corretamente."""

import sys
from pathlib import Path

# Adiciona o diretório do projeto ao path
base_path = Path(__file__).parent
sys.path.insert(0, str(base_path))

try:
    print("Testando import do main.py...")
    import main
    print("[OK] main.py importado com sucesso")
    
    print("\nTestando import do MainWindow...")
    from app.gui.main_window import MainWindow
    print("[OK] MainWindow importado com sucesso")
    
    print("\nTestando import dos modelos...")
    from app.models_direct import CodigoAba, CnpjUo
    print("[OK] Modelos importados com sucesso")
    
    print("\nTestando import dos serviços...")
    from app.services.pdf_parser import processar_pdf
    from app.services.excel_generator import gerar_excel
    print("[OK] Serviços importados com sucesso")
    
    print("\n[SUCESSO] Todos os imports funcionaram corretamente!")
    print("O PyInstaller deve conseguir gerar o executavel.")
    sys.exit(0)
    
except ImportError as e:
    print(f"\n[ERRO] Falha ao importar: {e}")
    print("\nVerifique se todas as dependencias estao instaladas.")
    sys.exit(1)
except Exception as e:
    print(f"\n[ERRO] Erro inesperado: {e}")
    import traceback
    traceback.print_exc()
    sys.exit(1)


"""
Script simplificado para baixar modelos OCR usando apenas bibliotecas padrão do Python.
Não requer requests ou tqdm instalados.
"""

import os
import sys
from pathlib import Path
from urllib.request import urlretrieve
from urllib.error import URLError

# URLs dos modelos RapidOCR
MODEL_BASE_URL = "https://github.com/RapidAI/RapidOCR/releases/download/v1.4.0"

MODELS = {
    "ch_PP-OCRv3_det_infer.onnx": f"{MODEL_BASE_URL}/ch_PP-OCRv3_det_infer.onnx",
    "ch_PP-OCRv3_rec_infer.onnx": f"{MODEL_BASE_URL}/ch_PP-OCRv3_rec_infer.onnx",
    "ch_ppocr_mobile_v2.0_cls_infer.onnx": f"{MODEL_BASE_URL}/ch_ppocr_mobile_v2.0_cls_infer.onnx",
}


def download_file(url: str, dest_path: Path) -> bool:
    """
    Baixa um arquivo de uma URL usando urllib (biblioteca padrão).
    """
    try:
        print(f"  Baixando {dest_path.name}...")
        print(f"  URL: {url}")
        
        def show_progress(block_num, block_size, total_size):
            if total_size > 0:
                percent = min(100, (block_num * block_size * 100) // total_size)
                print(f"\r  Progresso: {percent}%", end='', flush=True)
        
        urlretrieve(url, dest_path, show_progress)
        print()  # Nova linha após progresso
        print(f"  [OK] {dest_path.name} baixado com sucesso")
        return True
    except URLError as e:
        print(f"\n  [ERRO] Erro de conexao: {e}")
        return False
    except Exception as e:
        print(f"\n  [ERRO] Erro: {e}")
        return False


def main():
    """Função principal."""
    # Diretório base do projeto
    base_dir = Path(__file__).parent
    models_dir = base_dir / "ocr_models"
    
    # Cria diretório se não existir
    models_dir.mkdir(exist_ok=True)
    print(f"Diretório de modelos: {models_dir}")
    print()
    
    # Verifica quais modelos já existem
    missing_models = []
    for model_name, model_url in MODELS.items():
        model_path = models_dir / model_name
        if model_path.exists():
            size_mb = model_path.stat().st_size / (1024 * 1024)
            print(f"[OK] {model_name} ja existe ({size_mb:.1f} MB)")
        else:
            missing_models.append((model_name, model_url, model_path))
    
    if not missing_models:
        print("\n[OK] Todos os modelos ja estao baixados!")
        return
    
    print(f"\nBaixando {len(missing_models)} modelo(s)...")
    print("(Isso pode demorar alguns minutos dependendo da sua conexão)")
    print()
    
    # Baixa modelos faltantes
    success_count = 0
    for model_name, model_url, model_path in missing_models:
        print(f"Modelo: {model_name}")
        if download_file(model_url, model_path):
            success_count += 1
        print()
    
    # Resumo
    print("=" * 60)
    if success_count == len(missing_models):
        print(f"[OK] Todos os {success_count} modelo(s) foram baixados com sucesso!")
        print(f"\nModelos salvos em: {models_dir}")
        print("\nAgora você pode gerar o executável com PyInstaller.")
    else:
        print(f"[AVISO] {success_count} de {len(missing_models)} modelo(s) foram baixados.")
        print("Alguns downloads falharam. Verifique sua conexão e tente novamente.")
        print("\nVocê pode tentar baixar manualmente de:")
        print("https://github.com/RapidAI/RapidOCR/releases/download/v1.4.0/")
    print("=" * 60)


if __name__ == "__main__":
    main()


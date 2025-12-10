"""
Script para baixar modelos OCR do RapidOCR para uso offline no executável.

Este script baixa os modelos .onnx padrão do RapidOCR e os salva na pasta
ocr_models/ para serem incorporados no executável pelo PyInstaller.

Execute este script antes de gerar o executável:
    python download_models.py
"""

import os
import sys
import shutil
from pathlib import Path

# URLs alternativas dos modelos RapidOCR
# Tentativa 1: Repositório oficial RapidOCR
MODEL_BASE_URL_1 = "https://github.com/RapidAI/RapidOCR/releases/download/v1.4.0"
# Tentativa 2: Repositório de modelos PaddleOCR (fonte original)
MODEL_BASE_URL_2 = "https://paddleocr.bj.bcebos.com/PP-OCRv3/chinese"

MODELS = {
    "ch_PP-OCRv3_det_infer.onnx": [
        f"{MODEL_BASE_URL_1}/ch_PP-OCRv3_det_infer.onnx",
    ],
    "ch_PP-OCRv3_rec_infer.onnx": [
        f"{MODEL_BASE_URL_1}/ch_PP-OCRv3_rec_infer.onnx",
    ],
    "ch_ppocr_mobile_v2.0_cls_infer.onnx": [
        f"{MODEL_BASE_URL_1}/ch_ppocr_mobile_v2.0_cls_infer.onnx",
    ],
}


def download_file(url: str, dest_path: Path) -> bool:
    """
    Baixa um arquivo de uma URL.
    
    Args:
        url: URL do arquivo
        dest_path: Caminho de destino
        
    Returns:
        True se sucesso, False caso contrário
    """
    try:
        import requests
        from tqdm import tqdm
        
        print(f"  Tentando: {url}")
        response = requests.get(url, stream=True, timeout=30)
        response.raise_for_status()
        
        total_size = int(response.headers.get('content-length', 0))
        
        with open(dest_path, 'wb') as f:
            if total_size == 0:
                f.write(response.content)
            else:
                with tqdm(total=total_size, unit='B', unit_scale=True, desc=f"    {dest_path.name}") as pbar:
                    for chunk in response.iter_content(chunk_size=8192):
                        if chunk:
                            f.write(chunk)
                            pbar.update(len(chunk))
        
        print(f"  ✓ {dest_path.name} baixado com sucesso")
        return True
    except ImportError:
        print("ERRO: Biblioteca 'requests' não encontrada. Instale com: pip install requests tqdm")
        return False
    except Exception as e:
        print(f"  ✗ Falhou: {e}")
        return False


def try_copy_from_rapidocr_cache(dest_path: Path, model_name: str) -> bool:
    """
    Tenta copiar modelo do cache do RapidOCR se já foi baixado.
    
    Args:
        dest_path: Caminho de destino
        model_name: Nome do modelo
        
    Returns:
        True se copiou com sucesso, False caso contrário
    """
    try:
        from rapidocr_onnxruntime import RapidOCR
        import tempfile
        
        # Tenta inicializar RapidOCR para forçar download
        print(f"  Tentando obter modelo do cache do RapidOCR...")
        ocr = RapidOCR()
        
        # O RapidOCR armazena modelos em cache, geralmente em:
        # Windows: %USERPROFILE%\.rapidocr ou %LOCALAPPDATA%\rapidocr
        # Vamos procurar em locais comuns
        possible_locations = [
            os.path.join(os.getenv('USERPROFILE', ''), '.rapidocr'),
            os.path.join(os.getenv('LOCALAPPDATA', ''), 'rapidocr'),
            os.path.join(tempfile.gettempdir(), 'rapidocr'),
        ]
        
        for cache_dir in possible_locations:
            if os.path.exists(cache_dir):
                # Procura pelo arquivo do modelo
                for root, dirs, files in os.walk(cache_dir):
                    if model_name in files:
                        src_path = os.path.join(root, model_name)
                        shutil.copy2(src_path, dest_path)
                        print(f"  ✓ {model_name} copiado do cache")
                        return True
        
        return False
    except Exception as e:
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
            print(f"✓ {model_name} já existe (pulando download)")
        else:
            missing_models.append((model_name, model_url, model_path))
    
    if not missing_models:
        print("\n✓ Todos os modelos já estão baixados!")
        return
    
    print(f"\nBaixando {len(missing_models)} modelo(s)...\n")
    
    # Baixa modelos faltantes
    success_count = 0
    for model_name, model_urls, model_path in missing_models:
        downloaded = False
        
        # Primeiro tenta copiar do cache do RapidOCR (se já foi usado antes)
        if try_copy_from_rapidocr_cache(model_path, model_name):
            success_count += 1
            downloaded = True
        else:
            # Se não encontrou no cache, tenta baixar das URLs
            print(f"Baixando {model_name}...")
            for url in model_urls:
                if download_file(url, model_path):
                    success_count += 1
                    downloaded = True
                    break
        
        if not downloaded:
            print(f"✗ Falha ao obter {model_name}")
            print(f"  Dica: Execute 'python -c \"from rapidocr_onnxruntime import RapidOCR; RapidOCR()\"'")
            print(f"  para forçar o download automático dos modelos, depois execute este script novamente.")
        print()
    
    # Resumo
    print("=" * 60)
    if success_count == len(missing_models):
        print(f"✓ Todos os {success_count} modelo(s) foram baixados com sucesso!")
        print(f"\nModelos salvos em: {models_dir}")
        print("\nAgora você pode gerar o executável com PyInstaller.")
    else:
        print(f"⚠ Aviso: {success_count} de {len(missing_models)} modelo(s) foram baixados.")
        print("Alguns downloads falharam. Verifique sua conexão e tente novamente.")
    print("=" * 60)


if __name__ == "__main__":
    main()


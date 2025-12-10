"""
Script alternativo para obter modelos OCR do cache do RapidOCR.

Este script força o RapidOCR a baixar os modelos (se necessário) e depois
copia-os para a pasta ocr_models/.
"""

import os
import sys
import shutil
from pathlib import Path

def find_rapidocr_cache():
    """Procura o cache do RapidOCR em locais comuns."""
    possible_locations = [
        os.path.join(os.getenv('USERPROFILE', ''), '.rapidocr'),
        os.path.join(os.getenv('LOCALAPPDATA', ''), 'rapidocr'),
        os.path.join(os.getenv('APPDATA', ''), 'rapidocr'),
    ]
    
    import tempfile
    possible_locations.append(os.path.join(tempfile.gettempdir(), 'rapidocr'))
    
    for cache_dir in possible_locations:
        if os.path.exists(cache_dir):
            print(f"Cache encontrado em: {cache_dir}")
            return cache_dir
    
    return None

def copy_models_from_cache(cache_dir, dest_dir):
    """Copia modelos do cache para o diretório de destino."""
    models_needed = [
        "ch_PP-OCRv3_det_infer.onnx",
        "ch_PP-OCRv3_rec_infer.onnx",
        "ch_ppocr_mobile_v2.0_cls_infer.onnx",
    ]
    
    copied = []
    for root, dirs, files in os.walk(cache_dir):
        for model_name in models_needed:
            if model_name in files:
                src_path = os.path.join(root, model_name)
                dest_path = os.path.join(dest_dir, model_name)
                
                if not os.path.exists(dest_path):
                    try:
                        shutil.copy2(src_path, dest_path)
                        print(f"✓ Copiado: {model_name}")
                        copied.append(model_name)
                    except Exception as e:
                        print(f"✗ Erro ao copiar {model_name}: {e}")
    
    return copied

def main():
    """Função principal."""
    print("=" * 60)
    print("Obtendo Modelos OCR do Cache do RapidOCR")
    print("=" * 60)
    print()
    
    # Cria diretório de destino
    base_dir = Path(__file__).parent
    models_dir = base_dir / "ocr_models"
    models_dir.mkdir(exist_ok=True)
    print(f"Diretório de destino: {models_dir}")
    print()
    
    # Tenta forçar download via RapidOCR primeiro
    print("Tentando forçar download via RapidOCR...")
    try:
        from rapidocr_onnxruntime import RapidOCR
        print("Inicializando RapidOCR (isso pode baixar modelos automaticamente)...")
        ocr = RapidOCR()
        print("✓ RapidOCR inicializado")
    except ImportError:
        print("✗ rapidocr-onnxruntime não está instalado")
        print("  Instale com: pip install rapidocr-onnxruntime")
        return
    except Exception as e:
        print(f"✗ Erro ao inicializar RapidOCR: {e}")
        print("  Continuando para tentar copiar do cache...")
    
    print()
    
    # Procura cache
    print("Procurando cache do RapidOCR...")
    cache_dir = find_rapidocr_cache()
    
    if not cache_dir:
        print("✗ Cache não encontrado")
        print()
        print("Tentando localizar cache em outros locais...")
        # Procura em todo o diretório do usuário
        user_profile = os.getenv('USERPROFILE', '')
        if user_profile:
            for root, dirs, files in os.walk(user_profile):
                if 'rapidocr' in root.lower() or any('ch_PP-OCR' in f for f in files):
                    cache_dir = root
                    print(f"  Encontrado possível cache em: {root}")
                    break
    
    if cache_dir:
        print(f"✓ Cache encontrado: {cache_dir}")
        print()
        print("Copiando modelos...")
        copied = copy_models_from_cache(cache_dir, models_dir)
        
        if copied:
            print()
            print("=" * 60)
            print(f"✓ {len(copied)} modelo(s) copiado(s) com sucesso!")
            print("=" * 60)
        else:
            print()
            print("=" * 60)
            print("⚠ Nenhum modelo foi copiado")
            print("=" * 60)
            print()
            print("Os modelos podem estar em um formato diferente ou local diferente.")
            print("Tente executar a aplicação uma vez para forçar o download,")
            print("depois execute este script novamente.")
    else:
        print("✗ Cache não encontrado")
        print()
        print("=" * 60)
        print("SOLUÇÃO:")
        print("=" * 60)
        print("1. Execute a aplicação Flask uma vez:")
        print("   python -m flask run")
        print()
        print("2. Faça upload de um PDF para forçar o download dos modelos")
        print()
        print("3. Execute este script novamente")
        print("=" * 60)
    
    # Verifica quais modelos estão presentes
    print()
    print("Verificando modelos baixados...")
    models_needed = [
        "ch_PP-OCRv3_det_infer.onnx",
        "ch_PP-OCRv3_rec_infer.onnx",
        "ch_ppocr_mobile_v2.0_cls_infer.onnx",
    ]
    
    for model_name in models_needed:
        model_path = models_dir / model_name
        if model_path.exists():
            size_mb = model_path.stat().st_size / (1024 * 1024)
            print(f"  ✓ {model_name} ({size_mb:.1f} MB)")
        else:
            print(f"  ✗ {model_name} (não encontrado)")

if __name__ == "__main__":
    main()


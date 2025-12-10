# Solução para Python 3.14 e RapidOCR

## Problema

Python 3.14 é muito recente e `onnxruntime` (dependência do `rapidocr-onnxruntime`) pode não ter binários pré-compilados disponíveis ainda.

## Soluções

### Opção 1: Usar Python 3.11 ou 3.12 (RECOMENDADO)

1. Instale Python 3.11 ou 3.12
2. Crie um ambiente virtual:
   ```cmd
   py -3.11 -m venv venv
   venv\Scripts\activate
   ```
3. Execute `setup_exe.bat` novamente

### Opção 2: Instalar RapidOCR Manualmente

Execute o script de instalação manual:
```cmd
instalar_rapidocr_manual.bat
```

### Opção 3: Continuar sem OCR Completo

O executável **funcionará** mesmo sem `rapidocr-onnxruntime` instalado se:
- Os modelos OCR já estão em `ocr_models/`
- Você só processa PDFs com texto nativo (não escaneados)

O executável será gerado normalmente, mas PDFs escaneados podem não funcionar completamente.

### Opção 4: Instalar Apenas o Necessário

Se você só precisa gerar o executável e os modelos já estão em `ocr_models/`:

1. Pule a instalação do rapidocr
2. Continue com o build:
   ```cmd
   build_exe.bat
   ```

O PyInstaller incluirá os modelos que estão em `ocr_models/` no executável.

## Verificar Modelos

Os modelos essenciais estão em:
- `ocr_models/ch_PP-OCRv3_det_infer.onnx` (deteção)
- `ocr_models/ch_PP-OCRv3_rec_infer.onnx` (reconhecimento)

Se estes arquivos existem, o executável terá suporte a OCR mesmo sem `rapidocr-onnxruntime` instalado no ambiente de build (o código tentará carregar os modelos diretamente).

## Continuar com o Build

Mesmo com o aviso sobre modelos faltando, você pode continuar:

```cmd
build_exe.bat
```

O build continuará e o executável será gerado. Os modelos que estiverem em `ocr_models/` serão incluídos no executável.


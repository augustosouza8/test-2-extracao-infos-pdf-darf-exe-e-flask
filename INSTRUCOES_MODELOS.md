# Instruções para Obter Modelos OCR

## Situação Atual

Você está usando Python 3.14, mas `rapidocr-onnxruntime==1.4.4` requer Python <3.13.

## Solução: Download Manual dos Modelos

Como não podemos usar o RapidOCR para baixar automaticamente, você precisa baixar os modelos manualmente.

### Passo 1: Baixar os Modelos

Baixe os 3 arquivos `.onnx` de uma das fontes abaixo:

#### Opção A: GitHub Releases (Recomendado)
1. Acesse: https://github.com/RapidAI/RapidOCR/releases
2. Procure pela versão mais recente (v1.4.0 ou superior)
3. Baixe os arquivos:
   - `ch_PP-OCRv3_det_infer.onnx` (~2-3 MB)
   - `ch_PP-OCRv3_rec_infer.onnx` (~10-12 MB)
   - `ch_ppocr_mobile_v2.0_cls_infer.onnx` (~1-2 MB) - opcional

#### Opção B: Links Diretos (se funcionarem)
- https://github.com/RapidAI/RapidOCR/releases/download/v1.4.0/ch_PP-OCRv3_det_infer.onnx
- https://github.com/RapidAI/RapidOCR/releases/download/v1.4.0/ch_PP-OCRv3_rec_infer.onnx
- https://github.com/RapidAI/RapidOCR/releases/download/v1.4.0/ch_ppocr_mobile_v2.0_cls_infer.onnx

#### Opção C: Repositório PaddleOCR
- https://paddleocr.bj.bcebos.com/PP-OCRv3/chinese/

### Passo 2: Colocar os Arquivos

1. Certifique-se de que a pasta `ocr_models/` existe na raiz do projeto
2. Coloque os 3 arquivos `.onnx` dentro de `ocr_models/`

Estrutura final:
```
projeto/
├── ocr_models/
│   ├── ch_PP-OCRv3_det_infer.onnx
│   ├── ch_PP-OCRv3_rec_infer.onnx
│   └── ch_ppocr_mobile_v2.0_cls_infer.onnx
├── app/
├── build_exe_fallback.bat
└── ...
```

### Passo 3: Verificar

Execute para verificar se os arquivos estão corretos:

```cmd
py download_models_simples.py
```

Ou verifique manualmente se os arquivos existem em `ocr_models/`.

### Passo 4: Gerar Executável

Após colocar os modelos, execute:

```cmd
build_exe_fallback.bat
```

## Nota sobre Python 3.14

Se você quiser usar o RapidOCR para baixar automaticamente no futuro, considere usar Python 3.12 ou 3.11, que são compatíveis com `rapidocr-onnxruntime==1.4.4`.

Para verificar sua versão do Python:
```cmd
py --version
```

Para este projeto, Python 3.12 seria ideal.


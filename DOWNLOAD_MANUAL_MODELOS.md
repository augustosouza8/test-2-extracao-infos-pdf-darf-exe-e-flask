# Download Manual dos Modelos OCR

Se você está tendo problemas de conexão para baixar os modelos automaticamente, siga estas instruções para baixar manualmente.

## Modelos Necessários

Você precisa baixar 3 arquivos `.onnx`:

1. **ch_PP-OCRv3_det_infer.onnx** (Modelo de Detecção)
2. **ch_PP-OCRv3_rec_infer.onnx** (Modelo de Reconhecimento)  
3. **ch_ppocr_mobile_v2.0_cls_infer.onnx** (Modelo de Classificação - opcional)

## Onde Baixar

### Opção 1: GitHub Releases (Recomendado)
Acesse: https://github.com/RapidAI/RapidOCR/releases

Procure pela versão **v1.4.0** ou mais recente e baixe os arquivos `.onnx`.

### Opção 2: Links Diretos
Se os links diretos funcionarem, você pode tentar:

- https://github.com/RapidAI/RapidOCR/releases/download/v1.4.0/ch_PP-OCRv3_det_infer.onnx
- https://github.com/RapidAI/RapidOCR/releases/download/v1.4.0/ch_PP-OCRv3_rec_infer.onnx
- https://github.com/RapidAI/RapidOCR/releases/download/v1.4.0/ch_ppocr_mobile_v2.0_cls_infer.onnx

### Opção 3: Repositório PaddleOCR
Os modelos também estão disponíveis em:
- https://paddleocr.bj.bcebos.com/PP-OCRv3/chinese/

## Onde Colocar os Arquivos

1. Crie a pasta `ocr_models` na raiz do projeto (se não existir)
2. Coloque os 3 arquivos `.onnx` dentro da pasta `ocr_models/`

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

## Verificação

Após baixar e colocar os arquivos, execute:

```cmd
py download_models_simples.py
```

O script verificará se os arquivos existem e mostrará o status.

Ou verifique manualmente se os arquivos existem em `ocr_models/`:
- ch_PP-OCRv3_det_infer.onnx (deve ter ~2-3 MB)
- ch_PP-OCRv3_rec_infer.onnx (deve ter ~10-12 MB)
- ch_ppocr_mobile_v2.0_cls_infer.onnx (deve ter ~1-2 MB)

## Após o Download

Depois de colocar os modelos na pasta `ocr_models/`, você pode prosseguir com:

```cmd
build_exe_fallback.bat
```

## Nota sobre Firewall/Proxy

Se você está em uma rede corporativa com firewall ou proxy:

1. Configure o proxy do Python:
   ```cmd
   set HTTP_PROXY=http://proxy:porta
   set HTTPS_PROXY=http://proxy:porta
   ```

2. Ou use um navegador para baixar os arquivos manualmente

3. Ou peça para o administrador da rede liberar o acesso ao GitHub


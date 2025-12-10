# Instruções para Gerar o Executável Windows

## Método Rápido (Recomendado)

Execute os scripts em ordem:

1. **Setup inicial (instala dependências e baixa modelos):**
   ```cmd
   setup_exe.bat
   ```

2. **Gerar o executável:**
   ```cmd
   build_exe.bat
   ```

O executável estará em `dist\ExtratorDARF.exe`

## Método Manual

### Pré-requisitos

1. **Instalar dependências de build:**
   ```bash
   pip install pywebview waitress pyinstaller
   ```

2. **Baixar modelos OCR:**
   ```bash
   python download_models.py
   ```
   
   Certifique-se de que a pasta `ocr_models/` foi criada e contém os arquivos `.onnx`.

## Comando PyInstaller

Após confirmar que os modelos foram baixados, execute o seguinte comando:

```bash
pyinstaller --onefile --windowed --name "ExtratorDARF" --icon=NONE --add-data "app/templates;app/templates" --add-data "app/static;app/static" --add-data "ocr_models;ocr_models" --hidden-import rapidocr_onnxruntime --hidden-import pandas --hidden-import sqlalchemy --hidden-import openpyxl --hidden-import waitress --hidden-import webview --hidden-import flask --hidden-import flask_sqlalchemy --hidden-import flask_migrate --hidden-import pdfplumber --hidden-import pdfminer --hidden-import onnxruntime --hidden-import opencv-python --hidden-import pillow --hidden-import numpy --hidden-import shapely --hidden-import pyclipper --hidden-import yaml --collect-all rapidocr_onnxruntime --collect-all waitress --collect-all webview run_exe.py
```

### Explicação dos Parâmetros

- `--onefile`: Gera um único arquivo executável
- `--windowed`: Não mostra janela de console (modo GUI)
- `--name "ExtratorDARF"`: Nome do executável gerado
- `--add-data`: Inclui pastas necessárias no executável
  - `app/templates;app/templates`: Templates HTML
  - `app/static;app/static`: Arquivos estáticos (CSS, JS)
  - `ocr_models;ocr_models`: Modelos OCR offline
- `--hidden-import`: Garante que módulos importados dinamicamente sejam incluídos
- `--collect-all`: Coleta todos os sub-módulos e dados de um pacote

### Formato do --add-data no Windows

No Windows, use ponto-e-vírgula (`;`) como separador:
```
--add-data "origem;destino"
```

No Linux/Mac, use dois-pontos (`:`):
```
--add-data "origem:destino"
```

## Localização do Executável

Após a compilação, o executável estará em:
```
dist/ExtratorDARF.exe
```

## Testando o Executável

1. Execute `dist/ExtratorDARF.exe`
2. Uma janela nativa deve abrir com a aplicação
3. Teste o upload de PDFs e verifique se o OCR funciona
4. Verifique se o banco de dados é criado em `%APPDATA%\ExtratorDARF\config.db`

## Troubleshooting

### Erro: "Modelos OCR não encontrados"
- Certifique-se de que executou `download_models.py` antes do build
- Verifique se a pasta `ocr_models/` existe e contém os arquivos `.onnx`

### Erro: "Módulo não encontrado"
- Adicione o módulo faltante com `--hidden-import nome_do_modulo`

### Executável muito grande
- Isso é normal devido aos modelos OCR e dependências
- O tamanho pode ser de 200-500 MB

### Janela não abre
- Verifique se a porta está livre
- Tente executar com `--console` para ver mensagens de erro:
  ```bash
  pyinstaller --onefile --console ... (resto do comando)
  ```

## Notas Importantes

- O primeiro uso pode ser mais lento devido à extração dos arquivos temporários
- O banco de dados será criado automaticamente em `%APPDATA%\ExtratorDARF\`
- Os logs podem ser visualizados se executar com `--console` ou verificar a pasta temporária do PyInstaller


# Como Executar o Build Corretamente

## Problema: Script Fecha Rapidamente

Se o `build_exe_fallback.bat` está fechando rapidamente ao clicar duas vezes, use uma das soluções abaixo.

## Solução 1: Executar pelo CMD/PowerShell (Recomendado)

1. **Abra o CMD ou PowerShell**
2. **Navegue até a pasta do projeto:**
   ```cmd
   cd C:\Users\X07300016600\cursor-projects\test-2-extracao-infos-pdf-darf-exe-e-flask
   ```
3. **Execute o script:**
   ```cmd
   build_exe_fallback.bat
   ```

Isso permite ver todas as mensagens e erros.

## Solução 2: Usar o Wrapper

Execute o arquivo `executar_build.bat` que abre uma nova janela que permanece aberta.

## Solução 3: Executar PyInstaller Diretamente

Se os scripts não funcionarem, execute o PyInstaller manualmente:

```cmd
py -m PyInstaller --onefile --console --name "ExtratorDARF_Fallback" --add-data "app/templates;app/templates" --add-data "app/static;app/static" --add-data "ocr_models;ocr_models" --hidden-import rapidocr_onnxruntime --hidden-import pandas --hidden-import sqlalchemy --hidden-import openpyxl --hidden-import waitress --hidden-import flask --hidden-import flask_sqlalchemy --hidden-import flask_migrate --hidden-import pdfplumber --hidden-import pdfminer --hidden-import onnxruntime --hidden-import cv2 --hidden-import pillow --hidden-import numpy --hidden-import shapely --hidden-import pyclipper --hidden-import yaml --collect-all rapidocr_onnxruntime --collect-all waitress run_exe_fallback.py
```

## Verificar se Funcionou

Após executar, verifique se a pasta `dist` foi criada:

```cmd
dir dist
```

Se o executável foi gerado, você verá:
```
ExtratorDARF_Fallback.exe
```

## Próximos Passos

1. Execute o executável: `dist\ExtratorDARF_Fallback.exe`
2. Uma janela de console abrirá
3. O navegador abrirá automaticamente com a aplicação
4. Teste fazendo upload de um PDF


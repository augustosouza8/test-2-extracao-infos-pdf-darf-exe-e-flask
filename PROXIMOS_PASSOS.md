# Próximos Passos Após Baixar os Modelos

## ✅ Status Atual

- ✅ Modelos OCR baixados e colocados em `ocr_models/`
- ⏳ Executável ainda não gerado

## Próximo Passo: Gerar o Executável

### Opção 1: Executar o Script de Build (Recomendado)

Execute o script que gera o executável:

```cmd
build_exe_fallback.bat
```

**O que esperar:**
- O script verificará se os modelos existem (já estão OK)
- Limpará builds anteriores
- Executará PyInstaller (pode levar 5-15 minutos)
- Gerará o executável em `dist\ExtratorDARF_Fallback.exe`

### Opção 2: Executar PyInstaller Manualmente

Se o script não funcionar, execute o PyInstaller diretamente:

```cmd
py -m PyInstaller --onefile --console --name "ExtratorDARF_Fallback" --add-data "app/templates;app/templates" --add-data "app/static;app/static" --add-data "ocr_models;ocr_models" --hidden-import rapidocr_onnxruntime --hidden-import pandas --hidden-import sqlalchemy --hidden-import openpyxl --hidden-import waitress --hidden-import flask --hidden-import flask_sqlalchemy --hidden-import flask_migrate --hidden-import pdfplumber --hidden-import pdfminer --hidden-import onnxruntime --hidden-import cv2 --hidden-import pillow --hidden-import numpy --hidden-import shapely --hidden-import pyclipper --hidden-import yaml --collect-all rapidocr_onnxruntime --collect-all waitress run_exe_fallback.py
```

## Após Gerar o Executável

### 1. Localização
O executável estará em:
```
dist\ExtratorDARF_Fallback.exe
```

### 2. Testar o Executável

1. **Execute o arquivo:**
   ```cmd
   dist\ExtratorDARF_Fallback.exe
   ```

2. **O que deve acontecer:**
   - Uma janela de console abrirá
   - O servidor Flask iniciará em uma porta local (ex: http://127.0.0.1:8000)
   - Seu navegador padrão abrirá automaticamente com a aplicação
   - Você verá a interface web da aplicação

3. **Teste a funcionalidade:**
   - Faça upload de um PDF DARF
   - Verifique se a extração funciona
   - Teste o OCR (se o PDF for escaneado)

### 3. Verificar Persistência de Dados

O banco de dados será criado automaticamente em:
```
%APPDATA%\ExtratorDARF\config.db
```

Para verificar:
- Pressione `Win + R`
- Digite: `%APPDATA%\ExtratorDARF`
- Pressione Enter
- Você deve ver o arquivo `config.db`

## Troubleshooting

### Executável não abre
- Verifique se há mensagens de erro no console
- Certifique-se de que a porta não está em uso
- Tente executar novamente

### Erro ao processar PDFs
- Verifique se os modelos OCR estão corretos
- Tente com um PDF diferente
- Verifique os logs no console

### Navegador não abre automaticamente
- Abra manualmente: http://127.0.0.1:8000 (ou a porta mostrada no console)
- Verifique se o servidor iniciou (mensagem no console)

## Distribuição

Após testar e confirmar que funciona:

1. **Copie apenas o executável:**
   - `dist\ExtratorDARF_Fallback.exe` é standalone
   - Não precisa de Python instalado
   - Não precisa de outras dependências

2. **Tamanho esperado:**
   - Pode ser 200-500 MB (devido aos modelos OCR e dependências)
   - Isso é normal para executáveis com OCR

3. **Distribua:**
   - Envie apenas o arquivo `.exe`
   - O usuário pode executar diretamente
   - Dados serão salvos em `%APPDATA%\ExtratorDARF\`

## Notas Importantes

- **Primeira execução:** Pode ser mais lenta (extração de arquivos temporários)
- **Antivírus:** Pode alertar sobre o executável (falso positivo comum com PyInstaller)
- **Porta:** O aplicativo usa porta dinâmica para evitar conflitos
- **Console:** Esta versão mostra console (pode ocultar com `--windowed` se preferir)


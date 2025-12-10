# Guia Rápido: Gerar Executável Windows

## Passos Simplificados

### Opção 1: Scripts Automatizados (Mais Fácil)

1. Execute `setup_exe.bat` - Instala dependências e baixa modelos OCR
2. Execute `build_exe.bat` - Gera o executável
3. O executável estará em `dist\ExtratorDARF.exe`

### Opção 2: Manual

1. Instale as dependências:
   ```cmd
   pip install pywebview waitress pyinstaller
   ```

2. Baixe os modelos OCR:
   ```cmd
   python download_models.py
   ```

3. Gere o executável (veja comando completo em `BUILD_EXE.md`):
   ```cmd
   pyinstaller --onefile --windowed ... (veja BUILD_EXE.md)
   ```

## O que foi modificado?

### Arquivos Modificados:
- `app/__init__.py` - Detecta executável e usa `%APPDATA%\ExtratorDARF` para banco de dados
- `app/services/pdf_parser.py` - Usa modelos OCR locais quando executável
- `pyproject.toml` - Adicionadas dependências `pywebview` e `waitress`
- `requirements.txt` - Adicionadas dependências `pywebview` e `waitress`

### Arquivos Criados:
- `download_models.py` - Script para baixar modelos OCR
- `run_exe.py` - Ponto de entrada do executável (porta dinâmica + webview)
- `setup_exe.bat` - Script de setup automatizado
- `build_exe.bat` - Script para gerar executável
- `BUILD_EXE.md` - Documentação completa

## Estrutura do Executável

Quando executado, o aplicativo:
- Cria banco de dados em `%APPDATA%\ExtratorDARF\config.db`
- Usa modelos OCR incorporados (não precisa de internet)
- Abre janela nativa usando PyWebView
- Usa porta dinâmica para evitar conflitos

## Testando

1. Execute `dist\ExtratorDARF.exe`
2. Uma janela deve abrir automaticamente
3. Teste upload de PDFs
4. Verifique se o banco está em `%APPDATA%\ExtratorDARF\`

## Problemas Comuns

**Python não encontrado:**
- Use `py` ao invés de `python`
- Ou adicione Python ao PATH do Windows

**Modelos não baixam:**
- Execute: `python -c "from rapidocr_onnxruntime import RapidOCR; RapidOCR()"`
- Isso força o download automático
- Depois execute `download_models.py` novamente

**Executável não abre:**
- Tente gerar com `--console` para ver erros
- Verifique se todas as dependências foram instaladas


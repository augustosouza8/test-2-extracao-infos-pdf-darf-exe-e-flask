# Correção do Build - Erro "No module named 'flask'"

## Problema
O executável gerado não encontra o módulo Flask ao ser executado.

## Solução
O script `build_exe_fallback.bat` foi atualizado para incluir:
- `--collect-all flask` - Coleta todos os submódulos do Flask
- `--collect-all werkzeug` - Coleta o Werkzeug (dependência do Flask)
- `--collect-all flask_sqlalchemy` - Coleta Flask-SQLAlchemy
- `--collect-all flask_migrate` - Coleta Flask-Migrate
- Imports ocultos adicionais para submódulos do Flask

## Como Reconstruir

1. **Limpe os builds anteriores:**
   ```cmd
   rmdir /s /q build
   rmdir /s /q dist
   del /q ExtratorDARF_Fallback.spec
   ```

2. **Execute o build novamente:**
   ```cmd
   build_exe_fallback.bat
   ```

3. **Teste o executável:**
   ```cmd
   dist\ExtratorDARF_Fallback.exe
   ```

## Se o erro persistir

Execute o PyInstaller manualmente com mais verbosidade:

```cmd
py -m PyInstaller --onefile --console --name "ExtratorDARF_Fallback" --add-data "app/templates;app/templates" --add-data "app/static;app/static" --add-data "ocr_models;ocr_models" --collect-all flask --collect-all werkzeug --collect-all flask_sqlalchemy --collect-all flask_migrate --collect-all rapidocr_onnxruntime --collect-all waitress --log-level=DEBUG run_exe_fallback.py
```

Isso mostrará mais detalhes sobre o que está sendo incluído.


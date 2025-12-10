# Solução: Flask não encontrado no executável

## Problema
O PyInstaller não está incluindo o Flask corretamente no executável, resultando em erro "No module named 'flask'".

## Causa
O PyInstaller pode não detectar automaticamente todas as dependências do Flask, especialmente:
- Jinja2 (templates)
- Markupsafe (dependência do Jinja2)
- Submódulos do Flask e Werkzeug

## Solução Aplicada
O script `build_exe_fallback.bat` foi atualizado para:

1. **Adicionar imports ocultos específicos:**
   - `jinja2` e `jinja2.ext` (templates)
   - `markupsafe` (dependência do Jinja2)
   - Submódulos do Flask (`flask.app`, `flask.blueprints`, etc.)
   - Submódulos do Werkzeug

2. **Usar `--collect-submodules` em vez de `--collect-all`:**
   - `--collect-submodules flask` - coleta todos os submódulos do Flask
   - `--collect-submodules jinja2` - coleta todos os submódulos do Jinja2
   - `--collect-submodules werkzeug` - coleta todos os submódulos do Werkzeug

## Como Reconstruir

1. **Limpe os builds anteriores:**
   ```cmd
   limpar_build.bat
   ```

2. **Execute o build novamente:**
   ```cmd
   build_exe_fallback.bat
   ```

3. **Teste o executável:**
   ```cmd
   dist\ExtratorDARF_Fallback.exe
   ```

## Se o problema persistir

Verifique se o Flask está instalado no ambiente Python correto:

```cmd
python -m pip list | findstr flask
```

Se não aparecer, instale:
```cmd
python -m pip install flask flask-sqlalchemy flask-migrate jinja2 markupsafe werkzeug
```

Depois, reconstrua o executável.


# Guia: Usar UV para Python 3.12 e Gerar Executável

## Passo a Passo

### 1. Instalar Python 3.12 com UV

Execute:
```cmd
setup_python312_uv.bat
```

Este script:
- Verifica se `uv` está instalado
- Instala Python 3.12 usando `uv python install 3.12`
- Cria um ambiente virtual `venv_py312` com Python 3.12
- Instala todas as dependências do `requirements.txt`

### 2. Gerar o Executável

Execute:
```cmd
build_exe_com_venv.bat
```

Este script:
- Ativa automaticamente o ambiente virtual `venv_py312`
- Verifica se tudo está instalado corretamente
- Executa o PyInstaller com todas as configurações necessárias
- Gera o executável em `dist\ExtratorDARF_Fallback.exe`

## Comandos Manuais (Alternativa)

Se preferir fazer manualmente:

```cmd
REM 1. Instalar Python 3.12
uv python install 3.12

REM 2. Criar ambiente virtual
uv venv venv_py312 --python 3.12

REM 3. Ativar ambiente virtual
venv_py312\Scripts\activate

REM 4. Instalar dependências
uv pip install -r requirements.txt
REM ou
python -m pip install -r requirements.txt

REM 5. Gerar executável
python -m PyInstaller --onefile --console --name "ExtratorDARF_Fallback" ...
```

## Verificação

Para verificar se está tudo certo:

```cmd
venv_py312\Scripts\activate
python --version
python -c "import flask; import onnxruntime; print('OK')"
```

## Vantagens do UV

- **Rápido**: UV é muito mais rápido que pip
- **Gerenciamento de Python**: Pode instalar versões específicas do Python
- **Ambientes isolados**: Cria ambientes virtuais automaticamente
- **Compatível**: Funciona com requirements.txt padrão

## Solução de Problemas

### UV não encontrado
```cmd
powershell -ExecutionPolicy ByPass -c "irm https://astral.sh/uv/install.ps1 | iex"
```

### Ambiente virtual não ativa
Certifique-se de executar `venv_py312\Scripts\activate.bat` (não `.activate`)

### Dependências não instalam
Tente:
```cmd
uv pip install -r requirements.txt --no-cache
```


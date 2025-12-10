@echo off
REM Script para instalar Python 3.12 usando UV e configurar ambiente para build

echo ========================================
echo Configurando Python 3.12 com UV
echo ========================================
echo.

REM Verifica se uv está instalado
where uv >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo.
    echo ========================================
    echo ERRO: UV nao encontrado!
    echo ========================================
    echo.
    echo Instale o UV primeiro:
    echo   powershell -ExecutionPolicy ByPass -c "irm https://astral.sh/uv/install.ps1 | iex"
    echo.
    echo Ou baixe de: https://github.com/astral-sh/uv
    echo.
    pause
    exit /b 1
)

echo [OK] UV encontrado
echo.

REM Instala Python 3.12 usando UV
echo [1/4] Instalando Python 3.12 com UV...
uv python install 3.12
if %ERRORLEVEL% NEQ 0 (
    echo.
    echo ERRO: Falha ao instalar Python 3.12 com UV.
    echo.
    pause
    exit /b 1
)
echo [OK] Python 3.12 instalado
echo.

REM Cria um ambiente virtual com Python 3.12
echo [2/4] Criando ambiente virtual com Python 3.12...
if exist "venv_py312" (
    echo Ambiente virtual ja existe, removendo...
    rmdir /s /q venv_py312
)
uv venv venv_py312 --python 3.12
if %ERRORLEVEL% NEQ 0 (
    echo.
    echo ERRO: Falha ao criar ambiente virtual.
    echo.
    pause
    exit /b 1
)
echo [OK] Ambiente virtual criado
echo.

REM Ativa o ambiente virtual e instala dependências
echo [3/4] Instalando dependencias no ambiente virtual...
call venv_py312\Scripts\activate.bat
if %ERRORLEVEL% NEQ 0 (
    echo.
    echo ERRO: Falha ao ativar ambiente virtual.
    echo.
    pause
    exit /b 1
)

REM Usa uv para instalar dependências
uv pip install -r requirements.txt
if %ERRORLEVEL% NEQ 0 (
    echo.
    echo AVISO: Falha ao instalar com uv pip. Tentando com pip normal...
    python -m pip install -r requirements.txt
    if %ERRORLEVEL% NEQ 0 (
        echo.
        echo ERRO: Falha ao instalar dependencias.
        echo.
        pause
        exit /b 1
    )
)
echo [OK] Dependencias instaladas
echo.

REM Instala PyInstaller e PyWebView
echo Instalando PyInstaller e PyWebView...
uv pip install pyinstaller pywebview
if %ERRORLEVEL% NEQ 0 (
    echo.
    echo AVISO: Falha ao instalar com uv pip. Tentando com pip normal...
    python -m pip install pyinstaller pywebview
    if %ERRORLEVEL% NEQ 0 (
        echo.
        echo AVISO: Falha ao instalar PyWebView (pode precisar de compilacao).
        echo PyInstaller sera instalado separadamente...
        python -m pip install pyinstaller
        if %ERRORLEVEL% NEQ 0 (
            echo.
            echo ERRO: Falha ao instalar PyInstaller.
            echo.
            pause
            exit /b 1
        )
        echo.
        echo AVISO: PyWebView nao foi instalado automaticamente.
        echo Tente instalar manualmente ou use build_exe_com_venv.bat (versao navegador).
        echo.
    )
)
echo [OK] PyInstaller e PyWebView instalados
echo.

REM Verifica se Flask e onnxruntime estão instalados
echo [4/4] Verificando instalacao...
python -c "import flask; print('[OK] Flask instalado')" 2>nul || echo [ERRO] Flask nao encontrado
python -c "import onnxruntime; print('[OK] onnxruntime instalado')" 2>nul || echo [ERRO] onnxruntime nao encontrado
echo.

echo ========================================
echo Configuracao concluida!
echo ========================================
echo.
echo Ambiente virtual criado em: venv_py312
echo.
echo Para usar este ambiente:
echo   1. Ative: venv_py312\Scripts\activate
echo   2. Execute: build_exe_fallback.bat
echo.
echo Ou use o script: build_exe_com_venv.bat
echo.
pause


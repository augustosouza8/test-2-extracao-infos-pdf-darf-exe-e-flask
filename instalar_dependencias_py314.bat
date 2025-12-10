@echo off
REM Script para instalar dependências compatíveis com Python 3.14
REM Instala todas as dependências exceto onnxruntime (que será instalado sem versão fixa)

echo ========================================
echo Instalando Dependencias Python 3.14
echo ========================================
echo.

REM Verifica se Python está disponível
where python >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    where py >nul 2>&1
    if %ERRORLEVEL% NEQ 0 (
        echo ERRO: Python nao encontrado no PATH.
        pause
        exit /b 1
    )
    set PYTHON_CMD=py
) else (
    set PYTHON_CMD=python
)

echo Usando: %PYTHON_CMD%
echo.

REM Instala dependências principais primeiro
echo [1/3] Instalando dependencias principais...
%PYTHON_CMD% -m pip install --upgrade pip
%PYTHON_CMD% -m pip install flask flask-sqlalchemy flask-migrate waitress
%PYTHON_CMD% -m pip install pandas openpyxl pdfplumber pillow
%PYTHON_CMD% -m pip install jinja2 markupsafe werkzeug

if %ERRORLEVEL% NEQ 0 (
    echo ERRO: Falha ao instalar dependencias principais.
    pause
    exit /b 1
)

echo [OK] Dependencias principais instaladas
echo.

REM Instala onnxruntime sem versão fixa (permite pip encontrar versão compatível)
echo [2/3] Instalando onnxruntime (versao compativel com Python 3.14)...
%PYTHON_CMD% -m pip install onnxruntime

if %ERRORLEVEL% NEQ 0 (
    echo AVISO: Falha ao instalar onnxruntime. Tentando versao alternativa...
    %PYTHON_CMD% -m pip install onnxruntime-gpu
    if %ERRORLEVEL% NEQ 0 (
        echo ERRO: Nao foi possivel instalar onnxruntime.
        echo.
        echo Tente instalar manualmente ou use Python 3.11 ou 3.12.
        pause
        exit /b 1
    )
)

echo [OK] onnxruntime instalado
echo.

REM Instala rapidocr-onnxruntime (pode falhar se onnxruntime nao estiver instalado)
echo [3/3] Instalando rapidocr-onnxruntime...
%PYTHON_CMD% -m pip install rapidocr-onnxruntime

if %ERRORLEVEL% NEQ 0 (
    echo AVISO: Falha ao instalar rapidocr-onnxruntime.
    echo Isso pode ser normal se onnxruntime nao foi instalado corretamente.
    echo.
)

REM Instala outras dependências opcionais
echo Instalando outras dependencias...
%PYTHON_CMD% -m pip install opencv-python numpy shapely pyclipper pyyaml

echo.
echo ========================================
echo Instalacao concluida!
echo ========================================
echo.
echo Verificando instalacao...
%PYTHON_CMD% -c "import flask; print('[OK] Flask instalado')"
%PYTHON_CMD% -c "import onnxruntime; print('[OK] onnxruntime instalado')" 2>nul || echo [AVISO] onnxruntime nao encontrado
echo.
pause


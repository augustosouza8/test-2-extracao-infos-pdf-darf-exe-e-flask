@echo off
REM Script para gerar executável usando o ambiente virtual Python 3.12

echo ========================================
echo Gerando Executavel com Ambiente Virtual
echo ========================================
echo.

REM Verifica se o ambiente virtual existe
if not exist "venv_py312\Scripts\activate.bat" (
    echo.
    echo ========================================
    echo ERRO: Ambiente virtual nao encontrado!
    echo ========================================
    echo.
    echo Execute primeiro: setup_python312_uv.bat
    echo.
    pause
    exit /b 1
)

REM Ativa o ambiente virtual
echo Ativando ambiente virtual Python 3.12...
call venv_py312\Scripts\activate.bat

REM Verifica se Python está correto
echo Verificando Python...
python --version
echo.

REM Verifica se Flask está instalado
python -c "import flask" >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo.
    echo ========================================
    echo ERRO: Flask nao encontrado no ambiente virtual!
    echo ========================================
    echo.
    echo Execute: setup_python312_uv.bat
    echo.
    pause
    exit /b 1
)

REM Verifica se PyInstaller está instalado
python -c "import PyInstaller" >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo.
    echo ========================================
    echo AVISO: PyInstaller nao encontrado!
    echo ========================================
    echo.
    echo Instalando PyInstaller...
    python -m pip install pyinstaller
    if %ERRORLEVEL% NEQ 0 (
        echo.
        echo ERRO: Falha ao instalar PyInstaller.
        echo.
        pause
        exit /b 1
    )
    echo [OK] PyInstaller instalado
    echo.
)

REM Verifica modelos OCR
echo Verificando modelos OCR...
if not exist "ocr_models\ch_PP-OCRv3_det_infer.onnx" (
    echo.
    echo ========================================
    echo ERRO: Modelos OCR nao encontrados!
    echo ========================================
    echo.
    echo Baixe os modelos primeiro.
    echo.
    pause
    exit /b 1
)

if not exist "ocr_models\ch_PP-OCRv3_rec_infer.onnx" (
    echo.
    echo ========================================
    echo ERRO: Modelos OCR nao encontrados!
    echo ========================================
    echo.
    pause
    exit /b 1
)

echo [OK] Modelos OCR encontrados
echo.

REM Limpa builds anteriores
echo Limpando builds anteriores...
if exist "build" rmdir /s /q build
if exist "dist" rmdir /s /q dist
if exist "ExtratorDARF_Fallback.spec" del /q ExtratorDARF_Fallback.spec
echo [OK] Limpeza concluida
echo.

REM Executa PyInstaller
echo ========================================
echo Iniciando geracao do executavel...
echo ========================================
echo.
echo ATENCAO: Isso pode levar 5-15 minutos!
echo.
echo Pressione qualquer tecla para COMECAR o build...
pause >nul
echo.

python -m PyInstaller ^
    --onefile ^
    --console ^
    --name "ExtratorDARF_Fallback" ^
    --add-data "app/templates;app/templates" ^
    --add-data "app/static;app/static" ^
    --add-data "ocr_models;ocr_models" ^
    --hidden-import flask ^
    --hidden-import flask.app ^
    --hidden-import flask.blueprints ^
    --hidden-import flask.ctx ^
    --hidden-import flask.json ^
    --hidden-import flask.sessions ^
    --hidden-import flask.helpers ^
    --hidden-import flask.templating ^
    --hidden-import flask.wrappers ^
    --hidden-import jinja2 ^
    --hidden-import jinja2.ext ^
    --hidden-import markupsafe ^
    --hidden-import werkzeug ^
    --hidden-import werkzeug.utils ^
    --hidden-import werkzeug.wrappers ^
    --hidden-import werkzeug.wrappers.request ^
    --hidden-import werkzeug.wrappers.response ^
    --hidden-import flask_sqlalchemy ^
    --hidden-import flask_migrate ^
    --hidden-import sqlalchemy ^
    --hidden-import sqlalchemy.engine ^
    --hidden-import sqlalchemy.pool ^
    --hidden-import sqlalchemy.sql ^
    --hidden-import waitress ^
    --hidden-import waitress.server ^
    --hidden-import rapidocr_onnxruntime ^
    --hidden-import pandas ^
    --hidden-import openpyxl ^
    --hidden-import pdfplumber ^
    --hidden-import pdfminer ^
    --hidden-import onnxruntime ^
    --hidden-import cv2 ^
    --hidden-import PIL ^
    --hidden-import PIL.Image ^
    --hidden-import numpy ^
    --hidden-import shapely ^
    --hidden-import pyclipper ^
    --hidden-import yaml ^
    --collect-submodules flask ^
    --collect-submodules jinja2 ^
    --collect-submodules werkzeug ^
    --collect-submodules flask_sqlalchemy ^
    --collect-submodules flask_migrate ^
    --collect-submodules waitress ^
    --collect-submodules rapidocr_onnxruntime ^
    run_exe_fallback.py

if %ERRORLEVEL% NEQ 0 (
    echo.
    echo ========================================
    echo ERRO ao gerar executavel!
    echo ========================================
    echo.
    pause
    exit /b 1
)

echo.
echo ========================================
echo Executavel gerado com sucesso!
echo ========================================
echo.
echo O executavel esta em: dist\ExtratorDARF_Fallback.exe
echo.
pause


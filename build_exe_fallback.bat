@echo off
REM Script para gerar o executável usando PyInstaller (versão sem PyWebView)
REM Usa run_exe_fallback.py que abre no navegador padrão ao invés de janela nativa

REM Força a janela a permanecer aberta mesmo em caso de erro
setlocal enabledelayedexpansion

REM Muda para o diretório do script
cd /d "%~dp0"

REM Pausa inicial para garantir que a janela não feche
echo ========================================
echo Gerando Executavel Windows (Versao Fallback)
echo ========================================
echo.
echo Esta versao abre no navegador padrao ao inves de janela nativa.
echo Use se pywebview nao foi instalado.
echo.
echo Diretorio atual: %CD%
echo.
echo Iniciando verificacoes...
echo.
timeout /t 2 /nobreak >nul

REM Verifica se Python está disponível
echo Verificando Python...
where python >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    where py >nul 2>&1
    if %ERRORLEVEL% NEQ 0 (
        echo.
        echo ========================================
        echo ERRO: Python nao encontrado no PATH.
        echo ========================================
        echo.
        echo Certifique-se de que Python esta instalado e no PATH.
        echo.
        pause
        exit /b 1
    )
    set PYTHON_CMD=py
    echo [OK] Python encontrado via 'py'
) else (
    set PYTHON_CMD=python
    echo [OK] Python encontrado via 'python'
)
echo.

REM Verifica se as dependências estão instaladas
echo Verificando dependencias Python...
%PYTHON_CMD% -c "import flask" >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo.
    echo ========================================
    echo AVISO: Flask nao encontrado!
    echo ========================================
    echo.
    echo As dependencias precisam ser instaladas antes do build.
    echo.
    echo Opcoes:
    echo 1. Se usar UV: uv sync
    echo 2. Se usar pip: %PYTHON_CMD% -m pip install -r requirements.txt
    echo 3. Python 3.14: Execute instalar_dependencias_py314.bat
    echo.
    echo Deseja instalar as dependencias agora? (S/N)
    set /p INSTALL_DEPS=
    if /i "!INSTALL_DEPS!"=="S" (
        echo.
        echo Tentando instalar dependencias com pip...
        echo (Se falhar, execute: instalar_dependencias_py314.bat)
        echo.
        %PYTHON_CMD% -m pip install -r requirements.txt
        if %ERRORLEVEL% NEQ 0 (
            echo.
            echo ========================================
            echo AVISO: Falha ao instalar com requirements.txt
            echo ========================================
            echo.
            echo Se voce esta usando Python 3.14, execute:
            echo   instalar_dependencias_py314.bat
            echo.
            echo Ou instale manualmente as dependencias.
            echo.
            pause
            exit /b 1
        )
        echo [OK] Dependencias instaladas
    ) else (
        echo.
        echo Por favor, instale as dependencias antes de continuar.
        echo Se usar Python 3.14: instalar_dependencias_py314.bat
        echo.
        pause
        exit /b 1
    )
) else (
    echo [OK] Flask encontrado (dependencias provavelmente instaladas)
)
echo.

REM Verifica se os modelos foram baixados
echo Verificando modelos OCR...
set MODELOS_ENCONTRADOS=0

if exist "ocr_models\ch_PP-OCRv3_det_infer.onnx" (
    echo [OK] Modelo de deteccao encontrado
    set /a MODELOS_ENCONTRADOS+=1
) else (
    echo [ERRO] Modelo de deteccao NAO encontrado!
)

if exist "ocr_models\ch_PP-OCRv3_rec_infer.onnx" (
    echo [OK] Modelo de reconhecimento encontrado
    set /a MODELOS_ENCONTRADOS+=1
) else (
    echo [ERRO] Modelo de reconhecimento NAO encontrado!
)

if exist "ocr_models\ch_ppocr_mobile_v2.0_cls_infer.onnx" (
    echo [OK] Modelo de classificacao encontrado - opcional
) else (
    echo [AVISO] Modelo de classificacao nao encontrado - opcional
)

echo.
REM Verifica se ambos os modelos essenciais existem
REM Usa uma abordagem mais simples: verifica se ambos existem antes de continuar
if not exist "ocr_models\ch_PP-OCRv3_det_infer.onnx" goto :ERRO_DET
if not exist "ocr_models\ch_PP-OCRv3_rec_infer.onnx" goto :ERRO_REC
goto :MODELOS_OK

:ERRO_DET
echo.
echo ========================================
echo ERRO: Modelo de deteccao NAO encontrado!
echo ========================================
echo.
echo Voce precisa ter pelo menos 2 modelos: deteccao e reconhecimento.
echo.
echo Opcoes:
echo 1. Execute: baixar_modelos_manual.bat
echo 2. Baixe manualmente (veja DOWNLOAD_MANUAL_MODELOS.md)
echo 3. Execute: py download_models_simples.py
echo.
echo Pressione qualquer tecla para sair...
pause >nul
exit /b 1

:ERRO_REC
echo.
echo ========================================
echo ERRO: Modelo de reconhecimento NAO encontrado!
echo ========================================
echo.
echo Voce precisa ter pelo menos 2 modelos: deteccao e reconhecimento.
echo.
echo Opcoes:
echo 1. Execute: baixar_modelos_manual.bat
echo 2. Baixe manualmente (veja DOWNLOAD_MANUAL_MODELOS.md)
echo 3. Execute: py download_models_simples.py
echo.
echo Pressione qualquer tecla para sair...
pause >nul
exit /b 1

:MODELOS_OK

echo [OK] Todos os modelos essenciais encontrados!
echo.

REM Verifica se run_exe_fallback.py existe
echo Verificando arquivos necessarios...
if not exist "run_exe_fallback.py" (
    echo.
    echo ========================================
    echo ERRO: run_exe_fallback.py nao encontrado!
    echo ========================================
    echo.
    echo Certifique-se de estar na pasta correta do projeto.
    echo Diretorio atual: %CD%
    echo.
    echo Pressione qualquer tecla para sair...
    pause >nul
    exit /b 1
)
echo [OK] run_exe_fallback.py encontrado
echo.

echo Limpando builds anteriores...
if exist "build" (
    echo   Removendo pasta build...
    rmdir /s /q build
)
if exist "dist" (
    echo   Removendo pasta dist...
    rmdir /s /q dist
)
if exist "ExtratorDARF_Fallback.spec" (
    echo   Removendo arquivo .spec...
    del /q ExtratorDARF_Fallback.spec
)
echo [OK] Limpeza concluida
echo.

echo ========================================
echo Iniciando geracao do executavel...
echo ========================================
echo.
echo ATENCAO: Isso pode levar 5-15 minutos!
echo Nao feche esta janela durante o processo.
echo.
echo Pressione qualquer tecla para COMECAR o build...
pause >nul
echo.
echo Executando PyInstaller...
echo (Aguarde, isso pode demorar varios minutos...)
echo.

%PYTHON_CMD% -m PyInstaller ^
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
    echo Verifique as mensagens de erro acima.
    echo.
    echo Possiveis causas:
    echo - Dependencias faltando
    echo - Erro de sintaxe no codigo
    echo - Problema com PyInstaller
    echo.
    echo Tente executar o PyInstaller manualmente para ver mais detalhes.
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
echo Esta versao abre no navegador padrao do Windows.
echo Teste executando: dist\ExtratorDARF_Fallback.exe
echo.
pause


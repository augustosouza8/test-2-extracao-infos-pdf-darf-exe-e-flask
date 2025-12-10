@echo off
REM Versao de debug do script de build - mostra todas as mensagens

REM Forca a janela a permanecer aberta
setlocal enabledelayedexpansion

echo ========================================
echo Gerando Executavel Windows (Versao Fallback)
echo ========================================
echo.
echo Esta versao abre no navegador padrao ao inves de janela nativa.
echo Use se pywebview nao foi instalado.
echo.
echo Pressione qualquer tecla para continuar...
pause >nul
echo.

REM Verifica se Python está disponível
echo [DEBUG] Verificando Python...
where python >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo [DEBUG] python nao encontrado, tentando py...
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
    echo [DEBUG] Python encontrado via 'py'
) else (
    set PYTHON_CMD=python
    echo [DEBUG] Python encontrado via 'python'
)
echo [DEBUG] Comando Python: %PYTHON_CMD%
echo.

REM Verifica se os modelos foram baixados
echo [DEBUG] Verificando modelos OCR...
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
    echo [OK] Modelo de classificacao encontrado (opcional)
) else (
    echo [AVISO] Modelo de classificacao nao encontrado (opcional)
)

echo [DEBUG] Modelos encontrados: %MODELOS_ENCONTRADOS%
echo.

if %MODELOS_ENCONTRADOS% LSS 2 (
    echo ========================================
    echo ERRO: Modelos OCR essenciais faltando!
    echo ========================================
    echo.
    echo Voce precisa ter pelo menos 2 modelos (deteccao e reconhecimento).
    echo.
    echo Opcoes:
    echo 1. Execute: baixar_modelos_manual.bat
    echo 2. Baixe manualmente (veja DOWNLOAD_MANUAL_MODELOS.md)
    echo 3. Execute: py download_models_simples.py
    echo.
    pause
    exit /b 1
)

REM Verifica se run_exe_fallback.py existe
echo [DEBUG] Verificando arquivos necessarios...
if not exist "run_exe_fallback.py" (
    echo.
    echo ========================================
    echo ERRO: run_exe_fallback.py nao encontrado!
    echo ========================================
    echo.
    echo Certifique-se de estar na pasta correta do projeto.
    echo.
    echo Diretorio atual:
    cd
    echo.
    pause
    exit /b 1
)
echo [OK] run_exe_fallback.py encontrado
echo.

echo [DEBUG] Limpando builds anteriores...
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
echo [DEBUG] Executando PyInstaller...
echo [DEBUG] Comando: %PYTHON_CMD% -m PyInstaller ...
echo.

%PYTHON_CMD% -m PyInstaller ^
    --onefile ^
    --console ^
    --name "ExtratorDARF_Fallback" ^
    --add-data "app/templates;app/templates" ^
    --add-data "app/static;app/static" ^
    --add-data "ocr_models;ocr_models" ^
    --hidden-import rapidocr_onnxruntime ^
    --hidden-import pandas ^
    --hidden-import sqlalchemy ^
    --hidden-import openpyxl ^
    --hidden-import waitress ^
    --hidden-import flask ^
    --hidden-import flask_sqlalchemy ^
    --hidden-import flask_migrate ^
    --hidden-import pdfplumber ^
    --hidden-import pdfminer ^
    --hidden-import onnxruntime ^
    --hidden-import cv2 ^
    --hidden-import pillow ^
    --hidden-import numpy ^
    --hidden-import shapely ^
    --hidden-import pyclipper ^
    --hidden-import yaml ^
    --collect-all rapidocr_onnxruntime ^
    --collect-all waitress ^
    run_exe_fallback.py

set BUILD_RESULT=%ERRORLEVEL%
echo.
echo [DEBUG] PyInstaller retornou codigo: %BUILD_RESULT%

if %BUILD_RESULT% NEQ 0 (
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


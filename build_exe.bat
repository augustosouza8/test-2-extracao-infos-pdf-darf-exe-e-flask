@echo off
REM Script para gerar o executável usando PyInstaller
REM Certifique-se de ter executado setup_exe.bat primeiro

echo ========================================
echo Gerando Executavel Windows
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

REM Verifica se os modelos foram baixados (opcional, mas recomendado)
if not exist "ocr_models\ch_PP-OCRv3_det_infer.onnx" (
    echo AVISO: Modelos OCR nao encontrados em ocr_models\
    echo O executavel sera gerado, mas pode nao ter suporte completo a OCR.
    echo Os modelos podem ser baixados depois ou ja podem estar incluidos.
    echo Continuando...
    echo.
)

echo Verificando pre-requisitos...
call verificar_antes_build.bat
set VERIFY_RESULT=%ERRORLEVEL%
if %VERIFY_RESULT% NEQ 0 (
    echo.
    echo AVISO: Verificacoes retornaram avisos, mas continuando...
    echo.
)
echo.

echo Limpando builds anteriores...
if exist "build" rmdir /s /q build
if exist "dist" rmdir /s /q dist
REM Mantem ExtratorDARF.spec se existir (pode ter configuracoes customizadas)
echo.

echo Gerando executavel (isso pode levar varios minutos)...
echo IMPORTANTE: Este processo pode demorar 5-20 minutos.
echo Nao feche esta janela!
echo Processando... Aguarde...
echo.

REM Verifica se rapidocr está instalado para adicionar como hidden-import
set RAPIDOCR_IMPORT=
%PYTHON_CMD% -c "import rapidocr_onnxruntime" >nul 2>&1
if %ERRORLEVEL% EQU 0 (
    echo [INFO] rapidocr-onnxruntime encontrado - incluindo no executavel
    set RAPIDOCR_IMPORT=--hidden-import rapidocr_onnxruntime
) else (
    echo [AVISO] rapidocr-onnxruntime nao encontrado - continuando sem ele
    set RAPIDOCR_IMPORT=
)
echo.

echo Executando PyInstaller...
echo Isso pode demorar varios minutos. Aguarde...
echo.

REM Executa PyInstaller diretamente (sem variável quebrada)
%PYTHON_CMD% -m PyInstaller ^
    --onefile ^
    --windowed ^
    --name "ExtratorDARF" ^
    --add-data "ocr_models;ocr_models" ^
    --hidden-import pandas ^
    --hidden-import sqlalchemy ^
    --hidden-import openpyxl ^
    --hidden-import PyQt6 ^
    --hidden-import PyQt6.QtCore ^
    --hidden-import PyQt6.QtGui ^
    --hidden-import PyQt6.QtWidgets ^
    --hidden-import pdfplumber ^
    --hidden-import pdfminer.six ^
    --hidden-import pdfminer ^
    --hidden-import cv2 ^
    --hidden-import PIL ^
    --hidden-import pillow ^
    --hidden-import shapely ^
    --hidden-import pyclipper ^
    --hidden-import yaml ^
    --hidden-import dotenv ^
    --hidden-import app.config ^
    --hidden-import app.database.db_session ^
    --hidden-import app.database.direct ^
    --hidden-import app.models_direct ^
    --hidden-import app.services.pdf_parser ^
    --hidden-import app.services.excel_generator ^
    --hidden-import app.utils.formatters ^
    --hidden-import app.utils.errors ^
    --hidden-import app.utils.validators ^
    --collect-all PyQt6 ^
    --collect-submodules PyQt6 ^
    --collect-all dotenv ^
    --noconfirm ^
    --clean ^
    main.py

REM Se rapidocr estiver instalado, adiciona como import opcional (mas não crítico)
REM O PyInstaller já foi executado acima, então isso é apenas informativo
if not "%RAPIDOCR_IMPORT%"=="" (
    echo [INFO] Nota: rapidocr-onnxruntime nao foi incluido porque variavel estava vazia
)

set BUILD_RESULT=%ERRORLEVEL%
echo.
echo ========================================
echo PyInstaller terminou com codigo: %BUILD_RESULT%
echo ========================================
echo.
if %BUILD_RESULT% NEQ 0 (
    echo.
    echo ========================================
    echo ERRO ao gerar executavel!
    echo ========================================
    echo.
    echo Codigo de erro: %BUILD_RESULT%
    echo Verifique as mensagens acima para detalhes.
    echo.
    echo Possiveis causas:
    echo - Alguma dependencia faltando
    echo - Erro no PyInstaller
    echo - Problemas com Python 3.14 (considere usar Python 3.11 ou 3.12)
    echo.
    REM So pausa se nao foi chamado por outro script
    if "%CALLER%"=="" pause
    exit /b %BUILD_RESULT%
)

echo.
REM Verifica se o arquivo realmente existe
if exist "dist\ExtratorDARF.exe" (
    echo ========================================
    echo Executavel gerado com sucesso!
    echo ========================================
    echo.
    echo O executavel esta em: dist\ExtratorDARF.exe
    for %%A in ("dist\ExtratorDARF.exe") do (
        echo Tamanho: %%~zA bytes (~%%~zA / 1048576 MB)
    )
    echo.
    echo Para testar o executavel, execute:
    echo   testar_exe.bat
    echo.
    echo Para distribuir:
    echo   1. Copie apenas o arquivo dist\ExtratorDARF.exe
    echo   2. Nao precisa de outras dependencias ou instalacoes
    echo   3. Usuarios finais podem executar direto (duplo clique)
    echo.
    echo IMPORTANTE:
    echo - O executavel e auto-contido (nao precisa instalar Python)
    echo - Modelos OCR estao incluidos no executavel
    echo - Primeira execucao pode demorar alguns segundos
    echo.
) else (
    echo ========================================
    echo ERRO: Executavel NAO foi gerado!
    echo ========================================
    echo.
    echo O arquivo dist\ExtratorDARF.exe nao existe.
    echo.
    echo Possiveis causas:
    echo - Erro no PyInstaller (verifique mensagens acima)
    echo - Dependencia faltando
    echo - Erro de compilacao
    echo.
    echo Verifique a pasta dist\ para ver se ha algum arquivo gerado.
    echo.
)

REM Sempre mostra resultado - nao fecha automaticamente
if "%CALLER%"=="" (
    echo.
    echo Pressione qualquer tecla para fechar...
    pause >nul
)


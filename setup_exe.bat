@echo off
REM Script de setup para gerar o executável Windows
REM Execute este arquivo para instalar dependências e preparar o ambiente

echo ========================================
echo Setup para Gerar Executável Windows
echo ========================================
echo.

REM Verifica se Python está disponível
where python >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    where py >nul 2>&1
    if %ERRORLEVEL% NEQ 0 (
        echo ERRO: Python nao encontrado no PATH.
        echo Por favor, instale Python ou adicione ao PATH.
        pause
        exit /b 1
    )
    set PYTHON_CMD=py
) else (
    set PYTHON_CMD=python
)

echo [1/4] Instalando dependencias...
echo.

REM Atualiza pip primeiro
echo Atualizando pip...
%PYTHON_CMD% -m pip install --upgrade pip --quiet
echo.

REM Instala PyInstaller primeiro (essencial)
echo Instalando PyInstaller...
%PYTHON_CMD% -m pip install pyinstaller
if %ERRORLEVEL% NEQ 0 (
    echo ERRO ao instalar PyInstaller.
    pause
    exit /b 1
)
echo.

REM Instala PyQt6 (essencial para a aplicação desktop)
echo Instalando PyQt6...
%PYTHON_CMD% -m pip install PyQt6
if %ERRORLEVEL% NEQ 0 (
    echo ERRO ao instalar PyQt6.
    pause
    exit /b 1
)
echo.

REM Instala todas as outras dependências do projeto manualmente
echo Instalando demais dependencias do projeto...
echo.
echo Verificando onnxruntime - requisito do rapidocr...
%PYTHON_CMD% -m pip install onnxruntime >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo AVISO: onnxruntime nao disponivel para Python 3.14
    echo Continuando sem rapidocr-onnxruntime - executavel ainda funcionara se modelos existirem.
    echo.
    goto :skip_rapidocr
)
echo.

REM Instala outras dependências
echo Instalando dependencias principais...
echo Ignorando numpy se ja estiver instalado para evitar recompilacao
%PYTHON_CMD% -m pip install pdfplumber pandas openpyxl sqlalchemy pillow opencv-python-headless shapely pyclipper pyyaml --ignore-installed numpy
if %ERRORLEVEL% NEQ 0 (
    echo AVISO: Algumas dependencias podem ter falhado, mas continuando...
)
echo.

:skip_rapidocr
echo Tentando instalar rapidocr-onnxruntime...
%PYTHON_CMD% -m pip install "rapidocr-onnxruntime>=1.2.0,<1.3.0" >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo Tentando versao mais antiga...
    %PYTHON_CMD% -m pip install "rapidocr-onnxruntime>=1.1.0" >nul 2>&1
    if %ERRORLEVEL% NEQ 0 (
        echo AVISO: rapidocr-onnxruntime nao pode ser instalado - requer onnxruntime que nao esta disponivel para Python 3.14
        echo Continuando sem rapidocr-onnxruntime.
        echo O executavel ainda funcionara se os modelos OCR estiverem em ocr_models\
        echo.
        goto :skip_rapidocr_done
    )
)
:skip_rapidocr_done
echo.

echo [2/4] Verificando instalacao do PyQt6...
echo.
%PYTHON_CMD% -c "from PyQt6.QtCore import PYQT_VERSION_STR; print('[OK] PyQt6 instalado:', PYQT_VERSION_STR)" >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo Testando importacao basica do PyQt6...
    %PYTHON_CMD% -c "import PyQt6.QtWidgets; print('[OK] PyQt6 instalado e funcional')" >nul 2>&1
    if %ERRORLEVEL% NEQ 0 (
        echo ERRO: PyQt6 nao foi instalado corretamente.
        pause
        exit /b 1
    )
)
echo.

echo [3/4] Baixando modelos OCR...
echo.
echo Metodo 1: Tentando baixar modelos diretamente...
%PYTHON_CMD% download_models_simples.py >nul 2>&1
set DOWNLOAD_RESULT=%ERRORLEVEL%
if %DOWNLOAD_RESULT% EQU 0 (
    echo [OK] Modelos verificados/baixados com sucesso
) else (
    echo AVISO: download_models.py retornou erro, mas continuando...
    echo.
    echo Metodo 2: Verificando se rapidocr foi instalado...
    %PYTHON_CMD% -c "import rapidocr_onnxruntime" >nul 2>&1
    if %ERRORLEVEL% EQU 0 (
        echo Forcando download via RapidOCR - pode demorar...
        echo Isso vai inicializar o RapidOCR que baixara os modelos automaticamente.
        %PYTHON_CMD% -c "from rapidocr_onnxruntime import RapidOCR; print('Inicializando RapidOCR...'); ocr = RapidOCR(); print('RapidOCR inicializado. Modelos devem estar no cache.')"
        if %ERRORLEVEL% EQU 0 (
            echo.
            echo Tentando copiar modelos do cache do RapidOCR...
            %PYTHON_CMD% download_models_simples.py >nul 2>&1
            if %ERRORLEVEL% NEQ 0 (
                echo.
                echo AVISO: Nao foi possivel obter os modelos OCR automaticamente.
                echo.
                echo Se os modelos ja existem em ocr_models\, o executavel funcionara.
                echo Caso contrario, baixe manualmente de:
                echo   https://github.com/RapidAI/RapidOCR/releases/download/v1.4.0/
                echo.
                echo Ou execute: py download_models_simples.py
                echo.
            )
        ) else (
            echo AVISO: Nao foi possivel inicializar RapidOCR.
            echo Continuando - modelos podem estar em ocr_models\ ou podem ser baixados depois.
            echo.
        )
    ) else (
        echo AVISO: rapidocr-onnxruntime nao foi instalado.
        echo O executavel pode funcionar sem OCR se os modelos ja estiverem em ocr_models\
        echo.
    )
)

echo.

echo [4/4] Verificando modelos baixados...
echo.

set MODELOS_OK=0

if exist "ocr_models\ch_PP-OCRv3_det_infer.onnx" (
    echo [OK] Modelo de deteccao encontrado
    set /a MODELOS_OK+=1
) else (
    echo [ERRO] Modelo de deteccao nao encontrado!
)

if exist "ocr_models\ch_PP-OCRv3_rec_infer.onnx" (
    echo [OK] Modelo de reconhecimento encontrado
    set /a MODELOS_OK+=1
) else (
    echo [ERRO] Modelo de reconhecimento nao encontrado!
)

if exist "ocr_models\ch_ppocr_mobile_v2.0_cls_infer.onnx" (
    echo [OK] Modelo de classificacao encontrado
    set /a MODELOS_OK+=1
) else (
        echo [AVISO] Modelo de classificacao nao encontrado - opcional
)

echo.
if %MODELOS_OK% LSS 2 (
    echo ========================================
    echo AVISO: Modelos essenciais faltando!
    echo ========================================
    echo.
    echo Os modelos podem ser baixados depois.
    echo Opcoes:
    echo   1. Execute: download_models_simples.py
    echo   2. Ou baixe manualmente de:
    echo      https://github.com/RapidAI/RapidOCR/releases/download/v1.4.0/
    echo.
    echo Continuando mesmo sem os modelos...
    echo O executavel funcionara mas pode nao ter OCR completo
    echo.
    echo NOTA: Se rapidocr-onnxruntime nao foi instalado, pode ser porque
    echo Python 3.14 nao tem suporte completo. Considere usar Python 3.11 ou 3.12.
    echo.
)

echo.
echo ========================================
echo Setup concluido!
echo ========================================
echo.
echo [OK] Setup finalizado!
echo.

REM Verifica se foi chamado por outro script (variável CALLER)
if "%CALLER%"=="" (
    echo NOTA: Algumas dependencias opcionais podem nao estar instaladas
    echo ex: rapidocr-onnxruntime - mas isso nao impede gerar o executavel.
    echo.
    echo Para gerar o executavel, execute:
    echo   build_exe.bat
    echo.
    echo O executavel sera gerado em: dist\ExtratorDARF.exe
    echo.
    pause
) else (
    echo Continuando para proximo passo...
)

exit /b 0


@echo off
REM Script de teste para verificar se tudo está pronto para o build

echo ========================================
echo Teste de Ambiente para Build
echo ========================================
echo.

REM Verifica Python
echo [1/5] Verificando Python...
where python >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    where py >nul 2>&1
    if %ERRORLEVEL% NEQ 0 (
        echo [ERRO] Python nao encontrado!
        pause
        exit /b 1
    )
    set PYTHON_CMD=py
    echo [OK] Python encontrado: py
) else (
    set PYTHON_CMD=python
    echo [OK] Python encontrado: python
)

REM Verifica versão do Python
echo.
echo [2/5] Verificando versao do Python...
%PYTHON_CMD% --version
if %ERRORLEVEL% NEQ 0 (
    echo [ERRO] Nao foi possivel verificar versao do Python
    pause
    exit /b 1
)

REM Verifica PyInstaller
echo.
echo [3/5] Verificando PyInstaller...
%PYTHON_CMD% -m PyInstaller --version
if %ERRORLEVEL% NEQ 0 (
    echo [ERRO] PyInstaller nao encontrado!
    echo Instale com: %PYTHON_CMD% -m pip install pyinstaller
    pause
    exit /b 1
)

REM Verifica modelos
echo.
echo [4/5] Verificando modelos OCR...
set MODELOS_OK=0
if exist "ocr_models\ch_PP-OCRv3_det_infer.onnx" (
    echo [OK] Modelo de deteccao encontrado
    set /a MODELOS_OK+=1
) else (
    echo [ERRO] Modelo de deteccao NAO encontrado!
)

if exist "ocr_models\ch_PP-OCRv3_rec_infer.onnx" (
    echo [OK] Modelo de reconhecimento encontrado
    set /a MODELOS_OK+=1
) else (
    echo [ERRO] Modelo de reconhecimento NAO encontrado!
)

if exist "ocr_models\ch_ppocr_mobile_v2.0_cls_infer.onnx" (
    echo [OK] Modelo de classificacao encontrado (opcional)
) else (
    echo [AVISO] Modelo de classificacao nao encontrado (opcional)
)

if %MODELOS_OK% LSS 2 (
    echo.
    echo [ERRO] Modelos essenciais faltando!
    pause
    exit /b 1
)

REM Verifica arquivos do projeto
echo.
echo [5/5] Verificando arquivos do projeto...
if not exist "run_exe_fallback.py" (
    echo [ERRO] run_exe_fallback.py nao encontrado!
    pause
    exit /b 1
)
echo [OK] run_exe_fallback.py encontrado

if not exist "app\__init__.py" (
    echo [ERRO] app\__init__.py nao encontrado!
    pause
    exit /b 1
)
echo [OK] app\__init__.py encontrado

if not exist "app\templates" (
    echo [ERRO] app\templates nao encontrado!
    pause
    exit /b 1
)
echo [OK] app\templates encontrado

if not exist "app\static" (
    echo [ERRO] app\static nao encontrado!
    pause
    exit /b 1
)
echo [OK] app\static encontrado

echo.
echo ========================================
echo [OK] Ambiente pronto para build!
echo ========================================
echo.
echo Voce pode executar: build_exe_fallback.bat
echo.
pause


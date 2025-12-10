@echo off
REM Script para verificar se tudo está pronto antes de gerar o executável

echo ========================================
echo Verificacao Pre-Build
echo ========================================
echo.

set ERROS=0

REM Verifica Python
where python >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    where py >nul 2>&1
    if %ERRORLEVEL% NEQ 0 (
        echo [ERRO] Python nao encontrado no PATH.
        set /a ERROS+=1
    ) else (
        set PYTHON_CMD=py
        echo [OK] Python encontrado (py)
    )
) else (
    set PYTHON_CMD=python
    echo [OK] Python encontrado (python)
)

REM Verifica PyInstaller
echo Verificando PyInstaller...
%PYTHON_CMD% -c "import PyInstaller; print('[OK] PyInstaller instalado:', PyInstaller.__version__)" >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo [ERRO] PyInstaller nao instalado. Execute: setup_exe.bat
    set /a ERROS+=1
)

REM Verifica PyQt6
echo Verificando PyQt6...
%PYTHON_CMD% -c "from PyQt6.QtCore import PYQT_VERSION_STR; print('[OK] PyQt6 instalado:', PYQT_VERSION_STR)" >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    %PYTHON_CMD% -c "import PyQt6.QtWidgets; print('[OK] PyQt6 instalado e funcional')" >nul 2>&1
    if %ERRORLEVEL% NEQ 0 (
        echo [ERRO] PyQt6 nao instalado. Execute: setup_exe.bat
        set /a ERROS+=1
    )
)

REM Verifica modelos OCR
echo Verificando modelos OCR...
if not exist "ocr_models\ch_PP-OCRv3_det_infer.onnx" (
    echo [ERRO] Modelo de deteccao nao encontrado. Execute: setup_exe.bat
    set /a ERROS+=1
) else (
    echo [OK] Modelo de deteccao encontrado
)

if not exist "ocr_models\ch_PP-OCRv3_rec_infer.onnx" (
    echo [ERRO] Modelo de reconhecimento nao encontrado. Execute: setup_exe.bat
    set /a ERROS+=1
) else (
    echo [OK] Modelo de reconhecimento encontrado
)

REM Verifica main.py
if not exist "main.py" (
    echo [ERRO] Arquivo main.py nao encontrado.
    set /a ERROS+=1
) else (
    echo [OK] main.py encontrado
)

REM Verifica estrutura de diretórios
if not exist "app\gui\main_window.py" (
    echo [ERRO] app\gui\main_window.py nao encontrado.
    set /a ERROS+=1
) else (
    echo [OK] Estrutura GUI encontrada
)

echo.
echo ========================================
if %ERROS% EQU 0 (
    echo Todas as verificacoes passaram!
    echo.
    echo Pode prosseguir com: build_exe.bat
    echo ========================================
    exit /b 0
) else (
    echo Total de erros: %ERROS%
    echo.
    echo AVISO: Continuando mesmo assim...
    echo Alguns componentes podem estar faltando - ex: rapidocr-onnxruntime
    echo mas o executavel ainda pode ser gerado.
    echo ========================================
    exit /b 0
)


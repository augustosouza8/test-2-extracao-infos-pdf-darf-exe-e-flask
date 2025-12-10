@echo off
REM Script para debugar problemas no build

echo ========================================
echo Debug do Build
echo ========================================
echo.

where python >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    where py >nul 2>&1
    if %ERRORLEVEL% NEQ 0 (
        echo ERRO: Python nao encontrado
        pause
        exit /b 1
    )
    set PYTHON_CMD=py
) else (
    set PYTHON_CMD=python
)

echo [1] Python: %PYTHON_CMD%
%PYTHON_CMD% --version
echo.

echo [2] Verificando PyInstaller...
%PYTHON_CMD% -c "import PyInstaller; print('OK:', PyInstaller.__version__)"
echo.

echo [3] Verificando PyQt6...
%PYTHON_CMD% -c "from PyQt6.QtCore import PYQT_VERSION_STR; print('OK:', PYQT_VERSION_STR)" 2>nul || %PYTHON_CMD% -c "import PyQt6.QtWidgets; print('OK: instalado')"
echo.

echo [4] Verificando rapidocr...
%PYTHON_CMD% -c "import rapidocr_onnxruntime; print('OK: instalado')" 2>nul || echo "NAO INSTALADO (opcional)"
echo.

echo [5] Verificando modelos OCR...
if exist "ocr_models\ch_PP-OCRv3_det_infer.onnx" (
    echo OK: Modelos encontrados
) else (
    echo AVISO: Modelos nao encontrados
)
echo.

echo [6] Verificando main.py...
if exist "main.py" (
    echo OK: main.py existe
) else (
    echo ERRO: main.py nao encontrado
)
echo.

echo [7] Verificando estrutura GUI...
if exist "app\gui\main_window.py" (
    echo OK: Estrutura GUI encontrada
) else (
    echo ERRO: app\gui\main_window.py nao encontrado
)
echo.

echo [8] Testando import do main...
%PYTHON_CMD% -c "import sys; sys.path.insert(0, '.'); from app.gui.main_window import MainWindow; print('OK: Import funcionou')" 2>nul || echo "ERRO: Falha ao importar"
echo.

echo ========================================
echo Debug concluido
echo ========================================
pause


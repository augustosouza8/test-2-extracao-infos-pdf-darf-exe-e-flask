@echo off
REM Script simples para testar apenas o build
REM Use este para ver se o PyInstaller está funcionando

echo ========================================
echo Teste de Build Simples
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

echo Testando PyInstaller...
%PYTHON_CMD% -m PyInstaller --version
if %ERRORLEVEL% NEQ 0 (
    echo ERRO: PyInstaller nao encontrado
    pause
    exit /b 1
)
echo.

echo Testando import do main.py...
%PYTHON_CMD% -c "import sys; sys.path.insert(0, '.'); from app.gui.main_window import MainWindow; print('OK: Import funcionou')"
if %ERRORLEVEL% NEQ 0 (
    echo ERRO: Falha ao importar main.py
    pause
    exit /b 1
)
echo.

echo Limpando builds anteriores...
if exist "build" rmdir /s /q build
if exist "dist" rmdir /s /q dist
echo.

echo Executando PyInstaller (versao simplificada)...
echo Isso pode demorar alguns minutos...
echo.

%PYTHON_CMD% -m PyInstaller --onefile --windowed --name "ExtratorDARF" --add-data "ocr_models;ocr_models" --hidden-import PyQt6.QtWidgets main.py

set RESULT=%ERRORLEVEL%
echo.
echo ========================================
echo Resultado: %RESULT%
echo ========================================
echo.

if %RESULT% EQU 0 (
    if exist "dist\ExtratorDARF.exe" (
        echo [SUCESSO] Executavel gerado!
        echo Local: dist\ExtratorDARF.exe
    ) else (
        echo [ERRO] PyInstaller retornou sucesso mas executavel nao existe
    )
) else (
    echo [ERRO] PyInstaller falhou com codigo %RESULT%
)

echo.
pause


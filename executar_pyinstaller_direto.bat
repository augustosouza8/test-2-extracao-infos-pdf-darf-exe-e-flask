@echo off
REM Script para executar PyInstaller diretamente sem variáveis condicionais

echo ========================================
echo Executando PyInstaller Diretamente
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

echo Limpando builds anteriores...
if exist "build" rmdir /s /q build
if exist "dist" rmdir /s /q dist
echo.

echo Executando PyInstaller...
echo Isso pode demorar varios minutos...
echo.

%PYTHON_CMD% -m PyInstaller --onefile --windowed --name "ExtratorDARF" --add-data "ocr_models;ocr_models" --hidden-import pandas --hidden-import sqlalchemy --hidden-import openpyxl --hidden-import PyQt6 --hidden-import PyQt6.QtCore --hidden-import PyQt6.QtGui --hidden-import PyQt6.QtWidgets --hidden-import pdfplumber --hidden-import pdfminer.six --hidden-import pdfminer --hidden-import cv2 --hidden-import PIL --hidden-import pillow --hidden-import shapely --hidden-import pyclipper --hidden-import yaml --hidden-import app.database.db_session --hidden-import app.database.direct --hidden-import app.models_direct --hidden-import app.services.pdf_parser --hidden-import app.services.excel_generator --hidden-import app.utils.formatters --hidden-import app.utils.errors --hidden-import app.utils.validators --collect-all PyQt6 --collect-submodules PyQt6 --noconfirm --clean main.py

set RESULT=%ERRORLEVEL%
echo.
echo ========================================
echo PyInstaller retornou codigo: %RESULT%
echo ========================================
echo.

if %RESULT% EQU 0 (
    if exist "dist\ExtratorDARF.exe" (
        echo [SUCESSO] Executavel gerado!
        echo Local: dist\ExtratorDARF.exe
    ) else (
        echo [ERRO] PyInstaller retornou sucesso mas executavel nao existe
        echo Verifique a pasta build\ExtratorDARF\warn-ExtratorDARF.txt
    )
) else (
    echo [ERRO] PyInstaller falhou
    echo Verifique os erros acima
)

echo.
pause


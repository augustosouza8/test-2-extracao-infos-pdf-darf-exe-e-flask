@echo off
REM Script para instalar dependências antes do build

echo ========================================
echo Instalando Dependencias Python
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

echo Usando: %PYTHON_CMD%
echo.

REM Verifica se uv está disponível
where uv >nul 2>&1
if %ERRORLEVEL% EQU 0 (
    echo [OK] UV encontrado
    echo.
    echo Instalando dependencias com UV...
    uv sync
    if %ERRORLEVEL% EQU 0 (
        echo.
        echo [OK] Dependencias instaladas com UV!
        echo.
        pause
        exit /b 0
    ) else (
        echo.
        echo AVISO: UV falhou, tentando com pip...
        echo.
    )
) else (
    echo [INFO] UV nao encontrado, usando pip...
    echo.
)

REM Fallback para pip
echo Instalando dependencias com pip...
%PYTHON_CMD% -m pip install --upgrade pip
%PYTHON_CMD% -m pip install -r requirements.txt

if %ERRORLEVEL% EQU 0 (
    echo.
    echo [OK] Dependencias instaladas com pip!
) else (
    echo.
    echo ERRO: Falha ao instalar dependencias.
    echo.
    echo Tente instalar manualmente:
    echo   %PYTHON_CMD% -m pip install -r requirements.txt
    echo.
    pause
    exit /b 1
)

echo.
pause


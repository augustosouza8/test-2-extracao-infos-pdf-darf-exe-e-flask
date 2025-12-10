@echo off
REM Script para verificar versão do Python e compatibilidade

echo ========================================
echo Verificando Python e Compatibilidade
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

echo [1/3] Versao do Python:
%PYTHON_CMD% --version
echo.

echo [2/3] Verificando se onnxruntime esta disponivel...
%PYTHON_CMD% -m pip index versions onnxruntime 2>nul
if %ERRORLEVEL% NEQ 0 (
    echo.
    echo AVISO: Nao foi possivel verificar versoes disponiveis.
    echo Tentando instalar onnxruntime para testar...
    %PYTHON_CMD% -m pip install onnxruntime --dry-run 2>&1 | findstr /i "error\|no matching\|could not"
    if %ERRORLEVEL% EQU 0 (
        echo.
        echo ========================================
        echo PROBLEMA: onnxruntime nao disponivel para esta versao do Python!
        echo ========================================
        echo.
        echo Solucao: Use Python 3.11 ou 3.12
        echo Veja SOLUCAO_PYTHON_314.md para mais detalhes.
    ) else (
        echo [OK] onnxruntime parece estar disponivel
    )
) else (
    echo [OK] Versoes de onnxruntime encontradas
)
echo.

echo [3/3] Verificando Flask instalado...
%PYTHON_CMD% -c "import flask; print('[OK] Flask instalado - versao:', flask.__version__)" 2>nul || echo [ERRO] Flask nao instalado
echo.

echo ========================================
echo Verificacao concluida
echo ========================================
echo.
pause


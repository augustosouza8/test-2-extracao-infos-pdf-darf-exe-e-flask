@echo off
REM Script para instalar rapidocr-onnxruntime manualmente
REM Tenta várias abordagens caso a instalação padrão falhe

echo ========================================
echo Instalacao Manual do RapidOCR
echo ========================================
echo.

REM Verifica Python
where python >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    where py >nul 2>&1
    if %ERRORLEVEL% NEQ 0 (
        echo ERRO: Python nao encontrado.
        pause
        exit /b 1
    )
    set PYTHON_CMD=py
) else (
    set PYTHON_CMD=python
)

echo [1/3] Instalando onnxruntime...
%PYTHON_CMD% -m pip install onnxruntime
if %ERRORLEVEL% NEQ 0 (
    echo ERRO: Falha ao instalar onnxruntime.
    echo Isso pode acontecer com Python 3.14 (muito recente).
    echo Tente usar Python 3.11 ou 3.12.
    pause
    exit /b 1
)
echo.

echo [2/3] Instalando rapidocr-onnxruntime...
echo Tentando versao mais recente...
%PYTHON_CMD% -m pip install rapidocr-onnxruntime
if %ERRORLEVEL% NEQ 0 (
    echo Tentando versao especifica 1.2.3...
    %PYTHON_CMD% -m pip install rapidocr-onnxruntime==1.2.3
    if %ERRORLEVEL% NEQ 0 (
        echo Tentando versao mais antiga 1.1.30...
        %PYTHON_CMD% -m pip install rapidocr-onnxruntime==1.1.30
        if %ERRORLEVEL% NEQ 0 (
            echo.
            echo ========================================
            echo ERRO: Nao foi possivel instalar rapidocr-onnxruntime
            echo ========================================
            echo.
            echo Possiveis causas:
            echo - Python 3.14 pode nao ter suporte completo ainda
            echo - onnxruntime pode nao estar disponivel para sua versao do Python
            echo.
            echo Solucoes:
            echo 1. Use Python 3.11 ou 3.12 (recomendado)
            echo 2. Instale manualmente: pip install onnxruntime rapidocr-onnxruntime
            echo 3. O executavel pode funcionar sem OCR se os modelos ja existirem
            echo.
            pause
            exit /b 1
        )
    )
)
echo.

echo [3/3] Verificando instalacao...
%PYTHON_CMD% -c "import rapidocr_onnxruntime; print('[OK] rapidocr-onnxruntime instalado com sucesso')"
if %ERRORLEVEL% NEQ 0 (
    echo ERRO: rapidocr-onnxruntime nao pode ser importado.
    pause
    exit /b 1
)
echo.

echo ========================================
echo Instalacao concluida!
echo ========================================
echo.
pause


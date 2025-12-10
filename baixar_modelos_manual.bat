@echo off
REM Script manual para baixar modelos OCR
REM Use este script se o setup_exe.bat falhar ao baixar modelos

echo ========================================
echo Download Manual de Modelos OCR
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

echo Criando pasta ocr_models se nao existir...
if not exist "ocr_models" mkdir ocr_models
echo.

echo Metodo 1: Tentando baixar via download_models_simples.py...
%PYTHON_CMD% download_models_simples.py
if %ERRORLEVEL% EQU 0 (
    echo.
    echo [OK] Modelos baixados com sucesso!
    goto :verificar
)

echo.
echo Metodo 1 falhou. Tentando metodo 2...
echo.
echo Metodo 2: Forcando download via RapidOCR...
echo (Isso pode demorar alguns minutos na primeira vez)
echo.
%PYTHON_CMD% -c "from rapidocr_onnxruntime import RapidOCR; print('Inicializando RapidOCR...'); ocr = RapidOCR(); print('Concluido!')"
if %ERRORLEVEL% EQU 0 (
    echo.
    echo Tentando copiar modelos do cache...
    %PYTHON_CMD% download_models_simples.py
    if %ERRORLEVEL% EQU 0 (
        echo.
        echo [OK] Modelos copiados do cache com sucesso!
        goto :verificar
    )
)

echo.
echo ========================================
echo ERRO: Nao foi possivel baixar os modelos
echo ========================================
echo.
echo Solucoes:
echo 1. Verifique sua conexao com a internet
echo 2. Tente executar novamente
echo 3. Baixe manualmente de:
echo    https://github.com/RapidAI/RapidOCR/releases/download/v1.4.0/
echo.
echo Arquivos necessarios:
echo - ch_PP-OCRv3_det_infer.onnx
echo - ch_PP-OCRv3_rec_infer.onnx
echo - ch_ppocr_mobile_v2.0_cls_infer.onnx
echo.
echo Coloque os arquivos na pasta ocr_models\
echo.
pause
exit /b 1

:verificar
echo.
echo ========================================
echo Verificando modelos baixados...
echo ========================================
echo.

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
    echo [OK] Modelo de classificacao encontrado
    set /a MODELOS_OK+=1
) else (
    echo [AVISO] Modelo de classificacao nao encontrado (opcional)
)

echo.
if %MODELOS_OK% GEQ 2 (
    echo ========================================
    echo [OK] Modelos essenciais encontrados!
    echo ========================================
    echo.
    echo Voce pode prosseguir com: build_exe_fallback.bat
) else (
    echo ========================================
    echo [ERRO] Modelos essenciais faltando!
    echo ========================================
    echo.
    echo E necessario ter pelo menos 2 modelos (deteccao e reconhecimento).
    echo Tente novamente ou baixe manualmente.
)
echo.
pause


@echo off
REM Script mestre para gerar executável completo COM DEBUG
REM Executa setup, verificação e build em sequência com logs detalhados

echo ========================================
echo Gerador de Executavel - Processo Completo (DEBUG)
echo ========================================
echo.
echo Este script ira:
echo   1. Verificar/instalar dependencias
echo   2. Verificar modelos OCR
echo   3. Gerar o executavel
echo.
echo Tempo estimado: 15-30 minutos
echo.
echo IMPORTANTE: Logs detalhados serao exibidos.
echo.
pause

REM Cria arquivo de log
set LOGFILE=build_log_%date:~-4,4%%date:~-7,2%%date:~-10,2%_%time:~0,2%%time:~3,2%%time:~6,2%.txt
set LOGFILE=%LOGFILE: =0%
echo Log sendo salvo em: %LOGFILE%
echo.

echo ========================================
echo PASSO 1: Setup
echo ========================================
echo.

set CALLER=GERAR_EXE_DEBUG
call setup_exe.bat >> %LOGFILE% 2>&1
set SETUP_ERROR=%ERRORLEVEL%
set CALLER=

if %SETUP_ERROR% NEQ 0 (
    echo.
    echo AVISO: Setup retornou codigo de erro %SETUP_ERROR%.
    echo Continuando mesmo assim...
    echo.
) else (
    echo [OK] Setup concluido com sucesso
)
echo.

echo ========================================
echo PASSO 2: Verificacao
echo ========================================
echo.

call verificar_antes_build.bat >> %LOGFILE% 2>&1
set VERIFY_ERROR=%ERRORLEVEL%

if %VERIFY_ERROR% NEQ 0 (
    echo.
    echo AVISO: Verificacao retornou codigo de erro %VERIFY_ERROR%.
    echo Continuando mesmo assim...
    echo.
) else (
    echo [OK] Verificacao passou
)
echo.

echo ========================================
echo PASSO 3: Gerar Executavel
echo ========================================
echo.
echo Executando build_exe.bat...
echo Logs sendo salvos em: %LOGFILE%
echo.

set CALLER=GERAR_EXE_DEBUG
call build_exe.bat
set BUILD_ERROR=%ERRORLEVEL%
set CALLER=

echo.
echo ========================================
echo RESULTADO DO BUILD
echo ========================================
echo Codigo de retorno: %BUILD_ERROR%
echo.

if %BUILD_ERROR% NEQ 0 (
    echo [ERRO] Build falhou com codigo %BUILD_ERROR%
    echo.
    echo Verifique o arquivo de log: %LOGFILE%
    echo.
) else (
    echo [OK] Build concluido
    echo.
)

REM Verifica se o executavel foi gerado
if exist "dist\ExtratorDARF.exe" (
    echo [SUCESSO] O executavel foi gerado!
    echo.
    echo Localizacao: dist\ExtratorDARF.exe
    for %%A in ("dist\ExtratorDARF.exe") do (
        echo Tamanho: %%~zA bytes (~%%~zA / 1048576 MB)
    )
    echo.
) else (
    echo [ERRO] O executavel NAO foi gerado!
    echo.
    echo O arquivo dist\ExtratorDARF.exe nao existe.
    echo.
    echo Verifique o arquivo de log: %LOGFILE%
    echo.
    echo Ultimas linhas do log:
    echo ----------------------------------------
    powershell -Command "Get-Content %LOGFILE% -Tail 30"
    echo ----------------------------------------
    echo.
)

echo Log completo salvo em: %LOGFILE%
echo.
pause


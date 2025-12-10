@echo off
REM Script mestre para gerar executável completo
REM Executa setup, verificação e build em sequência

echo ========================================
echo Gerador de Executavel - Processo Completo
echo ========================================
echo.
echo Este script ira:
echo   1. Verificar/instalar dependencias
echo   2. Verificar modelos OCR
echo   3. Gerar o executavel
echo.
echo Tempo estimado: 15-30 minutos
echo.
pause

echo.
echo ========================================
echo PASSO 1: Setup
echo ========================================
echo.

set CALLER=GERAR_EXE_COMPLETO
call setup_exe.bat
set CALLER=
set SETUP_ERROR=%ERRORLEVEL%
if %SETUP_ERROR% NEQ 0 (
    echo.
    echo AVISO: Setup retornou codigo de erro %SETUP_ERROR%.
    echo Continuando mesmo assim (podem faltar algumas dependencias opcionais)...
    echo.
)

echo.
echo ========================================
echo PASSO 2: Verificacao
echo ========================================
echo.

call verificar_antes_build.bat
set VERIFY_ERROR=%ERRORLEVEL%
if %VERIFY_ERROR% NEQ 0 (
    echo.
    echo AVISO: Verificacao retornou codigo de erro %VERIFY_ERROR%.
    echo Continuando mesmo assim (alguns componentes podem estar faltando)...
    echo.
)

echo.
echo ========================================
echo PASSO 3: Gerar Executavel
echo ========================================
echo.

set CALLER=GERAR_EXE_COMPLETO
call build_exe.bat
set CALLER=
set BUILD_ERROR=%ERRORLEVEL%
if %BUILD_ERROR% NEQ 0 (
    echo.
    echo ========================================
    echo ERRO ao gerar executavel!
    echo ========================================
    echo.
    echo Codigo de erro: %BUILD_ERROR%
    echo Verifique as mensagens acima para detalhes.
    echo.
    pause
    exit /b %BUILD_ERROR%
)

echo.
echo ========================================
echo PROCESSO COMPLETO!
echo ========================================
echo.

REM Verifica se o executavel foi gerado
if exist "dist\ExtratorDARF.exe" (
    echo [SUCESSO] O executavel foi gerado com sucesso!
    echo.
    echo Localizacao: dist\ExtratorDARF.exe
    for %%A in ("dist\ExtratorDARF.exe") do (
        echo Tamanho: %%~zA bytes (~%%~zA / 1048576 MB)
    )
    echo.
    echo Próximos passos:
    echo   1. Execute: testar_exe.bat
    echo   2. Teste todas as funcionalidades
    echo   3. Distribua apenas o arquivo .exe para usuarios
    echo.
) else (
    echo ========================================
    echo [ERRO] O executavel NAO foi gerado!
    echo ========================================
    echo.
    echo O arquivo dist\ExtratorDARF.exe nao existe.
    echo.
    echo Possiveis causas:
    echo - Erro no PyInstaller (verifique mensagens acima)
    echo - Dependencia faltando
    echo - Erro de compilacao
    echo.
    echo Verifique a pasta dist\ para ver se ha algum arquivo gerado.
    if exist "dist" (
        echo.
        echo Arquivos encontrados em dist\:
        dir /b dist\
    )
    echo.
    echo Para ver logs detalhados, execute: GERAR_EXE_DEBUG.bat
    echo.
)

echo.
echo Pressione qualquer tecla para finalizar...
pause >nul


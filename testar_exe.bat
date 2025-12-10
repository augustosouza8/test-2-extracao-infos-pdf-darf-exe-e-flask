@echo off
REM Script para testar o executável gerado

echo ========================================
echo Testando Executavel
echo ========================================
echo.

if not exist "dist\ExtratorDARF.exe" (
    echo ERRO: Executavel nao encontrado em dist\ExtratorDARF.exe
    echo.
    echo Execute build_exe.bat primeiro para gerar o executavel.
    echo.
    pause
    exit /b 1
)

echo Executando: dist\ExtratorDARF.exe
echo.
echo IMPORTANTE:
echo - O programa pode demorar alguns segundos para abrir na primeira execucao
echo - Verifique se a janela abre corretamente
echo - Teste arrastar e soltar um PDF na interface
echo - Teste processar um PDF pequeno primeiro
echo.
echo Pressione qualquer tecla para iniciar o teste...
pause >nul

echo.
echo Iniciando executavel...
start "" "dist\ExtratorDARF.exe"

echo.
echo Executavel iniciado!
echo.
echo Aguarde a janela abrir e teste as funcionalidades.
echo.
echo Para fechar este prompt, pressione qualquer tecla...
pause >nul


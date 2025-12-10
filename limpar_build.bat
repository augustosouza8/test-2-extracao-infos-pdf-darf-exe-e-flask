@echo off
REM Script para limpar builds anteriores do PyInstaller

echo ========================================
echo Limpando Builds Anteriores
echo ========================================
echo.

if exist "build" (
    echo Removendo pasta build...
    rmdir /s /q build
    echo [OK] Pasta build removida
) else (
    echo [INFO] Pasta build nao existe
)

if exist "dist" (
    echo Removendo pasta dist...
    rmdir /s /q dist
    echo [OK] Pasta dist removida
) else (
    echo [INFO] Pasta dist nao existe
)

if exist "ExtratorDARF_Fallback.spec" (
    echo Removendo arquivo .spec...
    del /q ExtratorDARF_Fallback.spec
    echo [OK] Arquivo .spec removido
) else (
    echo [INFO] Arquivo .spec nao existe
)

if exist "ExtratorDARF.spec" (
    echo Removendo arquivo .spec (versao com PyWebView)...
    del /q ExtratorDARF.spec
    echo [OK] Arquivo .spec removido
) else (
    echo [INFO] Arquivo ExtratorDARF.spec nao existe
)

echo.
echo ========================================
echo Limpeza concluida!
echo ========================================
echo.
echo Agora voce pode executar: build_exe_fallback.bat
echo.
pause


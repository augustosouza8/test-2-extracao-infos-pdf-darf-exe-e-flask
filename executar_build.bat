@echo off
REM Wrapper para executar o build_exe_fallback.bat e manter janela aberta

REM Abre uma nova janela CMD para executar o build
start "Build ExtratorDARF" cmd /k "build_exe_fallback.bat"

REM Alternativa: executar diretamente (descomente a linha abaixo e comente a de cima)
REM call build_exe_fallback.bat
REM pause


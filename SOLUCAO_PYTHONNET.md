# Solução para Problema com pythonnet/pywebview

## Problema

Ao executar `setup_exe.bat`, você pode encontrar erro ao instalar `pywebview` devido a problemas na compilação do `pythonnet`.

## Soluções

### Opção 1: Usar Versão Fallback (Recomendado - Mais Fácil)

Se `pywebview` não instalar, use a versão alternativa que abre no navegador padrão:

1. Execute `setup_exe.bat` (vai falhar no pywebview, mas instala o resto)
2. Execute `build_exe_fallback.bat` ao invés de `build_exe.bat`
3. O executável gerado (`ExtratorDARF_Fallback.exe`) abrirá no navegador padrão

**Vantagens:**
- Não precisa compilar nada
- Funciona imediatamente
- Mesma funcionalidade

**Desvantagens:**
- Abre no navegador ao invés de janela nativa
- Mostra console (pode ocultar com `--windowed` se preferir)

### Opção 2: Instalar Visual Studio Build Tools

Para compilar `pythonnet` e usar `pywebview`:

1. Baixe e instale **Visual Studio Build Tools**:
   - https://visualstudio.microsoft.com/downloads/#build-tools-for-visual-studio-2022
   - Durante instalação, selecione "Desktop development with C++"

2. Após instalar, execute novamente:
   ```cmd
   setup_exe.bat
   ```

3. Agora `pywebview` deve instalar corretamente

### Opção 3: Instalar pythonnet Manualmente

Tente instalar uma versão pré-compilada ou versão específica:

```cmd
pip install pythonnet==3.0.3
```

Ou tente instalar do wheel pré-compilado:

```cmd
pip install pythonnet --only-binary :all:
```

Depois instale pywebview:

```cmd
pip install pywebview
```

## Comparação das Versões

| Característica | build_exe.bat (pywebview) | build_exe_fallback.bat (navegador) |
|---------------|---------------------------|-----------------------------------|
| Janela nativa | ✅ Sim | ❌ Não (abre no navegador) |
| Requer compilação | ✅ Sim (pythonnet) | ❌ Não |
| Facilidade de instalação | ⚠️ Média | ✅ Fácil |
| Funcionalidade | ✅ Completa | ✅ Completa |

## Recomendação

**Use `build_exe_fallback.bat`** se:
- Você não quer instalar Visual Studio Build Tools
- Você quer uma solução rápida
- Não se importa em abrir no navegador padrão

**Use `build_exe.bat`** se:
- Você já tem Visual Studio Build Tools instalado
- Você quer uma janela nativa (mais "aplicativo desktop")
- Você não se importa em compilar dependências

## Arquivos Criados

- `run_exe_fallback.py` - Versão que usa navegador padrão
- `build_exe_fallback.bat` - Script para gerar executável fallback
- Este arquivo - Documentação da solução


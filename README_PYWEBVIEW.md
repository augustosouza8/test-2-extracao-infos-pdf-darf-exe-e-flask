# Gerar Executável com PyWebView (Janela Nativa)

## O que é PyWebView?

PyWebView cria uma janela nativa do Windows que exibe sua aplicação Flask. O resultado é um aplicativo que parece um software nativo, sem barra de endereços ou botões do navegador.

## Vantagens

- ✅ **Experiência Profissional**: Parece um software de verdade
- ✅ **Leve**: Usa WebView2 (Edge) que já vem no Windows 10/11
- ✅ **Ciclo de vida**: Quando fecha a janela, o servidor Flask morre automaticamente
- ✅ **Sem navegador**: Não abre Chrome/Firefox, usa janela nativa

## Como Gerar o Executável

### Passo 1: Configurar Ambiente

Execute:
```cmd
setup_python312_uv.bat
```

Este script:
- Instala Python 3.12 com UV
- Cria ambiente virtual
- Instala todas as dependências (incluindo PyWebView)

### Passo 2: Gerar Executável com PyWebView

Execute:
```cmd
build_exe_pywebview.bat
```

Este script:
- Ativa o ambiente virtual
- Verifica se PyWebView está instalado
- Gera o executável usando `run_exe.py` (com PyWebView)

## Resultado

O executável `dist\ExtratorDARF.exe`:
- Abre uma janela nativa do Windows
- Título: "Extrator DARF"
- Sem barra de endereços
- Sem botões de navegação
- Fecha automaticamente quando você clica no X

## Diferença entre Versões

| Versão | Arquivo | Comportamento |
|--------|---------|---------------|
| **PyWebView** | `build_exe_pywebview.bat` | Janela nativa do Windows |
| **Navegador** | `build_exe_com_venv.bat` | Abre no Chrome/Firefox padrão |

## Solução de Problemas

### PyWebView não instala

PyWebView requer `pythonnet` que pode precisar compilação no Windows. Se falhar:

1. **Instale Visual Studio Build Tools:**
   - Baixe: https://visualstudio.microsoft.com/downloads/
   - Instale "Desktop development with C++"

2. **Ou use a versão navegador:**
   ```cmd
   build_exe_com_venv.bat
   ```

### Erro ao executar

Se o executável não abrir a janela:
- Verifique se WebView2 está instalado (já vem no Windows 10/11)
- Tente executar como administrador
- Verifique os logs no console

## Teste

Após gerar o executável:
```cmd
dist\ExtratorDARF.exe
```

Você deve ver uma janela nativa com o título "Extrator DARF" abrindo automaticamente.


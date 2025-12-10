# Solução: Python 3.14 e onnxruntime

## Problema
O `onnxruntime` não tem builds disponíveis para Python 3.14. A versão mais recente suportada é Python 3.12.

## Soluções

### Opção 1: Usar Python 3.11 ou 3.12 (Recomendado)

1. **Instale Python 3.11 ou 3.12:**
   - Baixe de: https://www.python.org/downloads/
   - Durante a instalação, marque "Add Python to PATH"

2. **Verifique a versão:**
   ```cmd
   python --version
   ```
   Deve mostrar Python 3.11.x ou 3.12.x

3. **Instale as dependências:**
   ```cmd
   python -m pip install -r requirements.txt
   ```

4. **Execute o build:**
   ```cmd
   build_exe_fallback.bat
   ```

### Opção 2: Usar ambiente virtual com Python 3.12

Se você precisa manter Python 3.14 para outros projetos:

1. **Instale Python 3.12** (pode coexistir com 3.14)

2. **Crie um ambiente virtual com Python 3.12:**
   ```cmd
   py -3.12 -m venv venv_py312
   ```

3. **Ative o ambiente:**
   ```cmd
   venv_py312\Scripts\activate
   ```

4. **Instale as dependências:**
   ```cmd
   pip install -r requirements.txt
   ```

5. **Execute o build:**
   ```cmd
   build_exe_fallback.bat
   ```

### Opção 3: Aguardar suporte para Python 3.14

O `onnxruntime` pode adicionar suporte para Python 3.14 no futuro. Você pode:
- Verificar atualizações em: https://pypi.org/project/onnxruntime/
- Monitorar o repositório: https://github.com/microsoft/onnxruntime

## Verificação Rápida

Para verificar qual versão do Python está sendo usada:
```cmd
python --version
```

Para verificar se onnxruntime está disponível para sua versão:
```cmd
python -m pip index versions onnxruntime
```

## Recomendação

**Use Python 3.12** - é a versão mais recente com suporte completo para todas as dependências do projeto, incluindo `onnxruntime`.


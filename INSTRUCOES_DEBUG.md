# Instruções para Debug do Build

## Problema: Script fecha sem gerar executável

Se o `GERAR_EXE_COMPLETO.bat` fecha sem gerar o executável, siga estes passos:

### Opção 1: Usar Script de Debug

Execute o script com logs detalhados:

```cmd
GERAR_EXE_DEBUG.bat
```

Este script:
- Salva todos os logs em um arquivo
- Mostra mensagens detalhadas
- Não fecha automaticamente
- Mostra as últimas linhas do log se falhar

### Opção 2: Teste Simples

Execute o teste básico:

```cmd
TESTE_BUILD_SIMPLES.bat
```

Este script testa apenas o essencial para verificar se o PyInstaller funciona.

### Opção 3: Executar Passo a Passo Manualmente

1. Execute apenas o build:
   ```cmd
   build_exe.bat
   ```

2. Veja as mensagens de erro
3. Verifique se há arquivos em `dist\`

### Opção 4: Verificar Erros Comuns

#### Erro: "ModuleNotFoundError"
- Solução: Execute `setup_exe.bat` novamente

#### Erro: "No module named 'PyQt6'"
- Solução: `pip install PyQt6`

#### Erro: "No module named 'app.gui.main_window'"
- Verifique se o arquivo `app\gui\main_window.py` existe
- Verifique se está executando na pasta correta

#### Erro: PyInstaller não encontrado
- Solução: `pip install pyinstaller`

### Opção 5: Verificar Logs do PyInstaller

O PyInstaller gera logs em:
- `build\ExtratorDARF\warn-ExtratorDARF.txt` - Avisos
- Saída no console durante o build

### Opção 6: Testar Python e Imports

Execute:
```cmd
python -c "from app.gui.main_window import MainWindow; print('OK')"
```

Se isso falhar, há um problema no código que precisa ser corrigido antes de gerar o executável.

## Informações para Debug

Se ainda não funcionar, colete estas informações:

1. Versão do Python:
   ```cmd
   python --version
   ```

2. PyInstaller instalado:
   ```cmd
   python -m PyInstaller --version
   ```

3. PyQt6 instalado:
   ```cmd
   python -c "from PyQt6.QtCore import PYQT_VERSION_STR; print(PYQT_VERSION_STR)"
   ```

4. Arquivos em dist\:
   ```cmd
   dir dist\
   ```

5. Últimas linhas do log (se usar GERAR_EXE_DEBUG.bat)

